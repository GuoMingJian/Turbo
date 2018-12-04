//
//  TBURLProtocol.h
//  TBBusiness
//
//  Created by Apple on 2018/2/8.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBURLProtocol : NSURLProtocol <NSURLSessionDelegate>

/**
 *  注册
 */
+ (void)startListeningNetWorking;

/**
 *  取消注册
 */
+ (void)cancelListeningNetWorking;
@end
