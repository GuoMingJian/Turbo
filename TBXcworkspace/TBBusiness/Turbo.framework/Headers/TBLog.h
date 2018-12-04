//
//  TBLog.h
//  Turbo
//
//  Created by Apple on 2018/3/29.
//  Copyright © 2018年 Apple. All rights reserved.
//

#ifndef TBLog_h
#define TBLog_h

// 日志打印
#ifdef DEBUG
#define TBLog(frmt,...)  do {    \
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];\
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];\
    NSString *time = [dateFormatter stringFromDate:[NSDate date]];\
    NSString *msg = [NSString stringWithFormat:@"%@ %s [line:%d] %@", time, __FUNCTION__, __LINE__, frmt];\
    printf("%s\n",[msg UTF8String]);\
} while(0)
#else
#define TBLog(...)
#endif

// 日志记录（记录的格式为："时间+" + "函数名+行号+内容"）
#ifdef DEBUG
#define TBRecordLog(frmt,...) [TBLogManager writeLog:[NSString stringWithFormat:@"%s [line:%d] %@", __FUNCTION__, __LINE__, frmt]]
#else
#define TBRecordLog(...)
#endif

// 类释放打印语句
#ifdef DEBUG
#define TBDeallocMark(...) do {  \
    NSLog(@"-->【%@已销毁】",NSStringFromClass([self class]));    \
} while(0)
#else
#define TBDeallocMark(...)
#endif

#endif /* TBLog_h */
