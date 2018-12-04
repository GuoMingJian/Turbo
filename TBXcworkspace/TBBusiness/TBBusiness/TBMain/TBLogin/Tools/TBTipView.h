//
//  TBTipView.h
//  ZXToolProjects
//
//  Created by 郭明健 on 2018/6/25.
//  Copyright © 2018年 GuoMingJian. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 提示框显示的位置，默认居中
 */
typedef NS_ENUM(NSInteger, TBAlignment)
{
    TBCenter = 0,
    TBTop,
    TBBottom,
};

@interface TBTipView : UIView

#pragma mark - 自定义提示框

/**
 弹出提示框
 */
+ (void)showTipView:(NSString *)text;

/**
 弹出提示框；duration时间后消失
 */
+ (void)showTipView:(NSString *)text
           duration:(CGFloat)duration;

/**
 弹出提示框；alignment显示位置，TBTop上，TBCenter 中, TBBottom 下
 */
+ (void)showTipView:(NSString *)text
          alignment:(TBAlignment)alignment;

/**
 弹出提示框；时间，位置
 */
+ (void)showTipView:(NSString *)text
           duration:(CGFloat)duration
          alignment:(TBAlignment)alignment;

@end
