//
// Created by fantouch on 06/12/2017.
// Copyright (c) 2017 Tencent. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "QCLocalAuthorizationGenerator.h"


@implementation QCLocalAuthorizationGenerator

+ (NSString *)signWithAppId:(NSString *)appId secretId:(NSString *)secretId secretKey:(NSString *)secretKey {
    return [self signWithAppId:appId secretId:secretId secretKey:secretKey bucketName:@"" effectiveDurationInSecond:60 * 60];
}

+ (NSString *)signWithAppId:(NSString *)appId secretId:(NSString *)secretId secretKey:(NSString *)secretKey bucketName:(NSString *)bucketName effectiveDurationInSecond:(int64_t)second {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSString *source = [NSString stringWithFormat:@"a=%@&k=%@&e=%.0f&t=%.0f&r=%@&u=%@",
                        appId,
                        secretId,
                        now + second * 1000,
                        now,
                        [self createRandomNum],
                        @""];
    NSData *sourceBytes = [source dataUsingEncoding:NSUTF8StringEncoding];
    NSData *sourceHmacBytes = [QCLocalAuthorizationGenerator hmacSha1:source withKey:secretKey];
    NSMutableData *allBytes = [NSMutableData dataWithData:sourceHmacBytes];
    [allBytes appendData:sourceBytes];
    NSString *base64String = [allBytes base64EncodedStringWithOptions:0];
    
    return base64String;
}

+ (NSData *)hmacSha1:(NSString *)source withKey:(NSString *)key {
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [source cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *resultBytes = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    return resultBytes;
}

#pragma mark - 生成十位随机数(求余不足十位则补0)
+(NSString *)createRandomNum {
    NSInteger num = arc4random() % 1000000000;
    NSString *randomNum = [NSString stringWithFormat:@"%010ld",(long)num];
    return randomNum;
}

@end
