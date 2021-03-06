//
//  TBInfo.h
//  TBExceptionFramework
//
//  Created by 郭明健 on 2018/8/24.
//  Copyright © 2018年 GuoMingJian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

@interface TBInfo : NSObject

/**
 当前APP名称
 */
+ (NSString *)appName;

/**
 获取APP 版本
 */
+ (NSString *)appVersion;

/**
 获取APP Build
 */
+ (NSString *)appBuild;

/**
 获取APP Bundle Identifier
 */
+ (NSString *)appBundleIdentifier;

/**
 手机名称
 */
+ (NSString *)iPhoneName;

/**
 手机型号
 */
+ (NSString *)iPhoneModel;

/**
 手机系统版本
 */
+ (NSString *)iPhoneSystemVersion;

/**
 手机电量
 */
+ (int)iPhoneBatteryLevel;

/**
 手机状态栏网络[注意：网络切换时，手机状态栏改变较慢(非实时)]
 [@"无网络",@"2G",@"3G",@"4G",@"WiFi"]
 */
+ (NSString *)iPhoneNetworkState;

/**
 当前手机连接网络的ip地址
 */
+ (NSString *)iPhoneIpAddresses;

/**
 手机UUID(Universally Unique Identifier) 通用唯一识别码
 */
+ (NSString *)iPhoneUUID;

/**
 是否越狱
 */
+ (BOOL)isJailBreak;

/**
 获取本机运营商名称
 */
+ (NSString *)carrierName;

@end
