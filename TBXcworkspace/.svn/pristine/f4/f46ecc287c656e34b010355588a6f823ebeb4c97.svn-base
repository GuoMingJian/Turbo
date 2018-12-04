//
//  TurboFramework.h
//  Turbo
//
//  Created by Apple on 2018/5/14.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TurboConstant.h"
@interface TurboFramework : NSObject

/**
 *  GCD单例
 */
+(instancetype)shareInstance;

/**
 *  初始化Framework(密钥协商、网络状态监测)
 */
-(void)initTurboFramework:(void(^)(BOOL isSuccess))block;

/**
 *  获取握手状态
 */
-(BOOL)getHandshakeStatus;

/**
 *  获取会话状态
 */
-(TBSessionStatus)getSessionStatus;
@end
