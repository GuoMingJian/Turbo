//
//  TBWKWebView.h
//  TBBusiness
//
//  Created by Apple on 2018/6/9.
//  Copyright © 2018年 Apple. All rights reserved.
//


#import "DWKWebView.h"

@protocol TBWKWebViewDelegate <NSObject>
// 拦截URL
-(void)webViewDecidePolicyForNavigationAction:(NSString *)absoluteString decisionHandler:(void (^) (BOOL isAllow))decisionHandler;
// 开始加载
-(void)webViewDidStartLoad:(WKWebView *)webView;
// 完成加载
-(void)webViewDidFinishLoad:(WKWebView *)webView;
// 加载失败
-(void)webViewDidFailLoad:(WKWebView *)webView;
@end


@interface TBWKWebView : DWKWebView

// 设置代理
@property (nonatomic, weak) id <TBWKWebViewDelegate> delegate;

/**
 *  @param frame            DWKWebView的区域
 *  @param htmlPath         需要展示的H5地址
 *  @param viewController   视图控制器
 *  return 返回DWKWebView实例化对象
 */
-(instancetype)initWithFrame:(CGRect)frame andHtmlPath:(NSString *)htmlPath andViewController:(UIViewController *)viewController;

/**
 *  刷新页面
 *  APP从后台返回前台时，调用此方法重新刷新webView；
 *  目的：假如有增量更新信息，能让用户能及时访问新资源；
 */
-(void)refreshWebViewWithUrl:(NSString *)url;

@end
