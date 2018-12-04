//
//  SafeKBInputView.m
//  TBBusiness
//
//  Created by Apple on 2018/5/31.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TBSafeKBInputView.h"

static TBSafeKBInputView* keyboardViewTypeNumInstance = nil;
static TBSafeKBInputView* keyboardViewTypeNumDecimalInstance = nil;
static TBSafeKBInputView* keyboardViewTypeABCInstance = nil;

@implementation TBSafeKBInputView

+(TBSafeKBInputView *)shareKBInputViewWithTypeNum
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        keyboardViewTypeNumInstance = [[TBSafeKBInputView alloc] initWithSafeKeyboardType:SafeKeyboardTypeNum];
    });
    return keyboardViewTypeNumInstance;
}
+(TBSafeKBInputView *)shareKBInputViewWithTypeNumDecimal
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        keyboardViewTypeNumDecimalInstance = [[TBSafeKBInputView alloc] initWithSafeKeyboardType:SafeKeyboardTypeNumDecimal];
    });
    return keyboardViewTypeNumDecimalInstance;
}
+(TBSafeKBInputView *)shareKBInputViewWithTypeABC
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        keyboardViewTypeABCInstance = [[TBSafeKBInputView alloc] initWithSafeKeyboardType:SafeKeyboardTypeABC];
    });
    return keyboardViewTypeABCInstance;
}

- (instancetype)initWithSafeKeyboardType:(SafeKeyboardType)type
{
    self = [super init];
    if (self) {
        self.textField = [[TBSafeTextField alloc] init];
        self.textField.KBType = type;
        self.textField.delegate = self;
        self.textField.safeTextDelegate = self;
        self.trueText = @"";
        self.keyboardHeght = KEYBOARDHEIGHT;
        [self addSubview:self.textField];
    }
    return self;
}

- (void)show
{
    UIViewController *topVC = [self getCurrentVC];
    [topVC.view addSubview:self];
    [self.textField becomeFirstResponder];
    self.textField.text = @"";
    self.trueText = @"";
    self.placeholderText = [NSMutableString string];
}

#pragma mark - delegate

// textfield 取消第一响应者 ，view消失
- (void)safeTextFieldDidResignFirstResponder:(TBSafeTextField *)textField
{
    [self removeFromSuperview];
}

// 删除
- (void)safeTextFieldDidDeleteString:(TBSafeTextField *)textField
{
    _placeholderText  = [NSMutableString string];
    NSInteger len = textField.text.length;
    for (int i = 0; i < len; i++)
    {
        [self.placeholderText appendString:@"*"];
    }
    self.trueText = textField.text;
    
    if (self.InputViewDelegate && [self.InputViewDelegate respondsToSelector:@selector(safeKBInputView:DidChangeText:placeholderText:TextField:)])
    {
        [self.InputViewDelegate safeKBInputView:self DidChangeText:self.trueText placeholderText:self.placeholderText TextField:self.textField];
    }
}

// 回调明文
-(void)plainText:(NSString *)plainStr safeTextField:(TBSafeTextField *)textField {
    
}


// 增加
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _placeholderText  = [NSMutableString string];
    NSInteger len = textField.text.length + 1;
    for (int i = 0; i < len; i++)
    {
        [self.placeholderText appendString:@"*"];
    }
    self.trueText = [self.trueText stringByAppendingString:string];
    
    
    if (self.InputViewDelegate && [self.InputViewDelegate respondsToSelector:@selector(safeKBInputView:DidChangeText:placeholderText:TextField:)])
    {
        [self.InputViewDelegate safeKBInputView:self DidChangeText:self.trueText placeholderText:self.placeholderText TextField:self.textField];
    }
    return YES;
}

#pragma mark - getter setter

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}


@end

