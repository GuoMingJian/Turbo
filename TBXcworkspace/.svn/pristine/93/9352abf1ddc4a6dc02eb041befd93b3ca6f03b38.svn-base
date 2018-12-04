//
//  TBAuthentication.h
//  TBBusiness
//
//  Created by Apple on 2018/10/23.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *  认证枚举
 */
typedef NS_ENUM(NSInteger) {
    TBAuthenticationNotValid    = -1,// 无法使用TouchID/FaceID
    TBAuthenticationSuccess     = 0,// 认证成功
    TBAuthenticationFailed      = 1,// 认证失败
    TBErrorUserCancel           = 2,// 用户主动取消
    TBErrorUserFallback         = 3,// 用户使用密码输入
    TBErrorSystemCancel         = 4,// 被系统取消
    TBErrorPasscodeNotSet       = 5,// 无法使用，因为用户没有设置密码
    TBErrorAppCancel            = 6,// APP被挂起并取消了授权（APP进入了后台）
    TBErrorInvalidContext       = 7,// 传递给此调用的LAContext以前已失效
    TBErrorBiometryNotAvailable = 8,// FaceID无效（用于iPhone X以上系列手机）
    TBErrorTouchIDNotAvailable  = 9,// TouchID无效
    TBErrorBiometryNotEnrolled  = 10,// 没有注册FaceID（用于iPhone X以上系列手机）
    TBErrorTouchIDNotEnrolled   = 11,// 没有注册TouchID
    TBErrorBiometryLockout      = 12,// FaceID被锁定，需要密码（用于iPhone X以上系列手机）
    TBErrorTouchIDLockout       = 13,// TouchID被锁定，需要密码
    TBErrorNotInteractive       = 14 // 代码禁止了APP使用TouchID，FaceID（使用了interactionNotAllowed属性）
}TBAuthenticationStatus;

/**
 *  识别回调（枚举值 + error）
 */
typedef void(^authenticationBlock)(NSInteger status, NSError *error);

@interface TBAuthentication : NSObject
/**
 *  @param description 用于弹窗描述，可以不传，实现函数埋设了默认值
 *  @param block 执行回调
 */
+(void)startRecognizeWithDescription:(NSString *)description callBack:(authenticationBlock)block;
@end

NS_ASSUME_NONNULL_END
