//
//  TB3DES.h
//  Turbo
//
//  Created by Apple on 2018/3/10.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TB3DES : NSObject
/**
 *  3DES 加密
 *  @param src  传入的明文
 *  @param key1 密钥1
 *  @param key2 密钥2
 *  @param key3 密钥3
 *  @return 加密后的密文
 */
+(NSData *)encryptWithData:(NSData *)src andKey1:(NSString *)key1 andKey2:(NSString *)key2 andKey3:(NSString *)key3;

/**
 *  3DES 解密
 *  @param src  传入的密文
 *  @param key1 密钥1
 *  @param key2 密钥2
 *  @param key3 密钥3
 *  @return 解密后的明文
 */
+(NSData *)decryptWithData:(NSData *)src andKey1:(NSString *)key1 andKey2:(NSString *)key2 andKey3:(NSString *)key3;
@end
