//
//  TBViewControllerBase.h
//  TBBusiness
//
//  Created by Apple on 2018/1/25.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBViewControllerBase : UIViewController
/**
 *  是否接收到后台返回前台的通知
 */
@property (nonatomic) BOOL isReceivedNotice;

/**
 *  创建导航控制器左返回按钮
 */
- (void)createLeftItemWithImg:(NSString *)imgName;

/**
 *  设置API，让子类重写
 */
- (void)leftBtnClick:(UIButton *)btn;

/**
 *  是否隐藏导航控制器底部的灰色线条
 */
- (void)hideNavigationBarShadowLine:(BOOL)isHidden;

/**
 *  设置默认的导航控制器背景视图
 */
- (void)setNavigationBarBackgroundImageWithClearImg;

/**
 *  创建waiting图
 */
-(void)createWaitingView;

/**
 *  销毁waiting图
 */
-(void)removeWaitingView;

/**
 *  设置导航标题颜色
 */
-(void)setNavigationItemTitleColor:(UIColor *)color;
@end
