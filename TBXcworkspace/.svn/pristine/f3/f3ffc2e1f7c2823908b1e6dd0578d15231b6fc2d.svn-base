//
//  TBGesturePasswordView.m
//  ZXToolProjects
//
//  Created by 郭明健 on 2018/6/26.
//  Copyright © 2018年 GuoMingJian. All rights reserved.
//

#import "TBGesturePasswordView.h"

@interface TBGesturePasswordView ()

@property (nonatomic, strong) NSMutableArray    *selectBtnArray;
@property (nonatomic, assign) CGPoint           fingerPoint;

@end

@implementation TBGesturePasswordView

//布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //NSLog(@"%f---%f", _btnSpac, _btnWidth);
    if (self.btnSpac == 0)
    {
        self.btnSpac = (self.frame.size.width - 3 * self.btnWidth) / 4;
    }
    
    if (self.btnWidth == 0)
    {
        self.btnWidth = (self.frame.size.width - 3 * self.btnSpac) / 3;
    }
    
    for (int i = 1; i <= self.subviews.count; i ++)
    {
        NSInteger row = (i-1) / 3;
        NSInteger column = (i-1) % 3;
        UIButton *btn = [self viewWithTag:i];
        
        CGFloat x = self.btnSpac + column * (self.btnWidth + self.btnSpac);
        CGFloat y = self.btnSpac + row * (self.btnWidth + self.btnSpac);
        btn.frame = CGRectMake(x, y, self.btnWidth, self.btnWidth);
    }
}

#pragma mark - 外部调用API

- (void)setupUI
{
    for (UIView *subView in self.subviews)
    {
        [subView removeFromSuperview];
    }
    
    if (self.type == TBUnTouch)
    {
        self.userInteractionEnabled = NO;
    }
    
    for (int i = 1; i <= 9; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:self.normalImgStr] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:self.correctImgStr] forState:UIControlStateSelected];
        button.userInteractionEnabled = NO;
        button.tag = i;
        [self addSubview:button];
        /*
         if (self.type != TBUnTouch)
         {
         UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
         lab.textColor = [UIColor whiteColor];
         lab.text = [NSString stringWithFormat:@"%d", i];
         [button addSubview:lab];
         }
         */
    }
}

- (void)updateUIWithBtnArr:(NSArray *)array isSelected:(BOOL)state
{
    if (!array)
    {
        for (int i = 1; i <= 9; i ++)
        {
            UIButton *button = [self viewWithTag:i];
            if (button)
            {
                button.selected = NO;
            }
        }
        return;
    }
    for (int i = 0; i < array.count; i ++)
    {
        NSInteger index = 1991;
        if ([array[i] isKindOfClass:[UIButton class]])
        {
            UIButton *tmpBtn = array[i];
            index = tmpBtn.tag;
        }
        else
        {
            index = [array[i] integerValue];
        }
        
        UIButton *button = [self viewWithTag:index];
        if (button)
        {
            button.selected = state;
        }
    }
}

+ (NSString *)getPassword
{
    NSString *pwd = [self getUserDefault:kSavedPasswordKey];
    return pwd;
}

+ (void)setPassword:(NSString *)pwd
{
    [self setUserDefault:pwd key:kSavedPasswordKey];
}

+ (NSString *)getFirstPassword
{
    return [self getUserDefault:kFirstPasswordKey];
}

+ (void)setFirstPassword:(NSString *)pwd
{
    [self setUserDefault:pwd key:kFirstPasswordKey];
}

#pragma mark -

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //密码输错次数超出可用次数
    if (self.type == TBCheckPassword && self.maxInputErrorCount == 0)
    {
        return;
    }
    
    [self changeButtonSelectedStateWith:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //密码输错次数超出可用次数
    if (self.type == TBCheckPassword && self.maxInputErrorCount == 0)
    {
        return;
    }
    
    //9个全部选择此时不再画线
    if (self.selectBtnArray.count == 9)
    {
        return;
    }
    
    [self changeButtonSelectedStateWith:touches];
    self.fingerPoint = [self getCurrentTouchPoint:touches];
    [self setNeedsDisplay];//绘制手指经过的线条
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSString *oldPassword = [TBGesturePasswordView getPassword];
    NSString *currentPwd = [self getCurrentPassword];
    if ([currentPwd isEqualToString:@""])
    {
        //未选中按钮
        return;
    }
    
    //业务逻辑判断
    if (self.type == TBSetPassword)
    {
        [self gotoTBSetPasswordType:currentPwd];
    }
    else if (self.type == TBCheckPassword)
    {
        [self checkPwd:oldPassword newPwd:currentPwd];
    }
}

#pragma mark - 绘制手指滑动轨迹

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.selectBtnArray.count)
    {
        //画线
        UIBezierPath *path = [UIBezierPath bezierPath];
        for (int i = 0; i < self.selectBtnArray.count; i ++)
        {
            UIButton *button = self.selectBtnArray[i];
            if (i == 0)
            {
                [path moveToPoint:button.center];//起点为第一个经过的按钮的中心点
            }
            else
            {
                [path addLineToPoint:button.center];
            }
        }
        [path addLineToPoint:self.fingerPoint];
        path.lineWidth = 5;
        [self.lineColor set];
        path.lineJoinStyle = kCGLineCapRound;//该属性值指定绘制圆形端点， 线条结尾处绘制一个直径为线条宽度的半圆
        [path stroke];
    }
}

#pragma mark - 业务逻辑

- (void)gotoTBSetPasswordType:(NSString *)currentPwd
{
    NSString *firstPassword = [TBGesturePasswordView getFirstPassword];
    //当前为第一次设置密码
    if (!firstPassword || firstPassword.length == 0)
    {
        if (currentPwd.length < self.minSelectedCount)
        {//密码长度不够
            if (self.inputLengthError)
            {
                self.inputLengthError(self.minSelectedCount);
            }
            //
            [self showErrorUI];
        }
        else
        {//保存第一次设置的密码
            if (self.inputFirstSuccess)
            {
                self.inputFirstSuccess(self.selectBtnArray, currentPwd);
            }
            //
            [TBGesturePasswordView setFirstPassword:currentPwd];
            [self showNormalUI];
        }
    }
    else
    {
        //验证密码
        [self checkPwd:firstPassword newPwd:currentPwd];
    }
}

//验证两次密码
- (void)checkPwd:(NSString *)oldPwd newPwd:(NSString *)newPwd
{
    if (![oldPwd isEqualToString:newPwd])
    {//二次输入不一致
        if (self.type == TBSetPassword)
        {
            if (self.inputSecondFailure)
            {
                self.inputSecondFailure();
            }
            [self showErrorUI];
        }
        else if (self.type == TBCheckPassword)
        {
            if (_maxInputErrorCount == 0)
            {
                self.userInteractionEnabled = NO;
            }
            else
            {
                if (self.inputPwdError)
                {//验证失败并返回剩余登录次数
                    self.inputPwdError((--_maxInputErrorCount), self.selectBtnArray);
                }
                [self showErrorUI];
            }
        }
    }
    else
    {//二次输入一致
        if (self.type == TBSetPassword)
        {
            if (self.inputSecondSuccess)
            {
                self.inputSecondSuccess(self.selectBtnArray, newPwd);
            }
            //保存密码
            [TBGesturePasswordView setPassword:newPwd];
            [self showNormalUI];
        }
        else if (self.type == TBCheckPassword)
        {
            if (self.inputSecondSuccess)
            {
                self.inputSecondSuccess(self.selectBtnArray, newPwd);
            }
            [self showNormalUI];
        }
    }
}

#pragma mark - private

- (void)changeButtonSelectedStateWith:(NSSet <UITouch *> *)touches
{
    CGPoint point = [self getCurrentTouchPoint:touches];
    UIButton *button = [self getCurrentButton:point];
    if (button && button.selected == NO)
    {
        button.selected = YES;
        [self.selectBtnArray addObject:button];
        //NSLog(@"--%ld", (long)button.tag);
    }
}

- (CGPoint)getCurrentTouchPoint:(NSSet <UITouch *> *)touches
{
    UITouch *touch = touches.anyObject;
    return [touch locationInView:self];
}

//判断手指触摸到的地方是否在按钮内
- (UIButton *)getCurrentButton:(CGPoint)point
{
    for (UIButton *button in self.subviews)
    {
        if (CGRectContainsPoint(button.frame, point))
        {
            return button;
        }
    }
    return nil;
}

- (NSString *)getCurrentPassword
{
    NSString *string = @"";
    for (UIButton *button in self.selectBtnArray)
    {
        string = [string stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)button.tag]];
    }
    return string;
}

- (void)showErrorUI
{
    [self setErrorSelectBtnStyle];
    [self setNeedsDisplay];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setDefaultSelectBtnStyle];
        [self setNeedsDisplay];
    });
}

- (void)showNormalUI
{
    [self setDefaultSelectBtnStyle];
    [self setNeedsDisplay];
}

- (void)setErrorSelectBtnStyle
{
    for (int i = 0; i < self.selectBtnArray.count; i ++)
    {
        UIButton *button = self.selectBtnArray[i];
        [button setImage:[UIImage imageNamed:kErrorImgName] forState:UIControlStateSelected];
    }
    //self.lineColor = [UIColor redColor];//密码不对时画线显示红色
    self.userInteractionEnabled = NO;
}

- (void)setDefaultSelectBtnStyle
{
    for (int i = 1; i <= self.subviews.count; i ++)
    {
        UIButton *btn = [self viewWithTag:i];
        btn.selected = NO;
        [btn setImage:[UIImage imageNamed:kCorrectImgName] forState:UIControlStateSelected];
    }
    self.lineColor = [UIColor colorWithHex:kLineColor];
    [self.selectBtnArray removeAllObjects];
    self.userInteractionEnabled = YES;
}

/**
 插入数据[NSUserDefault]
 */
+ (void)setUserDefault:(NSString *)value
                   key:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

/**
 获取数据[NSUserDefault]
 */
+ (NSString *)getUserDefault:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *result = [userDefaults objectForKey:key];
    if (!result)
    {
        result = @"";
    }
    return result;
}

#pragma mark - getter

- (NSMutableArray *)selectBtnArray
{
    if (!_selectBtnArray)
    {
        _selectBtnArray = [NSMutableArray array];
    }
    return _selectBtnArray;
}

- (CGFloat)btnWidth
{
    if (_btnWidth <= 0)
    {
        _btnWidth = kButtonWidth;
    }
    return _btnWidth;
}

- (NSInteger)minSelectedCount
{
    if (_minSelectedCount <= 0 || _minSelectedCount > 9)
    {
        _minSelectedCount = kMinSelectedCount;
    }
    return _minSelectedCount;
}

- (NSString *)normalImgStr
{
    if (!_normalImgStr)
    {
        _normalImgStr = kNormalImgName;
    }
    return _normalImgStr;
}

- (NSString *)correctImgStr
{
    if (!_correctImgStr)
    {
        _correctImgStr = kCorrectImgName;
    }
    return _correctImgStr;
}

- (NSString *)errorImgStr
{
    if (!_errorImgStr)
    {
        _errorImgStr = kErrorImgName;
    }
    return _errorImgStr;
}

- (UIColor *)lineColor
{
    if (!_lineColor)
    {
        _lineColor = [UIColor colorWithHex:kLineColor];
    }
    return _lineColor;
}

@end
