//
//  TBNetworkRequest.h
//  TBBusiness
//
//  Created by Apple on 2018/5/12.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TBNetworkRequest : NSObject

/**
 *  @param  requestUrl      请求地址(完整的URL地址)
 *  @param  params          请求参数
 *  @param  successBlock    成功回调
 *  @param  failBlock       失败回调
 */
+(NSURLSessionDataTask *_Nullable)requestWithUrl:(NSString *_Nullable)requestUrl
                                          params:(NSDictionary *_Nullable)params
                                         success:(void(^_Nullable)(id _Nullable obj))successBlock
                                            fail:(void (^_Nullable)(id _Nullable obj))failBlock;
/**
 *  @param  requestUrl      请求地址(完整的URL地址)
 *  @param  params          请求参数
 *  @param  timeoutInterval 超时时间
 *  @param  successBlock    成功回调
 *  @param  failBlock       失败回调
 */
+(NSURLSessionDataTask *_Nullable)requestWithUrl:(NSString *_Nullable)requestUrl
                                          params:(NSDictionary *_Nullable)params
                                 timeoutInterval:(CGFloat)timeoutInterval
                                         success:(void(^_Nullable)(id _Nullable obj))successBlock
                                            fail:(void (^_Nullable)(id _Nullable obj))failBlock;

/**
 *  取消所有请求
 */
+ (void)cancelAllRequest;

/**
 *  取消某一请求
 *  @param url 接口
 */
+ (void)cancelRequestWithURL:(NSString *_Nullable)url;
@end
