//
//  TBSM4.h
//  Turbo
//
//  Created by Apple on 2018/4/25.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBSM4 : NSObject
#pragma mark - SM4 ECB模式加解密
/**
 SM4 ECB模式加密
 
 @param src  传入明文
 @param key  密钥
 
 @return    返回加密后的NSData
 */
+(NSData *)ECBEncryptWithData:(NSData *)src andSecretKey:(NSString *)key;

/**
 SM4 ECB模式解密
 
 @param src  传入密文
 @param key  密钥
 
 @return    返回解密后的NSData
 */
+(NSData *)ECBDecryptWithData:(NSData *)src andSecretKey:(NSString *)key;

#pragma mark - SM4 CBC模式加解密
/**
 SM4 CBC模式加密
 
 @param src  传入明文
 @param key  密钥
 @param iv   初始化向量
 
 @return    返回加密后的NSData
 */
+(NSData *)CBCEncryptWithData:(NSData *)src andSecretKey:(NSString *)key andIv:(NSString *)iv;

/**
 SM4 CBC模式解密
 
 @param src  传入密文
 @param key  密钥
 @param iv   初始化向量
 
 @return    返回解密后的NSData
 */
+(NSData *)CBCDecryptWithData:(NSData *)src andSecretKey:(NSString *)key andIv:(NSString *)iv;
@end
