//
//  TBAppConfig.h
//  TBExceptionFramework
//
//  Created by 郭明健 on 2018/9/3.
//  Copyright © 2018年 GuoMingJian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBAppConfig : NSObject

typedef NS_ENUM(NSInteger, TBEnvironment)
{
    TBEnvironment_Test,
    TBEnvironment_OnLine
};

@property (nonatomic, copy  )    NSString *baseUrl;//域名
@property (nonatomic, assign)    TBEnvironment environment;

+ (instancetype)sharedInstance;

/**
 是否为线上环境
 */
- (BOOL)isOnline;

@end
