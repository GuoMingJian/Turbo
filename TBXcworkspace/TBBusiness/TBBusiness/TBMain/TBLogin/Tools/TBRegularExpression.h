//
//  TBRegularExpression.h
//  TBBusiness
//
//  Created by 郭明健 on 2018/10/29.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TBRegularExpression : NSObject

#pragma mark - Regular Expressions[正则表达式]

/**
 判断传入的数据在传入的正则表达式中是否正确
 */
+ (BOOL)isRightExpression:(NSString *)expression
                    value:(NSString *)value;

/**
 手机号
 */
+ (BOOL)isMobileNumber:(NSString *)value;

/**
 中国移动(China Mobile)
 */
+ (BOOL)isChinaMobile:(NSString *)phoneNum;

/**
 中国联通(China Unicom)
 */
+ (BOOL)isChinaUnicom:(NSString *)phoneNum;

/**
 中国电信(China Telecom)
 */
+ (BOOL)isChinaTelecom:(NSString *)phoneNum;

/**
 手机运营商[中国移动,中国联通,中国电信]
 */
+ (NSString *)getPhoneNumType:(NSString *)phoneNum;

/**
 是否为邮箱
 */
+ (BOOL)isEmail:(NSString *)email;

/**
 是否为身份证号[15或18位]
 */
+ (BOOL)isIdCard:(NSString *)idCard;

/**
 加权因子判断身份证号[15或18位]
 */
+ (BOOL)isIdCard2:(NSString *)idCard;

/**
 是否是中文
 */
+ (BOOL)isChinese:(NSString *)value;

/**
 金额校验，精确到2位小数
 */
+ (BOOL)isMoney:(NSString *)value;

/**
 车牌号码
 */
+ (BOOL)isCarNo:(NSString *)carNum;

/**
 用户名[字母，数字(长度4-20)]
 */
+ (BOOL)isUserName:(NSString *)username;

/**
 密码[字母，数字(长度6-20)]
 */
+ (BOOL)isPassword:(NSString *)pwd;

@end

NS_ASSUME_NONNULL_END
