//
//  TBSession.h
//  TBExceptionFramework
//
//  Created by 郭明健 on 2018/9/3.
//  Copyright © 2018年 GuoMingJian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 API 业务类型
 */
typedef NS_ENUM(NSUInteger, BusinessType) {
    BusinessType_MonitorError = 0,      //异常监控
    BusinessType_GetDeviceMessage,      //获取设备信息接口
};

/**
 接口回调
 
 @param result 返回数据
 @param error 错误信息
 */
typedef void(^RequestBlock)(id result, NSError *error);

@interface TBSession : NSObject

+ (instancetype)sharedInstance;

/**
 开始请求接口
 
 @param url 接口url
 @param param 接口参数
 @param type 接口业务类型
 @param resultsBlock 接口回调
 */
- (void)requestUrl:(NSString *)url
             param:(NSMutableDictionary *)param
      businessType:(BusinessType)type
      resultsBlock:(RequestBlock)resultsBlock;

/**
 取消接口请求
 */
- (void)cancel;

@end
