//
//  TBPerformanceMonitor.h
//  TBPerformanceMonitor
//
//  Created by 郭明健 on 2018/11/6.
//  Copyright © 2018 GuoMingJian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CrashReporter/CrashReporter.h>
#import "TBHeader.h"

NS_ASSUME_NONNULL_BEGIN

/**
 自定义卡顿时间:
 卡顿需要覆盖到多次连续小卡顿和单次长时间卡顿两种情景（判定条件也需要做适当优化）。
 设置每次50毫秒，初定5次。若超过5次或者单次时长超过（5x50）则认为卡顿。
 */
#define catonOnceTime 50    //单次小卡顿时间（毫秒）
#define catomCount 5        //次

@interface TBPerformanceMonitor : NSObject

//appCode、macAddress为必传数据
@property (nonatomic, copy) NSString *appCode;
@property (nonatomic, copy) NSString *macAddress;

+ (instancetype)sharedInstance;

/**
 启动监测卡顿
 */
- (void)start;

/**
 停止监测卡顿
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
