//
//  UIView+TBKeyboardOffset.m
//  TBBusiness
//
//  Created by Apple on 2018/10/24.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "UIView+TBKeyboardOffset.h"
#import <objc/runtime.h>

@implementation UIView (TBKeyboardOffset)
static char kKeyboardGap;
static char kKeyboardOffsetDelegate;

#pragma mark - 键盘与第一响应者的间隙
- (void)setKeyboardGap:(CGFloat)keyboardGap
{
    //#import <objc/runtime.h>头文件
    //objc_setAssociatedObject 需要四个参数：源对象，关键字，关联的对象，一个关联策略。
    objc_setAssociatedObject(self, &kKeyboardGap, [NSNumber numberWithFloat:keyboardGap], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)keyboardGap
{
    /**
     *  通过 objc_getAssociatedObject获取关联对象
     *  未设置该属性，则返回默认值
     */
    if (objc_getAssociatedObject(self, &kKeyboardGap) == nil)
        return 5.0;
    
    return [objc_getAssociatedObject(self, &kKeyboardGap) floatValue];
}

/** 委托，用于设置视图偏移的高度 */
- (void)setKeyboardOffsetViewDelegate:(id <TBKeyboardOffsetDelegate>)keyboardOffsetViewDelegate
{
    objc_setAssociatedObject(self, &kKeyboardOffsetDelegate, keyboardOffsetViewDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id <TBKeyboardOffsetDelegate>)keyboardOffsetViewDelegate
{
    return objc_getAssociatedObject(self, &kKeyboardOffsetDelegate);
}

#pragma mark - 打开键盘补偿视图
- (void)openKeyboardOffsetView
{
    // 监视键盘出现和键盘消失的消息
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillAppear:)
                                                name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillDisappear:)
                                                name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 关闭键盘补偿视图
- (void)closeKeyboardOffsetView
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

/**
 *  获取视图的第一响应者，采用递归的方式
 *
 *  @return 视图的第一响应者，不存在第一响应者则返回nil
 */
- (UIView *)firstResponder
{
    if([self isKindOfClass:[UITextField class]] || [self isKindOfClass:[UITextView class]])
    {
        if(self.isFirstResponder)
        {
            return self;
        }
        else
        {
            return nil;
        }
    }
    
    NSArray *subViews = [self subviews];
    
    if(subViews.count == 0)
    {
        return nil;
    }
    
    for(UIView *control in subViews)
    {
        UIView *firstResponder = [control firstResponder];
        if(firstResponder)
        {
            return firstResponder;
        }
    }
    
    return nil;
}

#pragma mark - 获取键盘的高度
- (CGFloat)keyboardFrameHeight:(NSDictionary *)userInfo
{
    CGRect keyboardUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardFrame = [self convertRect:keyboardUncorrectedFrame fromView:nil];
    return keyboardFrame.size.height;
}

#pragma mark - 键盘出现，向上移动视图
- (void)keyboardWillAppear:(NSNotification *)notification
{
    CGFloat keyboardHeight = [self keyboardFrameHeight:[notification userInfo]];  // 键盘高度
    CGFloat duration = [[notification userInfo][UIKeyboardAnimationDurationUserInfoKey] floatValue];    // 键盘弹出动画的持续时间
    UIViewAnimationOptions options = [[notification userInfo][UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16; // 键盘弹出动画的时间曲线
    
    // 获取第一响应者的位置
    UIView *firstResponder = [self firstResponder];
    //TBLog(firstResponder);
    if (!firstResponder)
    {
        return;
    }
    CGRect rect = [firstResponder.superview convertRect:firstResponder.frame toView:self];
    
    // 计算向上偏移的高度，根据当前的第一响应者计算视图偏移高度，当键盘没有遮挡输入框时，弹出键盘时不需要移动视图
    //NSLog(@"%f", self.frame.origin.y);
    if (self.frame.origin.y != 0)
    {
        [self hiddenKeyBoard];
    }
    CGFloat offsetViewHeight = self.frame.size.height - rect.origin.y - rect.size.height - self.keyboardGap;
    if (keyboardHeight < offsetViewHeight){
        offsetViewHeight = 0;
    } else {
        offsetViewHeight = keyboardHeight - offsetViewHeight;
    }
    
    // 通过代理获取视图偏移的高度
    if([self.keyboardOffsetViewDelegate respondsToSelector:@selector(offsetViewHeightWithFirstResponder:keyboardHeight:offsetHeight:)])
    {
        offsetViewHeight  = [self.keyboardOffsetViewDelegate offsetViewHeightWithFirstResponder:firstResponder keyboardHeight:keyboardHeight offsetHeight:offsetViewHeight];
    }
    
    // 执行向上移动视图的动画
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:options
                     animations:^{
                         // 改变Y轴起点
                         CGFloat originY = self.frame.origin.y - offsetViewHeight;
                         self.frame = CGRectMake(self.frame.origin.x, originY, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL completed) {
                         // 动画结束后执行的代码
                     }];
}

#pragma mark - 键盘消失，还原视图
-(void)keyboardWillDisappear:(NSNotification *)notification
{
    CGFloat duration = [[notification userInfo][UIKeyboardAnimationDurationUserInfoKey] floatValue];    // 动画持续时间
    UIViewAnimationOptions options = [[notification userInfo][UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16; // 动画时间曲线
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:options
                     animations:^{
                         // 还原位置
                         self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL completed) {
                         // 动画结束后执行的代码
                     }];
}

//还原位置
- (void)hiddenKeyBoard
{
    [UIView animateWithDuration:0.25 animations:^{
        // 还原位置
        self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }];
}

@end
