//
//  TurboConstant.h
//  Turbo
//
//  Created by Apple on 2018/3/25.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef TurboConstant_h
#define TurboConstant_h

// 网络状态key名
#define NETWORK_STATUS @"networkStatus"

/**
 *  网络状态枚举
 */
typedef NS_ENUM (NSUInteger, kNetworkStatus){
    NetworkStatusNO     = 0,    // 无网络
    NetworkStatusWiFi   = 1,    // WiFi网络
    NetworkStatusWWAN   = 2,    // 本地网络
};

/**
 *  国际加密/国密加密
 */
typedef NS_ENUM (NSUInteger, TBEncryptChannel) {
    NationalEncrypted       = 0,    // 国密加密
    InternationalEncrypted  = 1,    // 国际加密
};

/**
 *  数据加密类型枚举
 */
typedef NS_ENUM (NSUInteger, TBEncryptType){
    ENCRYPT_NONE    =   0,   // 不加密
    ENCRYPT_AES     =   1,   // AES加密
    ENCRYPT_SM4     =   2,   // 国密SM4加密
    ENCRYPT_3DES    =   3,   // 3DES加密
    ENCRYPT_RSA     =   8,   // RSA公钥加密
    ENCRYPT_SM2     =   9,   // 国密SM2加密
};

/**
 *  数据解密类型枚举
 */
typedef NS_ENUM (NSUInteger, TBDecryptType){
    DECRYPT_NONE    =   0,   // 无需解密
    DECRYPT_AES     =   1,   // AES解密
    DECRYPT_SM4     =   2,   // 国密SM4解密
    DECRYPT_3DES    =   3,   // 3DES解密
    DECRYPT_RSA     =   8,   // RSA私钥解密
    DECRYPT_SM2     =   9,   // 国密SM2解密
};

/**
 *  哈希算法类型枚举
 */
typedef NS_ENUM (NSUInteger, TBHashType){
    HASH_NONE   =   0,  // 不做哈希计算
    HASH_MD5    =   1,  // MD5哈希计算
    HASH_SHA1   =   2,  // SHA1哈希计算
    HASH_SM3    =   3,  // SM3哈希计算
};

/**
 *  会话状态
 */
typedef NS_ENUM (NSUInteger, TBSessionStatus) {
    SessionStatusNone           = 0,    // 未建立会话
    SessionStatusConnected      = 1,    // 会话已建立
    SessionStatusOvertime       = 2,    // 会话超时
};

#endif /* TurboConstant_h */
