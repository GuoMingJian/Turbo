//
//  TBHTTPRequestClient.h
//  Turbo
//
//  Created by Apple on 2018/4/23.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TurboConstant.h"

@interface TBHTTPRequestClient : NSObject

/**
 *  异步POST请求【无自定义请求头】(用于Turbo框架，与后台匹配使用)
 *  @param requestUrl       请求地址
 *  @param params           请求参数
 *  @param encryptType      加密方式
 *  @param hashType         哈希算法
 *  @param timeoutInterval  超时时间
 *  @param successBlock     成功回调
 *  @param failBlock        失败回调
 */
+(NSURLSessionDataTask *_Nullable)asynPostRequestWithUrl:(NSString *_Nullable)requestUrl
                                                  params:(NSDictionary *_Nullable)params
                                             encryptType:(TBEncryptType)encryptType
                                                hashType:(TBHashType)hashType
                                         timeoutInterval:(CGFloat)timeoutInterval
                                                 success:(void(^_Nullable)(id _Nullable obj))successBlock
                                                    fail:(void (^_Nullable)(id _Nullable obj, NSError *_Nullable error))failBlock;
/**
 *  异步POST请求【传入自定义请求头】(用于Turbo框架，与后台匹配使用)
 *  @param requestUrl       请求地址
 *  @param headers          自定义请求头
 *  @param params           请求参数
 *  @param encryptType      加密方式
 *  @param hashType         哈希算法
 *  @param timeoutInterval  超时时间
 *  @param successBlock     成功回调
 *  @param failBlock        失败回调
 */
+(NSURLSessionDataTask *_Nullable)asynPostRequestWithUrl:(NSString *_Nullable)requestUrl
                                                 headers:(NSDictionary *_Nullable)headers
                                                  params:(NSDictionary *_Nullable)params
                                             encryptType:(TBEncryptType)encryptType
                                                hashType:(TBHashType)hashType
                                         timeoutInterval:(CGFloat)timeoutInterval
                                                 success:(void(^_Nullable)(id _Nullable obj))successBlock
                                                    fail:(void (^_Nullable)(id _Nullable obj, NSError *_Nullable error))failBlock;

/**
 *  同步POST请求【无自定义请求头】(用于Turbo框架，与后台匹配使用)
 *  @param requestUrl       请求地址
 *  @param params           请求参数
 *  @param encryptType      加密方式
 *  @param hashType         哈希算法
 *  @param timeoutInterval  超时时间
 *  @param successBlock     成功回调
 *  @param failBlock        失败回调
 */
+(NSURLSessionDataTask *_Nullable)synPostRequestWithUrl:(NSString *_Nullable )requestUrl
                                                 params:(NSDictionary * _Nullable)params
                                            encryptType:(TBEncryptType)encryptType
                                               hashType:(TBHashType)hashType
                                        timeoutInterval:(CGFloat)timeoutInterval
                                                success:(void(^_Nullable)(id _Nullable obj))successBlock
                                                   fail:(void (^_Nullable)(id _Nullable obj, NSError *_Nullable error))failBlock;

/**
 *  同步POST请求【传入自定义请求头】(用于Turbo框架，与后台匹配使用)
 *  @param requestUrl       请求地址
 *  @param headers          自定义请求头
 *  @param params           请求参数
 *  @param encryptType      加密方式
 *  @param hashType         哈希算法
 *  @param timeoutInterval  超时时间
 *  @param successBlock     成功回调
 *  @param failBlock        失败回调
 */
+(NSURLSessionDataTask *_Nullable)synPostRequestWithUrl:(NSString *_Nullable )requestUrl
                                                headers:(NSDictionary *_Nullable)headers
                                                 params:(NSDictionary * _Nullable)params
                                            encryptType:(TBEncryptType)encryptType
                                               hashType:(TBHashType)hashType
                                        timeoutInterval:(CGFloat)timeoutInterval
                                                success:(void(^_Nullable)(id _Nullable obj))successBlock
                                                   fail:(void (^_Nullable)(id _Nullable obj, NSError *_Nullable error))failBlock;

/**
 *  普通的异步POST请求【无自定义请求头】(无加密、无哈希校验、无Base64编码)
 *  @param requestUrl       请求地址
 *  @param params           请求参数
 *  @param timeoutInterval  超时时间
 *  @param successBlock     成功回调
 *  @param failBlock        失败回调
 */
+(NSURLSessionDataTask *_Nullable)asyncPostRequestWithUrl:(NSString *_Nullable)requestUrl
                                                   params:(NSDictionary *_Nullable)params
                                          timeoutInterval:(CGFloat)timeoutInterval
                                                  success:(void(^_Nullable)(id _Nullable obj))successBlock
                                                     fail:(void (^_Nullable)(id _Nullable obj, NSError *_Nullable error))failBlock;
/**
 *  普通的异步POST请求【传入自定义请求头】(无加密、无哈希校验、无Base64编码)
 *  @param requestUrl       请求地址
 *  @param headers          自定义请求头
 *  @param params           请求参数
 *  @param timeoutInterval  超时时间
 *  @param successBlock     成功回调
 *  @param failBlock        失败回调
 */
+(NSURLSessionDataTask *_Nullable)asyncPostRequestWithUrl:(NSString *_Nullable)requestUrl
                                                  headers:(NSDictionary *_Nullable)headers
                                                   params:(NSDictionary *_Nullable)params
                                          timeoutInterval:(CGFloat)timeoutInterval
                                                  success:(void(^_Nullable)(id _Nullable obj))successBlock
                                                     fail:(void (^_Nullable)(id _Nullable obj, NSError *_Nullable error))failBlock;
/**
 *  普通的同步POST请求【无自定义请求头】(无加密、无哈希校验、无Base64编码)
 *  @param requestUrl       请求地址
 *  @param params           请求参数
 *  @param timeoutInterval  超时时间
 *  @param successBlock     成功回调
 *  @param failBlock        失败回调
 */
+(NSURLSessionDataTask *_Nullable)syncPostRequestWithUrl:(NSString *_Nullable)requestUrl
                                                   params:(NSDictionary *_Nullable)params
                                          timeoutInterval:(CGFloat)timeoutInterval
                                                  success:(void(^_Nullable)(id _Nullable obj))successBlock
                                                     fail:(void (^_Nullable)(id _Nullable obj, NSError *_Nullable error))failBlock;
/**
 *  普通的同步POST请求【传入自定义请求头】(无加密、无哈希校验、无Base64编码)
 *  @param requestUrl       请求地址
 *  @param headers          自定义请求头
 *  @param params           请求参数
 *  @param timeoutInterval  超时时间
 *  @param successBlock     成功回调
 *  @param failBlock        失败回调
 */
+(NSURLSessionDataTask *_Nullable)syncPostRequestWithUrl:(NSString *_Nullable)requestUrl
                                                  headers:(NSDictionary *_Nullable)headers
                                                   params:(NSDictionary *_Nullable)params
                                          timeoutInterval:(CGFloat)timeoutInterval
                                                  success:(void(^_Nullable)(id _Nullable obj))successBlock
                                                     fail:(void (^_Nullable)(id _Nullable obj, NSError *_Nullable error))failBlock;
/**
 *  取消所有请求
 */
+ (void)cancelAllRequest;

/**
 *  中断某一请求
 *  @param url 需要取消请求的URL
 */
+ (void)cancelRequestWithURL:(NSString *_Nullable)url;
@end
