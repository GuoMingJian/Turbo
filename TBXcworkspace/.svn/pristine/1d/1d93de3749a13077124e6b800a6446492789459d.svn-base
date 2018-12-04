//
//  TBMD5.h
//  Turbo
//
//  Created by Apple on 2018/3/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBMD5 : NSObject
/**
 *  MD5 Hash计算
 *  @param src 需要计算的NSString
 *  @return 回传Hash值
 */
+ (NSData *)getMD5HashByString:(NSString *)src;

/**
 *  MD5 Hash计算
 *  @param src 需要计算的NSData类型
 *  @return 回传Hash值
 */
+ (NSData *)getMD5HashByBytes:(NSData *)src;

/**
 *  MD5 Hash计算
 *  @param src 可以是NSString类型，也可以是NSData类型
 *  @return 回传NSString类型的哈希值(32位)
 */
+ (NSString *)getMD5String:(id)src;
@end
