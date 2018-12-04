//
//  TBDefaultsManager.h
//  Turbo
//
//  Created by Apple on 2018/4/24.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TurboConstant.h"

@interface TBDefaultsManager : NSObject

// 加密通道(国密加密/国际加密)
@property (nonatomic, assign) TBEncryptChannel encryptChannel;

// 服务器基础地址
@property (nonatomic, copy, getter=getBaseServerUrl) NSString *serverBaseUrl;

// 握手URL地址
@property (nonatomic, copy, getter=getHandshakeUrl) NSString *handshakeUrl;

// SM2公钥
@property (nonatomic, copy, getter=getSM2PublicKey) NSString *SM2PublicKey;

// HTTPS证书路径
@property (nonatomic, copy) NSString *httpsCertPath;

// RSA公钥证书路径
@property (nonatomic, copy) NSString *rsaPublicKeyCertPath;

// RSA私钥证书路径(实际应用中不会把私钥证书放在本地)
@property (nonatomic, copy) NSString *rsaPrivateKeyCertPath;

+(instancetype)shareInstance;


@end
