//
//  GRFirstViewController.m
//  TBBusiness
//
//  Created by Apple on 2018/1/25.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TBFirstViewController.h"
#import "TBNetworkRequest.h"
#import <Turbo/Turbo.h>
#import "TBH5BrowserViewController.h"
#import "TBUpdateTipsView.h"
#import "TBWKWebView.h"
#import "dsbridge.h"
#import "TBViewControllerManager.h"
#import "TBGuideViewController.h"
#import <TBCatchException/TBExceptionManager.h>
#import "TBScanViewController.h"
#import "MJSearchBar.h"
#import "Header.h"

@interface TBFirstViewController ()<TBWKWebViewDelegate, UISearchBarDelegate, MJSearchBarDelegate>
@property (nonatomic, strong) TBWKWebView *webView;
@property (nonatomic, strong) UISearchBar *searchBar;
// 用于触发searchBar弹起键盘的时候使用，方便收起键盘
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *naviBarView;
@end

@implementation TBFirstViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self hideNavigationBarShadowLine:YES];
    
    /**
     *  界面出现时判断APP是否是从后台返回到前台；
     *  如果是，则刷新webView，并将bool值置为NO；
     */
    if (self.isReceivedNotice) {
        [self.webView refreshWebViewWithUrl:self.path];
        self.isReceivedNotice = NO;
    }
    
    [self setNavigationItemTitleColor:[UIColor blackColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createNaviBarView];
    // 创建原生头
    [self createTitleView];
    // 添加webView
    self.path = @"main/mainPage/index";
    [self createWebView:self.path];
    
    // 保存跳转的controller
    TBViewControllerManager *vcManager = [TBViewControllerManager shareInstance];
    [vcManager.viewControllerArr addObject:@{self.path:self}];
    
    // 设置通知监听者，接收APP返回前台的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveEnterForegroundNotice:) name:ENTER_FOREGROUND_NOTICE object:nil];
}

#pragma mark - 获取通知（用于离线更新）
-(void)receiveEnterForegroundNotice:(NSNotification *)notice {
    self.isReceivedNotice = YES;
}

#pragma mark - 创建导航栏视图(用于优化体验)
-(void)createNaviBarView {
    self.naviBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundImg"]];
    imgView.frame = self.naviBarView.frame;
    [self.naviBarView addSubview:imgView];
    [self.view addSubview:self.naviBarView];
}

#pragma mark - 创建原生头
-(void)createTitleView {
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
    self.titleView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = self.titleView;
    
    CGFloat totalW = MAIN_SCREEN_WIDTH;
    CGFloat totalH = NAVIGATION_BAR_HEIGHT;
    
    UIImage *scanImg = [UIImage imageNamed:@"scan"];
    CGFloat leftBtnW = scanImg.size.width;
    CGFloat leftBtnH = scanImg.size.height;
    CGFloat leftBtnX = 10.0f;
    CGFloat leftBtnY = (totalH - leftBtnH) / 2;
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn addTarget:self action:@selector(leftItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setFrame:CGRectMake(leftBtnX, leftBtnY, leftBtnW, leftBtnH)];
    [leftBtn setImage:scanImg forState:UIControlStateNormal];
    [self.titleView addSubview:leftBtn];
    
    UIImage *messageImg = [UIImage imageNamed:@"message"];
    CGFloat rightBtnW = messageImg.size.width;
    CGFloat rightBtnH = messageImg.size.height;
    CGFloat rightBtnX = totalW - rightBtnW - 20;
    CGFloat rightBtnY = (totalH - rightBtnH) / 2;
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(rightBtnX, rightBtnY, rightBtnW, rightBtnH)];
    [rightBtn setImage:messageImg forState:UIControlStateNormal];
    [self.titleView addSubview:rightBtn];
    
    CGFloat searchBarBackgroundViewX = CGRectGetMaxX(leftBtn.frame) + 15;
    CGFloat searchBarBackgroundViewW = rightBtnX - searchBarBackgroundViewX - 15;
    CGFloat searchBarBackgroundViewH = 30;
    CGFloat searchBarBackgroundViewY = (totalH - searchBarBackgroundViewH) / 2;
    UIView *searchBarBackgroundView = [[UIView alloc] initWithFrame:
                                       CGRectMake(searchBarBackgroundViewX,
                                                  searchBarBackgroundViewY,
                                                  searchBarBackgroundViewW,
                                                  searchBarBackgroundViewH)];
    searchBarBackgroundView.backgroundColor = [UIColor clearColor];
    [self.titleView addSubview:searchBarBackgroundView];
    //    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:searchBarBackgroundView.bounds];
    //    searchBar.delegate = self;
    //    searchBar.layer.cornerRadius = searchBar.frame.size.height / 2;
    //    searchBar.clipsToBounds = YES;
    //    self.searchBar = searchBar;
    //    searchBar.tintColor = [UIColor whiteColor];
    //    UITextField *searchField = [searchBar valueForKey:@"searchField"];
    //    searchField.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
    //    searchField.textColor = [UIColor whiteColor];
    //    [searchBarBackgroundView addSubview:searchBar];
    
    MJSearchBar *searchBar = [[MJSearchBar alloc] initWithFrame:searchBarBackgroundView.bounds];
    searchBar.delegate = self;
    searchBar.searBarColor = [UIColor colorWithWhite:0 alpha:0.5f];
    searchBar.textColor = [UIColor whiteColor];
    searchBar.searBarFont = [UIFont systemFontOfSize:15.0];
    searchBar.placeholder = @"";
    searchBar.placeholdesFont = [UIFont systemFontOfSize:15.0];
    [searchBar setTintColor: [UIColor lightTextColor]];
    [searchBarBackgroundView addSubview:searchBar];
}

#pragma mark - UISearchBarDelegate 方法
//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
//    [self createKBackgroundView];
//    return YES;
//}
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    [self handleSearchBarDoneEvent];
//}

#pragma mark - MJSearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(MJSearchBar *)searchBar
{
    [self createKBackgroundView];
    return YES;
}

- (void)searchBarSearchButtonClicked:(MJSearchBar *)searchBar
{
    [self handleSearchBarDoneEvent];
}

#pragma mark - 创建背景图、移除背景图(方便控制键盘的收起)
-(void)createKBackgroundView {
    if (!self.backgroundView) {
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT)];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.backgroundView];
    }
}

-(void)removeKBackgroundView {
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

#pragma mark -
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self handleSearchBarDoneEvent];
}

#pragma mark -
-(void)handleSearchBarDoneEvent {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    self.searchBar.text = @"";
    [self removeKBackgroundView];
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

#pragma mark - leftBtn点击，开始二维码扫描
-(void)leftItemClick:(UIButton *)leftBtn {
    TBScanViewController *scanViewController = [[TBScanViewController alloc] init];
    [scanViewController setResultBlock:^(id  _Nonnull obj) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *url = [NSString stringWithFormat:@"%@",obj];
            TBH5BrowserViewController *vc = [[TBH5BrowserViewController alloc] init];
            vc.htmlPath = url;
            vc.isShowNaviBar = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    [self.navigationController pushViewController:scanViewController animated:YES];
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
    
}

// 加载失败
-(void)webViewDidFailLoad:(WKWebView *)webView {
    
}

@end

