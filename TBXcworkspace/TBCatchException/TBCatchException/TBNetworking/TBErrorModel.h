//
//  TBErrorModel.h
//  TBExceptionFramework
//
//  Created by 郭明健 on 2018/9/4.
//  Copyright © 2018年 GuoMingJian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBErrorModel : NSObject

@property (nonatomic, assign) NSInteger errorTime;          /**<yyyyMMddHHmmss（崩溃时间：时间戳)*/
@property (nonatomic, assign) NSInteger errorType;          /**<0:卡顿 1:崩溃 2:错误 3:javascript 4:http*/
@property (nonatomic, copy  ) NSString  *appVersion;        /**<APP版本（不带V）*/
@property (nonatomic, copy  ) NSString  *appCode;           /**<APP编号（运营系统中的唯一APPcode）*/
@property (nonatomic, copy  ) NSString  *macAddress;        /**<手机物理地址*/
@property (nonatomic, copy  ) NSString  *ip;                /**<ip地址*/
@property (nonatomic, assign) NSInteger deviceType;         /**<设备类型（1:手机,2:平板）*/
@property (nonatomic, assign) NSInteger systemType;         /**<操作系统类型（0:iOS,1:安卓）*/
@property (nonatomic, copy  ) NSString  *mobileModel;       /**<手机型号*/
@property (nonatomic, copy  ) NSString  *systemVersion;     /**<手机系统*/
@property (nonatomic, copy  ) NSString  *network;           /**<手机运营商（中国移动、联通、电信）*/
@property (nonatomic, assign) NSString  *errorCode;         /**<（暂时：与errorType相同）*/
@property (nonatomic, copy  ) NSString  *errorMessage;      /**<错误信息*/
//errorType是javascript（以下参数由JS带过来）
@property (nonatomic, copy  ) NSString  *classify;          /**<分类：如果是JS报错就填 "H5"，反之 "native"。*/
@property (nonatomic, copy  ) NSString  *stack;             /**<H5错误位置*/
@property (nonatomic, copy  ) NSString  *h5Url;             /**<h5Url*/
//errorType是http
@property (nonatomic, copy  ) NSString  *requestUrl;        /**<请求URL*/
@property (nonatomic, copy  ) NSString  *methodType;        /**<请求类型 GET,POST,PUT,DELETE*/
@property (nonatomic, assign) NSInteger responseStatus;     /**<响应状态（404、500）*/
@property (nonatomic, copy  ) NSString  *responseMessage;   /**<响应内容*/
//浏览器name（貌似iOS用不到吧..）
@property (nonatomic, copy  ) NSString  *browser;           /**<浏览器名字*/

#pragma mark -

+ (TBErrorModel *)getModel;

+ (NSMutableDictionary *)getClientErrorParam:(TBErrorModel *)model;

#pragma mark - 

/**
 NSDate 转 时间戳
 */
+ (NSInteger)stampByDate:(NSDate *)date;

/**
 时间戳 转 NSString
 */
+ (NSString *)dateStringByStamp:(NSString *)stamp;

@end

/*
 responseStatus:
 
 200:客户端请求成功
 401:访问被拒绝
 403:禁止访问
 404:未找到web站点
 500:内部服务器错误
 */
