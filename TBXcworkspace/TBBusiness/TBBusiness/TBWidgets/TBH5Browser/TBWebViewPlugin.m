//
//  TBWebViewPlugin.m
//  TBBusiness
//
//  Created by Apple on 2018/6/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TBWebViewPlugin.h"
#import "QCMediaPicker.h"
#import <Turbo/Turbo.h>
#import "UserInfo.h"
#import "QCLocalAuthorizationGenerator.h"
#import "TBViewControllerManager.h"
#import "TBH5BrowserViewController.h"
#import "TBDetectNetworkStatus.h"
#import "TBAlertViewController.h"
#import <TBCatchException/TBExceptionManager.h>
#import "TBConstant.h"
#import "PwdLoginViewController.h"
#import "collectionViewController.h"

#define JPGE_URL    @"jpge_url"
#define MOV_URL     @"mov_url"

typedef void (^completionHandler)(NSDictionary *_Nullable result, BOOL complete);

@interface TBWebViewPlugin ()<UIAlertViewDelegate>

@property (nonatomic, strong) QCMediaPicker *picker;

@end

@implementation TBWebViewPlugin

#pragma mark - JS页面跳转
- (void)pushWindow:(id)obj callBack:(completionHandler)completionHandler {
/*
    {
        options = {
            // 是否显示导航控制器 1：显示 0：不显示（无值时默认为1）
            showTitleBar = 1;
            // 滚动时是否透明 1：透明 0：不透明(showTitleBar为1时才处理这里的逻辑，默认是0)
            transparentTitle = 0
        };
        data = {
            // 跳转页面
            path = main/remittance/transferRemittance;
            // 点击左上角返回按钮时，根据backPage判断出栈多少层(默认为1)
            backPage = -1;
            // pushWindow时，传递给下一个webView的参数
            params = {
                name = Turbo;
                phone = 15902076381
            }
        }
    }
 */
    NSString *path = obj[@"data"][@"path"];
    // 异常处理(如果传入的路径为空，直接给回调)
    if (!path || path.length == 0) {
        completionHandler(@{@"msg":@"传入的路径的空"},NO);
        return;
    }
    
    /**
     *  说明：如果是登录模块，在这里做拦截，采用原生实现
     */
    if ([path isEqualToString:@"/login/loginPwd/index"] || [path isEqualToString:@"login/loginPwd/index"]) {
        PwdLoginViewController *pwdVC = [[PwdLoginViewController alloc] init];
        if ([self.viewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navC = (UINavigationController *)self.viewController;
            [navC pushViewController:pwdVC animated:YES];
        }
        return;
    }

    NSString *absolutePath = [NSString stringWithFormat:@"%@/%@.html",TB_WWW_DIRECTORY,path];
    if (![[NSFileManager defaultManager] fileExistsAtPath:absolutePath]) {
        // 如果查询到页面不存在，直接给JS回调
        completionHandler(@{@"errorcode":[NSNumber numberWithInteger:1]}, NO);
        return;
    }
    
    // 是否显示导航控制器 1：显示 0：不显示（无值时默认为1）
    BOOL isShowNaviBar = YES;
    id id1 = [[obj objectForKey:@"options"] objectForKey:@"showTitleBar"];
    if (id1) {
        isShowNaviBar = [id1 boolValue];
    }
    
    // 滚动时是否透明 1：透明 0：不透明
    BOOL isTransparent = NO;
    id id2 = [[obj objectForKey:@"options"] objectForKey:@"transparentTitle"];
    if (id2) {
        isTransparent = [id2 boolValue];
    }
    
    // 点击左上角返回按钮时，根据backPageNum判断出栈多少层(默认为1)
    NSInteger backPageNum = 1;
    
    id id3 = [[obj objectForKey:@"data"] objectForKey:@"backPage"];
    if (id3) {
        NSString *num = [id3 stringValue];
        num = [num stringByReplacingOccurrencesOfString:@"-" withString:@""];
        backPageNum = [num integerValue];
    }
    
    // 传递给webView的参数
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionary];
    id id4 = [[obj objectForKey:@"data"] objectForKey:@"params"];
    if (id4 && [id4 isKindOfClass:[NSDictionary class]]) {
        NSDictionary *params = (NSDictionary *)id4;
        // errorcode是JS需要的参数
        [mutDict setObject:@(0) forKey:@"errorcode"];
        [mutDict setObject:params forKey:@"params"];
    }
    
    // 初始化H5容器并传入参数
    TBH5BrowserViewController *h5VC = [[TBH5BrowserViewController alloc] init];
    h5VC.htmlPath = path;
    h5VC.isShowNaviBar = isShowNaviBar;
    h5VC.isTransparent = isTransparent;
    h5VC.backPageNum = backPageNum;
    h5VC.params = mutDict;
    
    if ([self.viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navC = (UINavigationController *)self.viewController;
        [navC pushViewController:h5VC animated:YES];
    } else if ([self.viewController isKindOfClass:[UIViewController class]]) {
        [self.viewController presentViewController:h5VC animated:YES completion:nil];
    }
    
    // 保存跳转的controller
    TBViewControllerManager *vcManager = [TBViewControllerManager shareInstance];
    UINavigationController *naviC = (UINavigationController *)self.viewController;
    // 存储导航控制器最后一个视图控制器
    UIViewController *currentVC = [naviC.viewControllers lastObject];
    [vcManager.viewControllerArr addObject:@{path:currentVC}];

}

#pragma mark -
- (void)getPageParams:(id)obj callBack:(completionHandler)completionHandler {
    // 异常标志位
    BOOL isException = NO;
    
    id temp0 = self.viewController;
    if ([temp0 isKindOfClass:[UINavigationController class]]) {
        UINavigationController *naviC = (UINavigationController *)temp0;
        UIViewController *vc = naviC.childViewControllers.lastObject;
        if ([vc isKindOfClass:[TBH5BrowserViewController class]]) {
            TBH5BrowserViewController *h5VC = (TBH5BrowserViewController *)vc;
            NSDictionary *params = h5VC.params;
            if (params.count > 0) {
                completionHandler(params,YES);
            } else {
                isException = YES;
            }
        } else {
            isException = YES;
        }
    } else {
        isException = YES;
    }
    
    if (isException) {
        // 异常情况
        completionHandler(@{@"errorcode":@(1),
                            @"params":@{}
                            },YES);
    }
    
}

- (void)popWindow:(id)obj callBack:(completionHandler)completionHandler {
/*
{
    options = {
    };
    data = {
        // 根据backPage判断出栈多少层(默认为1)
        backPage = -1;
        params = {
            isSetHandLock = 0
        }
    }
}
 */
    NSInteger backPageNum = 1;
    id id0 = [[obj objectForKey:@"data"] objectForKey:@"backPage"];
    if (id0) {
        NSString *num = [id0 stringValue];
        num = [num stringByReplacingOccurrencesOfString:@"-" withString:@""];
        backPageNum = [num integerValue];
    }
    
    // 控制viewController出栈，并移除vcManager.viewControllerArr的元素
    TBViewControllerManager *manager = [TBViewControllerManager shareInstance];
    UINavigationController *naviC = (UINavigationController *)self.viewController;
    if (naviC) {
        [manager popViewControllerWithNavigationController:naviC andAmount:backPageNum];
        [manager removeElements:backPageNum];
    }
}

#pragma mark - 获取手机状态栏高度
- (void)getStatusBarHeight:(id)obj callBack:(completionHandler)completionHandler {
    NSString *statusBarHeight = [NSString stringWithFormat:@"%f",STATUS_BAR_HEIGHT];
    completionHandler(@{@"statusBarHeight":statusBarHeight},YES);
}

#pragma mark - JS异常监测
- (void)trackError:(id)obj callBack:(completionHandler)completionHandler {
    NSLog(@"%@", obj);
    NSString *message = [obj objectForKey:@"message"];
    NSString *stack = [NSString stringWithFormat:@"%@",[obj objectForKey:@"stack"]];
    message = message == nil ? @"":message;
    stack = stack == nil ? @"":stack;
    
    NSDictionary *infoDict = @{@"errorType":@(3),
                               @"errorCode":@"3",
                               @"message":message,
                               @"stack":stack,
                               @"classify":@"H5"
                               };
    // 调用异常日志收集SDK向后台发送JS异常数据
    TBExceptionManager *manager = [TBExceptionManager sharedInstance];
    [manager sendErrorInfoToBackground:infoDict];
}

#pragma mark - 网络请求插件
- (void)networkRequest:(id)obj callBack:(completionHandler)completionHandler {
    /*
    {
        data = {
            url = /operate/manager/queryModelList;
            params = {
                head = {
                    timestamp = 1540296156678
                };
                data = {
                    modelCode = page_one
                }
            }
        }
    }
     */
    id url = [NSString stringWithFormat:@"%@",obj[@"data"][@"url"]];
    id head = obj[@"data"][@"params"][@"head"];
    id data = obj[@"data"][@"params"][@"data"];
    
    // 异常处理
    if (![url isKindOfClass:[NSString class]] || !url ||
        ![head isKindOfClass:[NSDictionary class]] || !head ||
        ![data isKindOfClass:[NSDictionary class]] || !data) {
        return;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@",url];
    if (urlStr.length == 0) {
        return;
    }
    
    NSDictionary *headDict = (NSDictionary *)head;
    NSDictionary *dataDict = (NSDictionary *)data;
    NSMutableDictionary *mutData = [NSMutableDictionary dictionaryWithDictionary:dataDict];
    [mutData setObject:@"appCode" forKey:APP_CODE];
    NSDictionary *params = @{
                             @"data":mutData,
                             @"head":headDict
                             };
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",BASE_SERVER_URL,urlStr];
    NSDictionary *header = @{@"X-APP-CODE":APP_CODE};
    
    [TBHTTPRequestClient asyncPostRequestWithUrl:requestUrl
                                    headers:header
                                     params:params
                            timeoutInterval:30.0f
                                    success:^(id  _Nullable obj) {
                                        // 成功回调
                                        completionHandler(obj, YES);
    }
                                       fail:^(id  _Nullable obj, NSError * _Nullable error) {
                                           // 失败回调
                                           completionHandler(obj, NO);
    }];
}

#pragma mark - 拍照、选相册/拍视频、选视频相关插件
- (void)takeImage:(id)obj callBack:(completionHandler)completionHandler {
    NSString *photoFlag = [obj objectForKey:@"photoFlag"];
    NSString *videoFlag = [obj objectForKey:@"videoFlag"];
    
    self.picker = [[QCMediaPicker alloc] initWithController:self.viewController];
    
    if ([photoFlag isEqualToString:@"0"]) {
        // 拍照
        [self takePhotoWithCallBack:completionHandler];
    } else if ([photoFlag isEqualToString:@"1"]) {
        // 选相册
        [self choosePhotoWithCallBack:completionHandler];
    } else if ([videoFlag isEqualToString:@"0"]) {
        // 选视频
        [self chooseVideoWithCallBack:completionHandler];
    } else if ([videoFlag isEqualToString:@"1"]) {
        // 拍视频
        [self captureVideoWithCallBack:completionHandler];
    }
}

/**
 *  拍照
 */
- (void)takePhotoWithCallBack:(completionHandler)completionHandler {
    [self.picker imageFromCamera:^(NSURL *fileUrl) {
        if (fileUrl) {
            NSMutableDictionary *mutDict = [NSMutableDictionary dictionary];
            [mutDict setObject:fileUrl.absoluteString forKey:@"url"];
            
            NSData *imgData = [NSData dataWithContentsOfURL:fileUrl];
            if (imgData.length > 0) {
                NSString *imgBase64 = [TBBase64 encodeData:imgData];
                [mutDict setObject:imgBase64 forKey:@"imgBase64"];
            } else {
                [mutDict setObject:@"" forKey:@"imgBase64"];
            }
            
            [self handleImageOldData:fileUrl];
            completionHandler (mutDict,YES);
        } else {
            completionHandler (nil,YES);
        }
    }];
}

/**
 *  选相册
 */
- (void)choosePhotoWithCallBack:(completionHandler)completionHandler {
    [self.picker imageFromLibrary:^(NSURL *fileUrl) {
        if (fileUrl) {
            NSMutableDictionary *mutDict = [NSMutableDictionary dictionary];
            [mutDict setObject:fileUrl.absoluteString forKey:@"url"];
            
            NSData *imgData = [NSData dataWithContentsOfURL:fileUrl];
            if (imgData.length > 0) {
                NSString *imgBase64 = [TBBase64 encodeData:imgData];
                [mutDict setObject:imgBase64 forKey:@"imgBase64"];
            } else {
                [mutDict setObject:@"" forKey:@"imgBase64"];
            }
            
            [self handleImageOldData:fileUrl];
            completionHandler (mutDict,YES);
        } else {
            completionHandler (nil,YES);
        }
    }];
}

/**
 *  录视频
 */
- (void)captureVideoWithCallBack:(completionHandler)completionHandler {
    [self.picker videoFromCamera:^(NSURL *fileUrl) {
        if (fileUrl) {
            [self handleVideoOldData:fileUrl];
            completionHandler (@{@"url":fileUrl.absoluteString},YES);
        } else {
            completionHandler (nil,YES);
        }
    }];
}

/**
 *  选视频
 */
- (void)chooseVideoWithCallBack:(completionHandler)completionHandler {
    [self.picker videoFromLibrary:^(NSURL *fileUrl) {
        if (fileUrl) {
            [self handleVideoOldData:fileUrl];
            completionHandler (@{@"url":fileUrl.absoluteString},YES);
        } else {
            completionHandler (nil,YES);
        }
    }];
}

/**
 *  处理照片旧数据，避免沙箱积累过多数据
 */
- (void)handleImageOldData:(NSURL *)fileUrl {
    // 删除旧数据
    NSString *movURLString = [[NSUserDefaults standardUserDefaults] objectForKey:JPGE_URL];
    [[NSFileManager defaultManager] removeItemAtURL:[NSURL URLWithString:movURLString] error:nil];
    
    // 保存新数据的URL，以便下次删除
    [[NSUserDefaults standardUserDefaults] setObject:fileUrl.absoluteString forKey:JPGE_URL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  处理视频旧数据，避免沙箱积累过多数据
 */
- (void)handleVideoOldData:(NSURL *)fileUrl {
    // 删除旧数据
    NSString *movURLString = [[NSUserDefaults standardUserDefaults] objectForKey:MOV_URL];
    [[NSFileManager defaultManager] removeItemAtURL:[NSURL URLWithString:movURLString] error:nil];
    
    // 保存新数据的URL，以便下次删除
    [[NSUserDefaults standardUserDefaults] setObject:fileUrl.absoluteString forKey:MOV_URL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - 腾讯人工智能相关插件
/**
 *  获取唇语
 */
- (void)getVerificationCode:(id)obj callBack:(completionHandler)completionHandler {
    // 网络状态检测
    if ([TBDetectNetworkStatus detectNetworkStatus] == 0) {
        completionHandler(@{},NO);
        return;
    }
    
    NSString *requestUrl = Tencent_URL(@"youtu/openliveapi/livegetfour");
    
    NSString *sign = [QCLocalAuthorizationGenerator signWithAppId:APP_ID secretId:SECRET_ID secretKey:SECRET_KEY];
    NSDictionary *headers = @{@"Host":@"api.youtu.qq.com",
                              @"Content-Type":@"text/json",
                              @"Authorization":sign
                              };
    
    NSDictionary *params = @{@"app_id": APP_ID,
                             @"seq": @""};
    
    [TBHTTPRequestClient asyncPostRequestWithUrl:requestUrl headers:headers params:params timeoutInterval:30.0f success:^(id  _Nullable obj) {
        NSLog(@"成功回调：%@",obj);
        completionHandler(obj,YES);
        
    } fail:^(id  _Nullable obj, NSError * _Nullable error) {
        NSLog(@"失败回调：%@",obj);
        completionHandler(obj,NO);
    }];
}

/**
 *  人脸核身
 */
- (void)faceCheck:(id)obj callBack:(completionHandler)completionHandler {
    // 网络状态检测
    if ([TBDetectNetworkStatus detectNetworkStatus] == 0) {
        completionHandler(@{},NO);
        return;
    }
    
    NSString *url = [obj objectForKey:@"url"];
    NSString *code = [obj objectForKey:@"validate_data"];
    
    NSString *requestUrl = Tencent_URL(@"youtu/openliveapi/livedetectfour");
    NSString *sign = [QCLocalAuthorizationGenerator signWithAppId:APP_ID secretId:SECRET_ID secretKey:SECRET_KEY];
    
    // 视频内容Base64
    NSString *videoBase64 = [TBBase64 encodeData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    // 删除临时文件
    [[NSFileManager defaultManager] removeItemAtURL:[NSURL URLWithString:url] error:nil];
    videoBase64 = videoBase64 == nil ? @"" : videoBase64;
    
    NSDictionary *headers = @{@"Host":@"api.youtu.qq.com",
                              @"Content-Type":@"text/json",
                              @"Authorization":sign
                              };
    
    /**
     *  见鬼！还不能直接传入bool值，否则报400错误！
     *  例如：@"compare_flag":@(false),
     */
    BOOL bool_false = false;
    BOOL bool_true = true;
    NSDictionary *params = @{@"app_id": APP_ID,
                             @"validate_data": code,
                             @"video":videoBase64,
                             @"compare_flag":@(bool_false),
                             @"card":@"",
                             @"seq":@"",
                             @"card_type":@(0),
                             @"live_flag":@(bool_true)
                             };
    
    [TBHTTPRequestClient asyncPostRequestWithUrl:requestUrl headers:headers params:params timeoutInterval:30.0f success:^(id  _Nullable obj) {
        NSLog(@"成功回调：%@",obj);
        completionHandler(obj,YES);
    } fail:^(id  _Nullable obj, NSError * _Nullable error) {
        NSLog(@"失败回调：%@",obj);
        completionHandler(obj,NO);
    }];
}

/**
 *  OCR
 */
- (void)distOCR:(id)obj callBack:(completionHandler)completionHandler {
    // 网络状态检测
    if ([TBDetectNetworkStatus detectNetworkStatus] == 0) {
        completionHandler(@{},NO);
        return;
    }
    
    // 默认正面
    NSNumber *front = @(0);
    
    NSString *frontFlag = [obj objectForKey:@"frontFlag"];
    if ([frontFlag isEqualToString:@"1"]) {
        front = @(1);
    }
    
    NSString *url = [obj objectForKey:@"url"];
    NSString *imgBase64 = [TBBase64 encodeData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    // 删除临时文件
    [[NSFileManager defaultManager] removeItemAtURL:[NSURL URLWithString:url] error:nil];
    imgBase64 = imgBase64 == nil ? @"" : imgBase64;
    
    NSString *requestUrl = Tencent_URL(@"youtu/ocrapi/idcardocr");
    NSString *sign = [QCLocalAuthorizationGenerator signWithAppId:APP_ID secretId:SECRET_ID secretKey:SECRET_KEY];
    NSDictionary *headers = @{@"Host":@"api.youtu.qq.com",
                              @"Content-Type":@"text/json",
                              @"Authorization":sign
                              };
    
    BOOL bool_false = false;
    BOOL bool_true = true;
    NSDictionary *params = @{@"app_id": APP_ID,
                             @"card_type":front,
                             @"image": imgBase64,
                             @"session_id":@"2000",
                             @"border_check_flag":@(bool_false),
                             @"ret_warncode_flag":@(bool_false),
                             @"ret_portrait_flag":@(bool_true)
                             };
    
    [TBHTTPRequestClient asyncPostRequestWithUrl:requestUrl headers:headers params:params timeoutInterval:30.0f success:^(id  _Nullable obj) {
        NSLog(@"成功回调：%@",obj);
        completionHandler(obj,YES);
        
    } fail:^(id  _Nullable obj, NSError * _Nullable error) {
        NSLog(@"失败回调：%@",obj);
        completionHandler(obj,NO);
    }];
}

#pragma mark - 调用原生alert
- (void)nativeAlert:(id)obj callBack:(completionHandler)completionHandler {
    NSString *title = [obj objectForKey:@"title"];
    NSString *msg = [obj objectForKey:@"msg"];
    
    NSString *cancelBtnTitle = [obj objectForKey:@"cancelBtnTitle"];
    
    TBAlertViewController *alertController = [TBAlertViewController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelBtnTitle) {
        alertController.cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction*action) {
            completionHandler(@{@"one":@"1"},NO);
        }];
    }
    
    
    alertController.confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action) {
        completionHandler(@{@"two":@"2"},YES);
    }];
    
    
    [self.viewController presentViewController:alertController animated:YES completion:nil];
    
}

@end
