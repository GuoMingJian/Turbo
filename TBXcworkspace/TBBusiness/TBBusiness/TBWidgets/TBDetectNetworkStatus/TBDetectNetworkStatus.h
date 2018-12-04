//
//  TBDetectNetworkStatus.h
//  TBBusiness
//
//  Created by Apple on 2018/7/23.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Turbo/Turbo.h>

@interface TBDetectNetworkStatus : NSObject
// 网络异常检测
+(kNetworkStatus)detectNetworkStatus;
@end
