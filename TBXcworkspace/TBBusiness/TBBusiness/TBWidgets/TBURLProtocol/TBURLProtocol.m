//
//  TBURLProtocol.m
//  TBBusiness
//
//  Created by Apple on 2018/2/8.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TBURLProtocol.h"

@interface TBCacheConfig : NSObject
@property (nonatomic, strong) NSURLSessionConfiguration *config;
// 记录上一次的请求时间
@property (nonatomic, strong) NSMutableDictionary *urlMutDict;
// 相同的url地址请求，相隔大于等于updateInterval才会发出后台更新的网络请求，小于的话不发出请求。
@property (readwrite, nonatomic, assign) NSInteger updateInterval;
@property (nonatomic, strong) NSOperationQueue *foregroundNetQueue;
@property (nonatomic, strong) NSOperationQueue *backgroundNetQueue;

@end

#define UPDATE_INTERVAL 3600

@implementation TBCacheConfig
#pragma mark - 懒加载config
-(NSURLSessionConfiguration *)config {
    if (!_config) {
        _config = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    return _config;
}

#pragma mark - 懒加载urlMutDict
-(NSMutableDictionary *)urlMutDict {
    if (!_urlMutDict) {
        _urlMutDict = [NSMutableDictionary dictionary];
    }
    return _urlMutDict;
}

#pragma mark - 懒加载foregroundNetQueue
-(NSOperationQueue *)foregroundNetQueue {
    if (!_foregroundNetQueue) {
        _foregroundNetQueue = [[NSOperationQueue alloc] init];
        _foregroundNetQueue.maxConcurrentOperationCount = 10;
    }
    return _foregroundNetQueue;
}

#pragma mark - 懒加载backgroundNetQueue
-(NSOperationQueue *)backgroundNetQueue {
    if (!_backgroundNetQueue) {
        _backgroundNetQueue = [[NSOperationQueue alloc] init];
        _backgroundNetQueue.maxConcurrentOperationCount = 6;
    }
    return _backgroundNetQueue;
}

#pragma mark - 设置单例
+(instancetype)shareInstance {
    static TBCacheConfig *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instance) {
            _instance = [[TBCacheConfig alloc] init];
        }
    });
    return _instance;
}

#pragma mark - 设置更新时间
-(NSInteger)updateInterval {
    if (_updateInterval == 0) {
        _updateInterval = UPDATE_INTERVAL;
    }
    return _updateInterval;
}

#pragma mark - 清空数据
-(void)clearUrlMutDict {
    [[TBCacheConfig shareInstance].urlMutDict removeAllObjects];
    [TBCacheConfig shareInstance].urlMutDict = nil;
}

@end

static NSString * const URLProtocolAlreadyHandleKey = @"alreadyHandle";
static NSString * const checkUpdateInBgKey = @"checkUpdateInBg";

@interface TBURLProtocol ()
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSMutableData *data;
@end

@implementation TBURLProtocol

#pragma mark - 注册
+ (void)startListeningNetWorking {
    [NSURLProtocol registerClass:self];
}

#pragma mark - 取消注册
+ (void)cancelListeningNetWorking {
    [NSURLProtocol unregisterClass:self];
}

#pragma mark - 清空TBCacheConfig数据
+ (void)clearUrlMutDict {
    [[TBCacheConfig shareInstance] clearUrlMutDict];
}

#pragma mark - 重设TBCacheConfig的NSURLSessionConfiguration
+ (void)setConfig:(NSURLSessionConfiguration *)config {
    [[TBCacheConfig shareInstance] setConfig:config];
}

#pragma mark - 重设TBCacheConfig的UpdateInterval
+ (void)setUpdateInterval:(NSUInteger)updateInterval {
    [[TBCacheConfig shareInstance] setUpdateInterval:updateInterval];
}

/**
 *  @不要在这里操作request！
 *  这个方法主要说明你是否打算处理对应的request，如果不打算处理，直接返回NO；
 *  如果打算处理，返回YES，在canonicalRequestForRequest中处理request；
 */
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSString *urlScheme = [[request URL] scheme];
    if ([urlScheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
        [urlScheme caseInsensitiveCompare:@"https"] == NSOrderedSame) {
        // 判断是否标记过使用缓存处理，或者是否有标记后台更新？？
        if ([NSURLProtocol propertyForKey:URLProtocolAlreadyHandleKey inRequest:request] ||
            [NSURLProtocol propertyForKey:checkUpdateInBgKey inRequest:request]) {
            return NO;
        }
    }
    return YES;
}

/**
 *  @可以增加请求头header，也可以直接返回；
 */
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)startLoading {
    NSCachedURLResponse *urlResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:[self request]];
    if (urlResponse) {
        // 如果存在缓存，则使用，并开启异步线程更新缓存！
        [self.client URLProtocol:self didReceiveResponse:urlResponse.response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [self.client URLProtocol:self didLoadData:urlResponse.data];
        [self.client URLProtocolDidFinishLoading:self];
        // 异步更新
        [self backgroundCheckUpdate];
        return;
    }
    
    NSMutableURLRequest *mutURLRequest = [[self request] mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:checkUpdateInBgKey inRequest:mutURLRequest];
    [self netRequest:mutURLRequest];
}


- (void)stopLoading {
    [self.session invalidateAndCancel];
    self.session = nil;
}

- (void)netRequest:(NSURLRequest *)request {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[[TBCacheConfig shareInstance] foregroundNetQueue]];
    NSURLSessionDataTask *sessionDataTask = [self.session dataTaskWithRequest:request];
    
    [[TBCacheConfig shareInstance].urlMutDict setValue:[NSDate date] forKey:self.request.URL.absoluteString];
    [sessionDataTask resume];
}

#pragma mark - 后台更新
- (void)backgroundCheckUpdate{
    __weak typeof(self) weakSelf = self;
    [[[TBCacheConfig shareInstance] backgroundNetQueue] addOperationWithBlock:^{
        NSDate *updateDate = [[TBCacheConfig shareInstance].urlMutDict objectForKey:weakSelf.request.URL.absoluteString];
        if (updateDate) {
            // 判读两次相同的url地址发出请求相隔的时间，如果相隔的时间小于给定的时间，不发出请求；否则发出网络请求
            NSDate *currentDate = [NSDate date];
            NSInteger interval = [currentDate timeIntervalSinceDate:updateDate];
            if (interval < [TBCacheConfig shareInstance].updateInterval) {
                return;
            }
        }
        NSMutableURLRequest *mutableRequest = [[weakSelf request] mutableCopy];
        [NSURLProtocol setProperty:@YES forKey:checkUpdateInBgKey inRequest:mutableRequest];
        [weakSelf netRequest:mutableRequest];
        
    }];
}

#pragma mark - NSURLSessionDataDelegate方法
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    [self.client URLProtocol:self didLoadData:data];
    
    [self appendData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    self.response = response;
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (error) {
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [self.client URLProtocolDidFinishLoading:self];
        if (!self.data) {
            return;
        }
        NSCachedURLResponse *cacheUrlResponse = [[NSCachedURLResponse alloc] initWithResponse:task.response data:self.data];
        [[NSURLCache sharedURLCache] storeCachedResponse:cacheUrlResponse forRequest:self.request];
        self.data = nil;
    }
}

- (void)appendData:(NSData *)newData
{
    if ([self data] == nil) {
        [self setData:[newData mutableCopy]];
    }
    else {
        [[self data] appendData:newData];
    }
}
@end
