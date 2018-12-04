//
//  TBH5BrowserViewController.h
//  TBBusiness
//
//  Created by Apple on 2018/5/19.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TBViewControllerBase.h"
#import "TBWKWebView.h"

@interface TBH5BrowserViewController : TBViewControllerBase <TBWKWebViewDelegate>

/**
 *  H5资源(可以是网址，也可以是本地H5资源路径)
 */
@property (nonatomic, copy) NSString *htmlPath;

/**
 *  是否显示导航控制器 YES:显示 NO:不显示
 */
@property (nonatomic) BOOL isShowNaviBar;

/**
 *  滚动webView时，导航控制器是否透明
 *  说明：当isShowNaviBar为YES时才处理
 */
@property (nonatomic) BOOL isTransparent;

/**
 *  点击左上角返回按钮时，根据backPageNum判断出栈多少层(默认为1)
 */
@property (nonatomic) NSInteger backPageNum;

/**
 *  传递给webView的参数
 */
@property (nonatomic, strong) NSDictionary *params;
@end
