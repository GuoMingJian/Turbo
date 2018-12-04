//
//  UIView+TBKeyboardOffset.h
//  TBBusiness
//
//  Created by Apple on 2018/10/24.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *   键盘补偿视图协议
 */
@protocol TBKeyboardOffsetDelegate <NSObject>

/**
 *  弹出键盘时，自定义视图向上移动的高度
 *
 *  @param firstResponder 第一响应者
 *  @param keyboardHeight 当前弹出键盘的高度
 *  @param offsetHeight   默认偏移高度
 *
 *  @return 视图向上移动的高度
 */
- (CGFloat)offsetViewHeightWithFirstResponder:(UIView *)firstResponder
                               keyboardHeight:(CGFloat)keyboardHeight
                                 offsetHeight:(CGFloat)offsetHeight;

@end
@interface UIView (TBKeyboardOffset)

/**
 *  键盘与第一响应者的间隙，默认值为5.0
 */
@property (nonatomic, assign) CGFloat keyboardGap;

/**
 *  代理
 *  用于设置视图偏移的高度
 */
@property (nonatomic, weak) id<TBKeyboardOffsetDelegate> keyboardOffsetDelegate;

/**
 *  打开键盘补偿视图
 */
- (void)openKeyboardOffsetView;

/**
 *  关闭键盘补偿视图
 */
- (void)closeKeyboardOffsetView;
@end

NS_ASSUME_NONNULL_END
