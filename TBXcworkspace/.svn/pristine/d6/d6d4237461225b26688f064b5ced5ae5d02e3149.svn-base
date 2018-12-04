//
//  GRSecondViewController.m
//  TBBusiness
//
//  Created by Apple on 2018/1/25.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TBSecondViewController.h"
#import <Turbo/Turbo.h>
#import "dsbridge.h"

#import "TBWKWebView.h"
#import "dsbridge.h"

@interface TBSecondViewController ()<TBWKWebViewDelegate>
@property (nonatomic, strong) TBWKWebView *webView;
@property (nonatomic, copy) NSString *path;
@end

@implementation TBSecondViewController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self hideNavigationBarShadowLine:NO];
    
    /**
     *  界面出现时判断APP是否是从后台返回到前台；
     *  如果是，则刷新webView，并将bool值置为NO；
     */
    if (self.isReceivedNotice) {
        [self.webView refreshWebViewWithUrl:self.path];
        self.isReceivedNotice = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加webView
    self.path = @"wealth/wealthPage/index";
    [self createWebView:self.path];
    
    // 设置通知监听者，接收APP返回前台的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveEnterForegroundNotice:) name:ENTER_FOREGROUND_NOTICE object:nil];
}

#pragma mark - 获取通知（用于离线更新）
-(void)receiveEnterForegroundNotice:(NSNotification *)notice {
    self.isReceivedNotice = YES;
}

#pragma mark - 创建webView
-(void)createWebView:(NSString *)htmlPath {
    UIViewController *tempViewController;
    if (self.navigationController) {
        tempViewController = self.navigationController;
    } else {
        tempViewController = self;
    }
    
    CGFloat webViewX = 0;
    CGFloat webViewY = STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT;
    CGFloat webViewW = MAIN_SCREEN_WIDTH;
    CGFloat webViewH = MAIN_SCREEN_HEIGHT - webViewY - TAB_BAR_HEIGHT;
    self.webView = [[TBWKWebView alloc] initWithFrame:CGRectMake(webViewX, webViewY, webViewW, webViewH) andHtmlPath:htmlPath andViewController:tempViewController];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
}

#pragma mark - TBWKWebViewDelegate 方法
// 拦截URL
-(void)webViewDecidePolicyForNavigationAction:(NSString *)absoluteString decisionHandler:(void (^) (BOOL isAllow))decisionHandler {
    
}

// 开始加载
-(void)webViewDidStartLoad:(WKWebView *)webView {
    
}

// 完成加载
-(void)webViewDidFinishLoad:(WKWebView *)webView {
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        NSString *title = [NSString stringWithFormat:@"%@",obj];
        self.navigationItem.title = title; 
    }];
    
}

// 加载失败
-(void)webViewDidFailLoad:(WKWebView *)webView {
 
}

@end
