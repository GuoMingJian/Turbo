//
//  TBSession.m
//  TBExceptionFramework
//
//  Created by 郭明健 on 2018/9/3.
//  Copyright © 2018年 GuoMingJian. All rights reserved.
//

#import "TBSession.h"
#import "TBAppConfig.h"

@interface TBSession()<NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, assign) BusinessType businessType; //业务类型(接口标识)
@property (nonatomic, copy  ) RequestBlock resultsBlock;
@property (nonatomic, copy  ) NSString *requestUrl;

@end

@implementation TBSession

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static TBSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (session == nil) {
            session = [super allocWithZone:zone];
        }
    });
    return session;
}

+ (instancetype)sharedInstance
{
    return [[TBSession alloc] init];
}

- (void)requestUrl:(NSString *)url
             param:(NSMutableDictionary *)param
      businessType:(BusinessType)type
      resultsBlock:(RequestBlock)resultsBlock
{
    self.resultsBlock = resultsBlock;
    self.businessType = type;
    
    NSURLRequest *request = [self creatRequestWithParam:param url:url];
    
    NSURLSessionConfiguration *cofig = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session =[NSURLSession sessionWithConfiguration:cofig delegate:self delegateQueue:[NSOperationQueue currentQueue]];
    
    self.task = [self.session dataTaskWithRequest:request];
    [self.task resume];
}

- (NSURLRequest *)creatRequestWithParam:(NSDictionary *)param url:(NSString *)url
{
    NSString *baseUrl = [TBAppConfig sharedInstance].baseUrl;
    self.requestUrl = [NSString stringWithFormat:@"%@%@", baseUrl, url];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_requestUrl] cachePolicy:(NSURLRequestReloadIgnoringLocalCacheData) timeoutInterval:10.f];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:jsonData];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    return request;
}

- (void)cancel
{
    [self.task cancel];
    [self.session invalidateAndCancel];
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    completionHandler(NSURLSessionResponseAllow);
}

//非NSURLSessionDownloadTask类走这个代理方法-网络请求的代理方法
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{
    
    //获取请求参数
    NSURLRequest *currentRequest = dataTask.originalRequest;
    NSData *body = currentRequest.HTTPBody;
    NSDictionary *currentRequestdict = [NSDictionary dictionary];
    if (body)
    {
        currentRequestdict = [NSJSONSerialization JSONObjectWithData:body options:NSJSONReadingMutableLeaves error:nil];
    }
    
    //获取响应的数据
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    //成功回调
    if (self.resultsBlock)
    {
        self.resultsBlock(dict, error);
    }
}

#pragma mark - NSURLSessionTaskDelegate

// 请求成功或者失败（如果失败，error有值）
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    if (error)
    {
        //失败回调
        if (self.resultsBlock)
        {
            self.resultsBlock(@"请求失败！", error);
        }
    }
    
    [_session finishTasksAndInvalidate];
}

#pragma mark - NSURLSessionDelegate

//要服务器端单项HTTPS验证，iOS 客户端忽略证书验证。
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    
    if([[TBAppConfig sharedInstance] isOnline])
    {//线上环境
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"xxx" ofType:@"cer"];
        NSData *localCerData = [NSData dataWithContentsOfFile:cerPath];
        SecCertificateRef cerRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)localCerData);
        
        NSArray *chain = @[(__bridge id)cerRef];
        
        SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
        SecTrustSetAnchorCertificates(serverTrust, (__bridge CFArrayRef)chain);
        SecTrustResultType result;
        OSStatus status = SecTrustEvaluate(serverTrust, &result);
        BOOL trusted = (status == errSecSuccess) && ((result == kSecTrustResultProceed) || (result == kSecTrustResultUnspecified));
        if(trusted)
        {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        }
        else
        {
            completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
        }
    }
    else
    {//测试环境
        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        __block NSURLCredential *credential = nil;
        
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            if (credential) {
                disposition = NSURLSessionAuthChallengeUseCredential;
            } else {
                disposition = NSURLSessionAuthChallengePerformDefaultHandling;
            }
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
        if (completionHandler) {
            completionHandler(disposition, credential);
        }
    }
}

#pragma mark - NSURLSessionDownloadDelegate

//NSURLSessionDownloadTask类走这个代理方法-下载网路资源的代理方法
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location{
    
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes{
    
}

@end
