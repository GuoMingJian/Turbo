//
//  TBTouchIDManager.m
//  ZXToolProjects
//
//  Created by 郭明健 on 2018/7/6.
//  Copyright © 2018年 GuoMingJian. All rights reserved.
//

#import "TBTouchIDManager.h"

@interface TBTouchIDManager()

@property (nonatomic, strong) LAContext *myContext;

@end

@implementation TBTouchIDManager

- (id)init
{
    if (self = [super init])
    {
        self.myContext = [LAContext new];
        /**
         * 这个属性用来设置指纹错误后的弹出框的按钮文字
         * 不设置, 默认文字为“验证登录密码”
         * 设置@"" 将不会显示指纹错误后的弹出框
         */
        self.myContext.localizedFallbackTitle = @"验证登录密码";
    }
    return self;
}

#pragma mark - Api

/**
 设置指纹错误后的右侧按钮文字，默认文字为：验证登录密码
 
 @param title “验证登录密码”
 */
- (void)setLocalizedFallbackTitle:(NSString *)title
{
    self.myContext.localizedFallbackTitle = title;
}

/**
 验证设备是否支持Touch ID
 
 @param policy 默认LAPolicyDeviceOwnerAuthentication
 @param error 错误信息
 @return YES/NO
 */
- (BOOL)canEvaluatePolicy:(LAPolicy)policy error:(NSError * __autoreleasing *)error __attribute__((swift_error(none)))
{
    BOOL result = [self.myContext canEvaluatePolicy:policy error:error];
    return result;
}

/**
 验证Touch ID
 
 @param policy 默认LAPolicyDeviceOwnerAuthentication
 @param localizedReason 标题
 @param reply 验证结果
 */
- (void)evaluatePolicy:(LAPolicy)policy localizedReason:(NSString *)localizedReason reply:(void(^)(BOOL success, NSError * __nullable error))reply
{
    return [self.myContext evaluatePolicy:policy localizedReason:localizedReason reply:reply];
}

@end
