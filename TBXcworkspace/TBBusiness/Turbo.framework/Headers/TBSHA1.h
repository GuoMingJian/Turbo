//
//  TBSHA1.h
//  Turbo
//
//  Created by Apple on 2018/3/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBSHA1 : NSObject
/**
 *  SHA1 Hash计算
 *  @param src 需要计算的NSString
 *  @return 回传Hash值
 */
+ (NSData *)getSHA1HashByString:(NSString *)src;

/**
 *  SHA1 Hash计算
 *  @param src 需要计算的NSData类型
 *  @return 回传Hash值
 */
+ (NSData *)getSHA1HashByBytes:(NSData *)src;
@end
