//
//  TBNetworkRequest.m
//  TBBusiness
//
//  Created by Apple on 2018/5/12.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TBNetworkRequest.h"
#import "TBDetectNetworkStatus.h"
#import <Turbo/Turbo.h>

@implementation TBNetworkRequest
+(NSURLSessionDataTask *_Nullable)requestWithUrl:(NSString *_Nullable)requestUrl
                                          params:(NSDictionary *_Nullable)params
                                         success:(void(^_Nullable)(id _Nullable obj))successBlock
                                            fail:(void (^_Nullable)(id _Nullable obj))failBlock {
    NSURLSessionDataTask *dataTask = [self requestWithUrl:requestUrl params:params timeoutInterval:30.0f success:^(id  _Nullable obj) {
        // 成功回调
        if (successBlock) {
            successBlock(obj);
        }
    } fail:^(id  _Nullable obj) {
        // 失败回调
        if (failBlock) {
            failBlock(obj);
        }
    }];
    
    return dataTask;
}

+(NSURLSessionDataTask *_Nullable)requestWithUrl:(NSString *_Nullable)requestUrl
                                          params:(NSDictionary *_Nullable)params
                                 timeoutInterval:(CGFloat)timeoutInterval
                                         success:(void(^_Nullable)(id _Nullable obj))successBlock
                                            fail:(void (^_Nullable)(id _Nullable obj))failBlock {
    // 网络状态检测
    if ([TBDetectNetworkStatus detectNetworkStatus] == 0) {
        return nil;
    }
    
    /**
     *  确定加密通道；
     *  如果是国际加密通道，网络请求则采用3DES国际加密算法，否则采用SM4国密加密算法
     */
    TBEncryptType encryptType = ENCRYPT_SM4;
    TBEncryptChannel encryptChannel = [TBDefaultsManager shareInstance].encryptChannel;
    if (encryptChannel == InternationalEncrypted) {
        encryptType = ENCRYPT_3DES;
    }
    NSURLSessionDataTask *dataTask = [TBHTTPRequestClient asynPostRequestWithUrl:requestUrl params:params encryptType:encryptType hashType:HASH_MD5 timeoutInterval:timeoutInterval success:^(id  _Nullable obj) {
        // 成功回调
        if (successBlock) {
            successBlock(obj);
        }
        
    } fail:^(id  _Nullable obj, NSError * _Nullable error) {
        // 失败回调
        if (failBlock) {
            failBlock(obj);
        }
    }];
    
    return dataTask;
}

#pragma mark - 取消所有请求
+ (void)cancelAllRequest {
    [TBHTTPRequestClient cancelAllRequest];
}

#pragma mark - 中断某一请求
+ (void)cancelRequestWithURL:(NSString *_Nullable)url {
    [TBHTTPRequestClient cancelRequestWithURL:url];
}
@end
