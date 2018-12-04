//
//  TBUpdateTipsView.h
//  TBBusiness
//
//  Created by Apple on 2018/9/5.
//  Copyright © 2018年 Apple. All rights reserved.
//  更新提示视图

#import <UIKit/UIKit.h>
typedef void(^updateTipsViewBlcok)(void);

@interface TBUpdateTipsView : UIView
// block回调
@property (nonatomic, strong) updateTipsViewBlcok updateTipsViewBlock;
// 更新提示话术
@property (nonatomic, copy) NSString *message;

/**
 *  是否隐藏关闭按钮
 *  1、如果isHideCloseBtn为NO则显示关闭按钮，让用户选择是否跳转App Store更新；
 *  2、如果isHideCloseBtn为YES则隐藏关闭按钮，让用户只能点击"立即更新"按钮；
 */
@property (nonatomic) BOOL isHideCloseBtn;


/**
 *  隐藏
 */
-(void)hidden;

/**
 用法说明：
 1、初始化TBUpdateTipsView；
 2、设置关闭按钮是否隐藏；
 3、传入更新的提示内容；
 4、设置block回调，准备跳转到App Store；
 
 TBUpdateTipsView *tipsView = [[TBUpdateTipsView alloc] init];
 tipsView.isHideCloseBtn = NO;
 tipsView.message = @"APP更新啦！";
 tipsView.updateTipsViewBlock = ^{
    // 回调
 };
 */

@end
