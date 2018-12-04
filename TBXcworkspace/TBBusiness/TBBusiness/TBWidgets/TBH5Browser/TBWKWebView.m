//
//  TBWKWebView.m
//  TBBusiness
//
//  Created by Apple on 2018/6/9.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TBWKWebView.h"
#import "TBWebViewPlugin.h"
#import "TBUpdateModuleFactory.h"
#import "TBActivityView.h"
#import "YYCache.h"
#import <Turbo/Turbo.h>
#import "HTTPServer.h"

@interface TBWKWebView ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) TBActivityView *activityView;
@property (nonatomic, strong) UIViewController *viewController;

@end

@implementation TBWKWebView

-(instancetype)initWithFrame:(CGRect)frame andHtmlPath:(NSString *)htmlPath andViewController:(UIViewController *)viewController {
    
    self = [super initWithFrame:frame];
    self.scrollView.showsVerticalScrollIndicator = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.scrollEnabled = NO;
    self.viewController = viewController;
    
    // 针对iOS 11.0系统(iPhone X)做的处理
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior  = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    // 设置代理
    self.navigationDelegate = self;
    
    // 添加JS插件
    TBWebViewPlugin *webViewPlugin = [[TBWebViewPlugin alloc] init];
    if (viewController) {
        [webViewPlugin setViewController:viewController];
    }
    [self addJavascriptObject:webViewPlugin namespace:@""];
    
    // 加载网页
    [self loadWebViewWithPath:htmlPath];
    
    return self;
}

#pragma mark - 加载webView
- (void)loadWebViewWithPath:(NSString *)htmlPath {
    NSURL *htmlUrl;
    if (htmlPath != nil && htmlPath.length > 0) {
        /**
         *  逻辑说明：如果传入的URL有"http"前缀，则认为是一个网址；
         *          否则，将其作为本地H5资源处理；
         */
        if ([htmlPath hasPrefix:@"http"]) {
            htmlUrl = [NSURL URLWithString:htmlPath];
            [self loadRequest:[NSURLRequest requestWithURL:htmlUrl]];
        } else {
            // 检测模块是否有更新、回滚
            NSString *absolutePath = [self getAbsolutionPath:htmlPath];
            if (absolutePath) {
                if ([absolutePath hasPrefix:@"http"]) {
                    // 需要更新或回滚 先读取远程H5
                    htmlUrl = [NSURL URLWithString:absolutePath];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self loadRequest:[NSURLRequest requestWithURL:htmlUrl]];
                    });
                } else {
                    //                    //http://192.168.1.114:8080/creditCard/creditCardPage/index.html
                    //                    NSString *port = [[NSUserDefaults standardUserDefaults] objectForKey:@"webPort"];
                    //                    NSString *url = [NSString stringWithFormat:@"http://localhost:%@/index.html", port];
                    //                    NSLog(@"%@", url);
                    ////                    NSString *url = @"http://192.168.1.114:8080/creditCard/creditCardPage/index.html";
                    //                    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
                    //                    [self loadRequest:request];
                    
                    //无需更新 读取本地资源
                    htmlUrl = [NSURL fileURLWithPath:absolutePath];
                    NSURL *baseUrl = [NSURL fileURLWithPath:TB_WWW_DIRECTORY];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self loadFileURL:htmlUrl allowingReadAccessToURL:baseUrl];
                    });
                }
            }
        }
    }
}

#pragma mark - 刷新webView
-(void)refreshWebViewWithUrl:(NSString *)url {
    [self loadWebViewWithPath:url];
    [self reload];
}

#pragma mark - 获取html的沙箱绝对路径
-(NSString *)getAbsolutionPath:(NSString *)relativePath {
    if (!relativePath || relativePath.length == 0) {
        return nil;
    }
    
    /**
     *  1.默认先从本地获取H5资源
     */
    NSString *path = [NSString stringWithFormat:@"%@/%@.html",TB_WWW_DIRECTORY,relativePath];
    
    /**
     *  2.检查是否需要回滚
     */
    id obj = [CONFIG_JSON_PATH jsonAnalyze];
    //TBLog(obj);
    BOOL rollBack = [[obj objectForKey:@"rollBack"] boolValue];
    if (!rollBack) {
        /**
         *  2-1.无需回滚，检查模块更新
         */
        
        // 先将relativePath前面多余的'/'去掉，避免因数据异常做切割时得到一个空值；
        for (int i = 0; i < relativePath.length; i ++) {
            char c  = [relativePath characterAtIndex:i];
            if (c == '/') {
                relativePath = [relativePath substringFromIndex:(i+1)];
            } else {
                break;
            }
        }
        // 切割relativePath获取模块名称
        NSArray *tempArr = [relativePath componentsSeparatedByString:@"/"];
        if (tempArr.count > 0) {
            NSString *moduleName = [tempArr objectAtIndex:0];
            NSString *updateUrl = [[TBUpdateModuleFactory shareFactoryInstance] analyzeWithModuleName:moduleName];
            if (updateUrl && updateUrl.length > 0) {
                // 如果返回URL，说明需要更新，先读取远程的H5资源，同时开启下载
                NSString *version = [obj objectForKey:@"version"];
                path = [NSString stringWithFormat:@"%@/%@/%@.html",REMOTE_BASE_URL,version, relativePath];
                // 转码
                path = URL_ENCODE(path);
                // 下载模块zip包、解压并移动文件
                [[TBUpdateModuleFactory shareFactoryInstance] downloadModuleZipWithUrlAndMoveFiles:updateUrl];
            }
        }
    } else {
        /**
         *  2-2.需要回滚，先获取需要回滚版本号与本地的对比，如果一致，访问本地资源，否则访问远程
         */
        NSString *rollBackVersion = [obj objectForKey:@"rollBackVersion"];
        YYCache *cache = [YYCache cacheWithName:FILE_NAME_LIST];
        NSString *localVersion = (NSString *)[cache objectForKey:DIST_VERSION];
        if (![rollBackVersion isEqualToString:localVersion]) {
            // 不一致，拼凑远程URL
            path = [NSString stringWithFormat:@"%@/%@/%@.html",REMOTE_BASE_URL,rollBackVersion, relativePath];
            // 转码
            path = URL_ENCODE(path);
        }
    }
    
    return path;
}

#pragma mark - WKUIDelegate代理方法
#if 0

- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    return nil;
}

- (void)webViewDidClose:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0)) {
    
}

/**
 *  web界面中有弹出警告框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param message           警告框中的内容
 *  @param frame             主窗口
 *  @param completionHandler 警告框消失调用
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    // 不回调会崩溃
    completionHandler();
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler {
    
}

- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo API_AVAILABLE(ios(10.0)) {
    
    return YES;
}

- (nullable UIViewController *)webView:(WKWebView *)webView previewingViewControllerForElement:(WKPreviewElementInfo *)elementInfo defaultActions:(NSArray<id <WKPreviewActionItem>> *)previewActions API_AVAILABLE(ios(10.0)) {
    
    return self;
}

- (void)webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController API_AVAILABLE(ios(10.0)) {
    
}

- (void)webView:(WKWebView *)webView runOpenPanelWithParameters:(WKOpenPanelParameters *)parameters initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSArray<NSURL *> * _Nullable URLs))completionHandler API_AVAILABLE(macosx(10.12)) {
    
}
#endif

#pragma mark - WKScriptMessageHandler代理方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
}

#pragma mark - WKNavigationDelegate 代理方法
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {   /** 拦截URL */
    /** 逻辑说明：
     *  拦截URL
     */
    NSURL *URL = navigationAction.request.URL;
    NSString *absoluteStr = [URL absoluteString];
    
    // 指使代理
    __block BOOL allow = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewDecidePolicyForNavigationAction:decisionHandler:)]) {
        [self.delegate webViewDecidePolicyForNavigationAction:absoluteStr decisionHandler:^(BOOL isAllow) {
            allow = isAllow;
        }];
    }
    
    if (allow) {
        // 允许加载
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        // 不允许加载
        decisionHandler (WKNavigationActionPolicyCancel);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    // 不回调会崩溃
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    // 开始加载
    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:webView];
    }
    // 开始加载 延迟0.3s显示waiting图
    [self performSelector:@selector(createWaitingView) withObject:nil afterDelay:0.3f];
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    // 完成加载
    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:webView];
    }
    // 如果0.3s内完成加载则取消加载waiting图
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(createWaitingView) object:nil];
    [self removeWaitingView];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    // 加载失败
    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewDidFailLoad:)]) {
        [self.delegate webViewDidFailLoad:webView];
    }
    
    // 如果0.3s内加载失败则取消加载waiting图
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(createWaitingView) object:nil];
    [self removeWaitingView];
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    // 不回调会崩溃
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling,nil);
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0)) {
    
}

#pragma mark - 创建waiting图
- (void)createWaitingView {
    if (!self.activityView) {
        self.activityView = [[TBActivityView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.activityView.center = self.viewController.view.center;
        [self.viewController.view addSubview:self.activityView];
    }
}

#pragma mark - 销毁waiting图
- (void)removeWaitingView {
    if (self.activityView) {
        [self.activityView removeFromSuperview];
        self.activityView = nil;
    }
}

@end
