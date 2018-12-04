//
//  TBBase64.h
//  Turbo
//
//  Created by Apple on 2018/3/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBBase64 : NSObject

/**
 *  NSData转base64
 *  @param src 传入的NSData
 *  return 返回base64字符串
 */
+ (NSString *)encodeData:(NSData *)src;

/**
 *  base64转NSData
 *  @param src 传入的base64字符串
 *  return 返回NSData
 */
+ (NSData *)decodeString:(NSString *)src;

/**
 *  NSData转base64(网页安全类型)
 *  @param src 传入的NSData
 *  return 返回base64类型的NSString
 */
+ (NSString *)webSafeEncodeData:(NSData *)src;

/**
 *  base64转NSData(网页安全类型)
 *  @param src 传入base64的NSData
 *  return 返回NSData
 */
+(NSData *)webSafeDecodeData:(NSData *)src;

@end
