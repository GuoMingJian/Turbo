//
//  TBAppConfig.m
//  TBExceptionFramework
//
//  Created by 郭明健 on 2018/9/3.
//  Copyright © 2018年 GuoMingJian. All rights reserved.
//

#import "TBAppConfig.h"
#import "TBHeader.h"

static NSString *kTBEnvironmentKey = @"kTBEnvironmentKey";

@implementation TBAppConfig

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static TBAppConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (config == nil) {
            config = [super allocWithZone:zone];
        }
    });
    return config;
}

+ (instancetype)sharedInstance
{
    return [[TBAppConfig alloc] init];
}

#pragma mark -

- (void)setEnvironment:(TBEnvironment)environment
{
    [[NSUserDefaults standardUserDefaults] setObject:@(environment) forKey:kTBEnvironmentKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (TBEnvironment)environment
{
    TBEnvironment environment = [[[NSUserDefaults standardUserDefaults] objectForKey:kTBEnvironmentKey] integerValue];
    if(!environment)
    {
        if (API_Online)
        {
            environment = TBEnvironment_OnLine;
        }
        else
        {
            environment = TBEnvironment_Test;
        }
        [self setEnvironment:environment];
    }
    return environment;
}

/**
 是否为线上环境
 */
- (BOOL)isOnline
{
    if([TBAppConfig sharedInstance].environment == TBEnvironment_OnLine)
    {
        return YES;
    }
    return NO;
}

/**
 域名
 */
- (NSString *)baseUrl
{
    if([self isOnline])
    {
        return @"http://139.199.158.23:83";
    }
    else
    {
        return @"";
    }
}

@end
