//
//  TBExceptionManager.h
//  TBExceptionFramework
//
//  Created by 郭明健 on 2018/8/24.
//  Copyright © 2018年 GuoMingJian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBExceptionManager : NSObject

//appCode、macAddress为必传数据
@property (nonatomic, copy) NSString *appCode;
@property (nonatomic, copy) NSString *macAddress;

+ (instancetype)sharedInstance;

/**
 *  启动异常搜集
 */
- (void)startCollectCrashLogs;

/**
 *  是否关闭日志打印，默认开启。
 */
- (void)setLogOFF:(BOOL)isOFF;

/**
 *  主动向后台发送错误数据
 */
- (void)sendErrorInfoToBackground:(NSDictionary *)errorInfoDict;

/**
 上传设备信息
 */
- (void)uploadDeviceMessageComplete:(void(^)(id result, NSError *error))complete;

/**
 异常监控-错误信息上传（try-catch）
 */
- (void)uploadErrorMsg:(NSException *)exception;

@end
