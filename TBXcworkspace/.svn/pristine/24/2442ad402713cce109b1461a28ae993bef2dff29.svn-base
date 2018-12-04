//
// Created by fantouch on 14/03/2018.
// Copyright (c) 2018 Tencent. All rights reserved.
//

#import "QCHttpEngine.h"

/**
 * 包装类, 把外部传入的 block 包装成 NSURLSession 所需的 NSURLSessionDelegate.
 * 对外提供 block 方式的回调, 可以使得调用代码更可读, 类似 Java 中的匿名内部类.
 */
@interface ProgressDelegate : NSObject <NSURLSessionDelegate>
- (instancetype)initWithProgressBlock:(void (^)(float percent))block;
@end

@implementation QCHttpEngine

+ (NSURLSessionDataTask *)postFormDataTo:(NSString *)apiUrl
                                 headers:(NSDictionary<NSString *, NSString *> *)headers
                                  params:(NSDictionary<NSString *, NSString *> *)params
                                   files:(NSDictionary<NSString *, NSString *> *)files
                              onProgress:(void (^)(float percent))progressBlock
                            onCompletion:(void (^)(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error))completionBlock {

    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiUrl]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];

    // 添加 Header
    NSString *boundary = @"----com.tencent.cloud.Objective-C.SampleCode.FormBoundary.7MA4YWxkTrZu0gW----";
    NSString *contentTypeKey = @"content-type";
    NSString *contentTypeValue = [@"multipart/form-data; boundary=" stringByAppendingString:boundary];
    for (NSString *headerName in headers) {//排除自定义的 content-type header
        if (![contentTypeKey isEqualToString:[headerName lowercaseString]]) {
            [request setValue:headers[headerName] forHTTPHeaderField:headerName];
        }
    }
    [request setValue:contentTypeValue forHTTPHeaderField:contentTypeKey];//添加正确的content-type header

    // 准备拼接 body
    NSMutableString *bodyString = [NSMutableString string];
    NSMutableData *bodyData = [NSMutableData data];

    // 拼接参数到 body
    for (NSString *paramName in params) {
        [bodyString appendFormat:@"--%@\r\n", boundary];
        [bodyString appendFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", paramName];
        [bodyString appendFormat:@"%@\r\n", params[paramName]];
    }
    [bodyData appendData:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];

    // 拼接文件到 body
    // TODO: 文件过大时, 可能导致内存溢出. 这里业务场景中的文件较小, 可等以后迭代优化.
    // https://stackoverflow.com/a/12627143/1632448
    for (NSString *paramName in files) {
        NSString *fileUrl = files[paramName];
        NSString *fileName = [fileUrl lastPathComponent];
        [bodyString setString:@""];
        [bodyString appendFormat:@"--%@\r\n", boundary];
        [bodyString appendFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@\"\r\n\r\n", paramName, fileName];
        [bodyData appendData:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
        [bodyData appendData:[NSData dataWithContentsOfURL:[NSURL URLWithString:fileUrl]]];
        [bodyData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }

    // 拼接结束符到 body
    [bodyString setString:@""];
    [bodyString appendFormat:@"--%@--\r\n", boundary];
    [bodyData appendData:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];

    // 设置 body
    [request setHTTPBody:bodyData];

    // 发送请求
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:[[ProgressDelegate alloc] initWithProgressBlock:progressBlock]
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:completionBlock];
    [dataTask resume];
    return dataTask;
}

+ (NSURLSessionDataTask *_Nullable)postJsonTo:(NSString *)apiUrl
                                      headers:(NSDictionary<NSString *, NSString *> *)headers
                                       params:(NSDictionary<NSString *, NSString *> *)params
                                   onProgress:(void (^)(float percent))progressBlock
                                 onCompletion:(void (^)(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error))completionBlock {

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiUrl]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];

    // 添加 Header
    NSString *contentTypeKey = @"Content-Type";
    NSString *contentTypeValue = @"application/json";
    for (NSString *headerName in headers) {//排除自定义的 content-type header
        if (![[contentTypeKey lowercaseString] isEqualToString:[headerName lowercaseString]]) {
            [request setValue:headers[headerName] forHTTPHeaderField:headerName];
        }
    }
    [request setValue:contentTypeValue forHTTPHeaderField:contentTypeKey];//添加正确的content-type header

    // 设置 body
    NSError *error = nil;
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error]];

    if (error) {// JSON 序列化异常
        completionBlock(nil, nil, error);
        return nil;
    } else {
        // 发送请求
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                              delegate:[[ProgressDelegate alloc] initWithProgressBlock:progressBlock]
                                                         delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:completionBlock];
        [dataTask resume];
        return dataTask;
    }
}
@end

#pragma ProgressDelegate

@implementation ProgressDelegate {
    void(^_progressBlock)(float);
}

- (instancetype)initWithProgressBlock:(void (^)(float percent))block {
    self = [super init];
    if (self) {
        _progressBlock = block;
    }
    return self;
}

- (void)      URLSession:(NSURLSession *)session
                    task:(NSURLSessionTask *)task
         didSendBodyData:(int64_t)bytesSent
          totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {

    float percent = totalBytesSent / (float) totalBytesExpectedToSend * 100;
    _progressBlock(percent);

}
@end
