//
//  TBDeviceID.h
//  Turbo
//
//  Created by Apple on 2018/9/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeychainItemWrapper.h"
/**
 *  获取设备唯一标识类
 */
@interface TBDeviceID : NSObject
+(NSString *)getDeviceID;
@end
