//
//  TBNetworkStatusManager.h
//  Turbo
//
//  Created by Apple on 2018/3/25.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TurboConstant.h"

@interface TBNetworkStatusManager : NSObject

/**
 *  设置单例
 */
+(instancetype)shareInstance;

/**
 *  开始监测网络状态
 */
- (void)startMonitoringNetworkStatus;

/**
 *  暂停网络状态监测
 */
- (void)stopMonitoringNetworkStatus;

/**
 *  获取网络状态
 */
-(kNetworkStatus)getNetworkStatus;
@end
