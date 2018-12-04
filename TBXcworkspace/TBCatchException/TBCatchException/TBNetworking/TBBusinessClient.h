//
//  TBBusinessClient.h
//  TBExceptionFramework
//
//  Created by 郭明健 on 2018/9/4.
//  Copyright © 2018年 GuoMingJian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBBusinessClient : NSObject

+ (instancetype)sharedInstance;

/**
 上传异常信息到服务器；客户端异常、JS异常只是param不同。
 
 @param param 异常信息
 @param complete 完成回调
 */
- (void)uploadClientErrorWithParam:(NSDictionary *)param
                          complete:(void(^)(id result, NSError *error))complete;

/**
 获取设备信息接口
 
 @param param 参数
 @param complete 完成回调
 */
- (void)getDeviceMessageWithParam:(NSDictionary *)param
                         complete:(void(^)(id result, NSError *error))complete;

@end
