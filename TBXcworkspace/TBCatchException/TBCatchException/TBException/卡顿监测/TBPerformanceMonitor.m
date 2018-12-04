//
//  TBPerformanceMonitor.m
//  TBPerformanceMonitor
//
//  Created by 郭明健 on 2018/11/6.
//  Copyright © 2018 GuoMingJian. All rights reserved.
//

#import "TBPerformanceMonitor.h"

@implementation TBPerformanceMonitor
{
    int timeoutCount;
    CFRunLoopObserverRef observer;
@public
    dispatch_semaphore_t semaphore;
    CFRunLoopActivity activity;
}

+ (instancetype)sharedInstance
{
    return [[TBPerformanceMonitor alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static TBPerformanceMonitor *monitor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (monitor == nil)
        {
            monitor = [super allocWithZone:zone];
        }
    });
    return monitor;
}

#pragma mark - setup

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    TBPerformanceMonitor *moniotr = (__bridge TBPerformanceMonitor*)info;
    moniotr->activity = activity;
    dispatch_semaphore_t semaphore = moniotr->semaphore;
    dispatch_semaphore_signal(semaphore);
}

- (void)start
{
    if (observer)
    {
        return;
    }
    
    //信号
    semaphore = dispatch_semaphore_create(0);
    
    //注册RunLoop状态观察
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                       kCFRunLoopAllActivities,
                                       YES,
                                       0,
                                       &runLoopObserverCallBack,
                                       &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    
    //在子线程监控时长
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES)
        {
            /**
             卡顿需要覆盖到多次连续小卡顿和单次长时间卡顿两种情景,所以判定条件也需要做适当优化.
             */
            //设置每次50毫秒，初定5次。若超过5次或者单次时长超过（5x50）则认为卡顿。
            long st = dispatch_semaphore_wait(self->semaphore, dispatch_time(DISPATCH_TIME_NOW, catonOnceTime * NSEC_PER_MSEC));
            if (st != 0)
            {
                if (!self->observer)
                {
                    self->timeoutCount = 0;
                    self->semaphore = 0;
                    self->activity = 0;
                    return;
                }
                
                if (self->activity == kCFRunLoopBeforeSources || self->activity == kCFRunLoopAfterWaiting)
                {
                    if (++self->timeoutCount < catomCount)
                        continue;
                    //上传卡顿信息到服务器
                    [self uploadCatonMassage];
                }
            }
            self->timeoutCount = 0;
        }
    });
}

- (void)stop
{
    if (!observer)
    {
        return;
    }
    //
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    CFRelease(observer);
    observer = NULL;
}

#pragma mark - 上传卡顿信息到服务器

- (void)uploadCatonMassage
{
    PLCrashReporterConfig *config = [[PLCrashReporterConfig alloc] initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeBSD
                                                                       symbolicationStrategy:PLCrashReporterSymbolicationStrategyAll];
    PLCrashReporter *crashReporter = [[PLCrashReporter alloc] initWithConfiguration:config];
    
    NSData *data = [crashReporter generateLiveReport];
    PLCrashReport *reporter = [[PLCrashReport alloc] initWithData:data error:NULL];
    NSString *report = [PLCrashReportTextFormatter stringValueForCrashReport:reporter
                                                              withTextFormat:PLCrashReportTextFormatiOS];
    //NSLog(@"------------\n%@\n------------", report);
    @try {
        //获取崩溃线程
        NSRange range = [report rangeOfString:@"Crashed Thread:"];
        NSRange zoreRange = [report rangeOfString:@"Thread 0:"];
        NSInteger numbStr = [[report substringWithRange:NSMakeRange(range.location + range.length, (zoreRange.location - range.location - range.length))] integerValue];
        //获取崩溃线程堆栈
        NSString *beginStr = [NSString stringWithFormat:@"Thread %ld Crashed:", (long)numbStr];
        NSRange beginRange = [report rangeOfString:beginStr];
        NSInteger beginIndex = beginRange.location;
        //
        NSString *newStr = [report substringFromIndex:beginIndex];
        NSString *endStr = @"\n\n";
        NSRange endRange = [newStr rangeOfString:endStr];
        NSInteger endIndex = endRange.location;
        NSRange msgRange = NSMakeRange(0, endIndex);
        NSString *crashedThreadMsg = [newStr substringWithRange:msgRange];
        //NSLog(@"%@", crashedThreadMsg);
        crashedThreadMsg = [NSString stringWithFormat:@"\n%@\n", crashedThreadMsg];
        NSArray *array = [crashedThreadMsg componentsSeparatedByString:@"\n"];
        NSString *errorCode = array.count >= 3 ? array[2] : @"";
        /**
         *  API
         */
        TBErrorModel *model = [TBErrorModel getModel];
        model.appCode = self.appCode;
        model.macAddress = self.macAddress;
        model.errorType = 0;//卡顿
        model.errorCode = errorCode;
        model.errorMessage = crashedThreadMsg.length > 0 ? crashedThreadMsg : @"发生UI卡顿";
        NSMutableDictionary *errorInfo = [TBErrorModel getClientErrorParam:model];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[TBBusinessClient sharedInstance] uploadClientErrorWithParam:errorInfo complete:^(id result, NSError *error) {
                NSLog(@"异常监控-卡顿：%@", result);
            }];
        });
    } @catch (NSException *exception) {
        //如果截取崩溃线程msg报错，则上传错误API。
        TBExceptionManager *manager = [TBExceptionManager sharedInstance];
        manager.appCode = self.appCode;
        manager.macAddress = self.macAddress;
        [manager uploadErrorMsg:exception];
    } @finally {
    }
    
}

@end
