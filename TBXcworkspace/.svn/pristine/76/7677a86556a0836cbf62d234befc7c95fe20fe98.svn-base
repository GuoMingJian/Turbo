//
//  TBSafeTextField.m
//  TBBusiness
//
//  Created by Apple on 2018/5/31.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TBSafeTextField.h"

@interface TBSafeTextField ()<UITextFieldDelegate>
@property (nonatomic, strong) NSMutableString *plainStr;
@end

@implementation TBSafeTextField

-(NSMutableString *)plainStr {
    if (!_plainStr) {
        _plainStr = [NSMutableString string];
    }
    return _plainStr;
}

- (instancetype)initWithkeyboardType:(SafeKeyboardType)type
{
    self = [super init];
    if (self) {
        self.KBType = type;
        self.delegate = self;
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
    }
    return self;
}

// 成为第一响应者
- (BOOL)becomeFirstResponder
{
    BOOL bflag = [super becomeFirstResponder];
    if(bflag)
    {
        TBSafeKeyboard *kb = (TBSafeKeyboard *)self.inputView;
        kb.inputSource = self;
        kb.isHideBuoy = self.isHideBuoy;
        [kb setRandomNumberText];
    }
    return bflag;
}

- (BOOL)resignFirstResponder
{
    TBSafeKeyboard *kb = (TBSafeKeyboard *)self.inputView;
    kb.inputSource = nil;
    BOOL ret = [super resignFirstResponder];
    if (self.safeTextDelegate && [self.safeTextDelegate respondsToSelector:@selector(safeTextFieldDidResignFirstResponder:)])
    {
        [self.safeTextDelegate safeTextFieldDidResignFirstResponder:self];
    }
    return ret;
}

-(void)deleteBackward
{
    [super deleteBackward];
    if (self.safeTextDelegate && [self.safeTextDelegate respondsToSelector:@selector(safeTextFieldDidDeleteString:)])
    {
        [self.safeTextDelegate safeTextFieldDidDeleteString:self];
        
        if (self.plainStr.length >= 1) {
            [self.plainStr deleteCharactersInRange:NSMakeRange(self.plainStr.length - 1, 1)];
        }
        
        // 回调明文
        [self callBackPlainText];
    }
}

#pragma mark - setter
-(void)setKBType:(SafeKeyboardType)KBType
{
    _KBType = KBType;
    TBSafeKeyboard *keyboard = [TBSafeKeyboard keyboardWithType:KBType];
    self.inputView = keyboard;
    keyboard.inputSource = self;
}

#pragma mark - 禁止复制、选择、粘贴
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if(menuController) {
        menuController.menuVisible=NO;
    }
    
    return NO;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 密文替代
    [self insertText:@"*"];
    
    // 回调明文
    [self.plainStr appendString:string];
    [self callBackPlainText];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    // 回调明文
    self.plainStr = nil;
    [self callBackPlainText];
    return YES;
}

#pragma mark - 明文回调
-(void)callBackPlainText {
    if (self.safeTextDelegate && [self.safeTextDelegate respondsToSelector:@selector(plainText: safeTextField:)]) {
        [self.safeTextDelegate plainText:self.plainStr safeTextField:self];
    }
}

@end
