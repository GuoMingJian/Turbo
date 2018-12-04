//
//  TBBusinessClient.m
//  TBExceptionFramework
//
//  Created by 郭明健 on 2018/9/4.
//  Copyright © 2018年 GuoMingJian. All rights reserved.
//

#import "TBBusinessClient.h"
#import "TBSession.h"

#define kAPI_MonitorError @"/operate/monitor/monitorError"
//获取设备信息接口
#define kAPI_GetDeviceMessage @"/operate/monitor/getDeviceMessage"

@implementation TBBusinessClient

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static TBBusinessClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (client == nil) {
            client = [super allocWithZone:zone];
        }
    });
    return client;
}

+ (instancetype)sharedInstance
{
    return [[TBBusinessClient alloc] init];
}

#pragma mark - API

/**
 上传异常信息到服务器；客户端异常、JS异常只是param不同。
 
 @param param 异常信息
 @param complete 完成回调
 */
- (void)uploadClientErrorWithParam:(NSDictionary *)param
                          complete:(void(^)(id result, NSError *error))complete
{
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:param];
    [[TBSession sharedInstance] requestUrl:kAPI_MonitorError param:dictM businessType:BusinessType_MonitorError resultsBlock:^(id result, NSError *error) {
        complete(result, error);
    }];
}

/**
 获取设备信息接口
 
 @param param 参数
 @param complete 完成回调
 */
- (void)getDeviceMessageWithParam:(NSDictionary *)param
                         complete:(void(^)(id result, NSError *error))complete
{
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:param];
    [[TBSession sharedInstance] requestUrl:kAPI_GetDeviceMessage param:dictM businessType:BusinessType_GetDeviceMessage resultsBlock:^(id result, NSError *error) {
        complete(result, error);
    }];
}

@end
