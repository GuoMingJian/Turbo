//
//  TBAES.h
//  Turbo
//
//  Created by Apple on 2018/3/12.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBAES : NSObject
/**
 *  AES 加密
 *  @param src  传入明文
 *  @param key  加密所需的key(128个字节)
 *  @param iv   加密所需的iv(128个字节)
 *  return 返回密文data
 */
+ (NSData *)encryptWithData:(NSData *)src keyData:(NSData *)key ivData:(NSData *)iv;

/**
 *  AES 解密
 *  @param src  传入密文
 *  @param key  解密所需的key(128个字节)
 *  @param iv   解密所需的iv(128个字节)
 *  return 返回明文data
 */
+ (NSData *)decryptWithData:(NSData *)src keyData:(NSData *)key ivData:(NSData *)iv;

//==============================================
//==============================================

/**
 *  AES 加密
 *  @param src  传入明文
 *  @param key  加密所需的key(16个字符)
 *  @param iv   加密所需的iv(16个字符)
 *  return 返回密文data
 */
+ (NSData *)encryptWithData:(NSData *)src key:(NSString *)key iv:(NSString *)iv;

/**
 *  AES 解密
 *  @param src  传入密文
 *  @param key  解密所需的key(16个字符)
 *  @param iv   加密所需的iv(16个字符)
 *  return 返回明文data
 */
+ (NSData *)decryptWithData:(NSData *)src key:(NSString *)key iv:(NSString *)iv;
@end
