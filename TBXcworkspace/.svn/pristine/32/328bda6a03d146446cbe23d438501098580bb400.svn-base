//
//  TBRSA.h
//  Turbo
//
//  Created by Apple on 2018/3/14.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBRSA : NSObject
/**
 *  RSA 加密
 *  @param src 传入的明文
 *  @param keyPath 加密所需的公钥证书的路径
 *  return 返回密文
 */
+ (NSData *)encryptWithData:(NSData *)src andPublicKeyPath:(NSString *)keyPath;

/**
 *  RSA 解密
 *  @param src 传入的密文
 *  @param keyPath 解密所需的私钥证书的路径
 *  @param password 私钥证书的密码
 *  return 返回明文
 */
+ (NSData *)decryptWithData:(NSData *)src andPrivateKeyPath:(NSString *)keyPath andkeyPassword:(NSString *)password;
@end
