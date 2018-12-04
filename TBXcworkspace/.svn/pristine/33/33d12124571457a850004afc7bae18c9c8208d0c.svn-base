//
//  TBJsonHandle.h
//  Turbo
//
//  Created by Apple on 2018/4/24.
//  Copyright © 2018年 Apple. All rights reserved.
//  字典/json字符串互转类

#import <Foundation/Foundation.h>

@interface TBJsonHandle : NSObject

/**
 *  NSDictionary转NSData
 *  @param dic NSDictionary类型
 *  @return NSData类型
 */
+(NSData *)dictionaryToData:(NSDictionary *)dic;

/**
 *  NSDictionary转NSString
 *  @param dic NSDictionary类型
 *  @return NSString类型
 */
+(NSString *)dictionaryToJSONString:(NSDictionary *)dic;

/**
 *  id obj转NSDictionary
 *  @param obj 可以是NSData类型，也可以是NSString类型
 *  @return NSDictionary类型
 */
+(id)jsonStringToDictionary:(id)obj;

@end
