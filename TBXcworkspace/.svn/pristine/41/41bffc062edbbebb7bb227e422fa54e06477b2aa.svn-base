//
//  TBErrorModel.m
//  TBExceptionFramework
//
//  Created by 郭明健 on 2018/9/4.
//  Copyright © 2018年 GuoMingJian. All rights reserved.
//

#import "TBErrorModel.h"
#import "TBInfo.h"

@implementation TBErrorModel

#pragma mark - private

+ (TBErrorModel *)getModel
{
    TBErrorModel *model = [[TBErrorModel alloc] init];
    //
    model.errorTime = [TBErrorModel stampByDate:[NSDate date]];;
    model.appVersion = [NSString stringWithFormat:@"%@", [TBInfo appVersion]];
    model.ip = [TBInfo iPhoneIpAddresses];
    model.deviceType = IS_IPHONE ? 1 : 2;
    model.systemType = 0;//iOS
    model.mobileModel = [TBInfo iPhoneModel];
    model.systemVersion = [TBInfo iPhoneSystemVersion];
    model.network = [TBInfo carrierName];
    model.errorType = 1;//默认是崩溃【0:卡顿 1:崩溃 2:错误 3:javascript 4:http】
    //稍后赋值
    model.appCode = @"";
    model.macAddress = @"";
    model.errorCode = @"";
    model.errorMessage = @"";
    //=====JS异常补全参数=====
    model.classify = @"native";//如果是JS异常，填"H5"。
    model.stack = @"";
    model.h5Url = @"";
    //=====HTTP异常补全参数=====
    model.requestUrl = @"";
    model.methodType = @"";
    model.responseStatus = 200;
    model.responseMessage = @"";
    model.browser = @"";
    
    return model;
}

+ (NSMutableDictionary *)getClientErrorParam:(TBErrorModel *)model
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"errorType"] = @(model.errorType);
    dict[@"systemVersion"] = model.systemVersion;
    dict[@"appVersion"] = model.appVersion;
    dict[@"appCode"] = model.appCode;
    dict[@"macAddress"] = model.macAddress;
    dict[@"ip"] = model.ip;
    dict[@"mobileModel"] = model.mobileModel;
    dict[@"errorCode"] = model.errorCode;
    dict[@"errorMessage"] = model.errorMessage;
    dict[@"stack"] = model.stack;
    dict[@"systemType"] = @(model.systemType);
    dict[@"classify"] = model.classify;
    dict[@"deviceType"] = @(model.deviceType);
    dict[@"h5Url"] = model.h5Url;
    dict[@"requestUrl"] = model.requestUrl;
    dict[@"methodType"] = model.methodType;
    dict[@"responseStatus"] = @(model.responseStatus);
    dict[@"responseMessage"] = model.responseMessage;
    dict[@"network"] = model.network;
    dict[@"browser"] = model.browser;
    //
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"head"] = @{@"timestamp" : @(model.errorTime)};
    param[@"data"] = dict;
    
    return param;
}

#pragma mark -

/**
 NSDate 转 时间戳
 */
+ (NSInteger)stampByDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateStr = [formatter stringFromDate:date];
    NSDate *newDate = [formatter dateFromString:dateStr];
    //NSString *stamp = [NSString stringWithFormat:@"%zd", (long)[newDate timeIntervalSince1970]];
    
    return [newDate timeIntervalSince1970];
}

/**
 时间戳 转 NSString
 */
+ (NSString *)dateStringByStamp:(NSString *)stamp
{
    NSTimeInterval time = [stamp doubleValue];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formater stringFromDate: date];
    
    return dateStr;
}

@end
