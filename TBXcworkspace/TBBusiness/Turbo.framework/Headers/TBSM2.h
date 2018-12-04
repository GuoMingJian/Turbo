//
//  TBSM2.h
//  Turbo
//
//  Created by Apple on 2018/4/25.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBSM2 : NSObject
/**
 SM2 加密
 
 @param src  传入明文NSData
 @param key  传入128位公钥
 @return 返回加密后的NSData
 */
+(NSData *)encryptSM2WithData:(NSData *)src andKey:(NSString *)key;

/**
 SM2 解密
 
 @param src  传入密文NSData
 @param key  传入64位私钥
 @return 返回解密后的NSData
 */
+(NSData *)decryptSM2WithData:(NSData *)src andKey:(NSString *)key;
@end
