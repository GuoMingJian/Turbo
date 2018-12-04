//
//  TBTouchIDManager.h
//  ZXToolProjects
//
//  Created by 郭明健 on 2018/7/6.
//  Copyright © 2018年 GuoMingJian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface TBTouchIDManager : NSObject

/**
 设置指纹错误后的右侧按钮文字，默认文字为：验证登录密码
 
 @param title 验证登录密码
 */
- (void)setLocalizedFallbackTitle:(NSString *)title;

/**
 验证设备是否支持Touch ID
 
 @param policy 默认LAPolicyDeviceOwnerAuthenticationWithBiometrics
 @param error 错误信息
 @return YES/NO
 */
- (BOOL)canEvaluatePolicy:(LAPolicy)policy error:(NSError * __autoreleasing *)error __attribute__((swift_error(none)));

/**
 验证Touch ID
 
 @param policy 默认LAPolicyDeviceOwnerAuthenticationWithBiometrics
 @param localizedReason 标题
 @param reply 验证结果
 */
- (void)evaluatePolicy:(LAPolicy)policy localizedReason:(NSString *)localizedReason reply:(void(^)(BOOL success, NSError * __nullable error))reply;

@end

/**
 1:LAPolicyDeviceOwnerAuthenticationWithBiometrics :
 生物指纹识别。验证弹框有两个按钮，第一个是取消按钮，第二个按钮可以自定义标题名称（输入密码）。只有在第一次指纹验证失败后才会出现第二个按钮，这种鉴定方式的第二个按钮的功能自定义。前三次指纹验证失败，指纹验证框不再弹出。再次重新进入验证，还有两次验证机会，如果还是验证失败，TOUCH ID 被锁住不再继续弹出指纹验证框。以后的每次验证都将会弹出设备密码输入框直至输入正确的设备密码方可解除TOUCH ID锁。
 
 2:LAPolicyDeviceOwnerAuthentication:
 生物指纹识别或系统密码验证。如果TOUCH ID 可用，且已经录入指纹，则优先调用指纹验证。其次是调用系统密码验证，如果没有开启设备密码，则不可以使用这种验证方式。指纹识别验证失败三次将弹出设备密码输入框，如果不进行密码输入。再次进来还可以有两次机会验证指纹，如果都失败则TOUCH ID被锁住，以后每次进来验证都是调用系统的设备密码直至输入正确的设备密码方可解除TOUCH ID锁。
 */
