//
//  SafeKBInputView.h
//  TBBusiness
//
//  Created by Apple on 2018/5/31.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBSafeTextField.h"
@class TBSafeKBInputView;

// 点击的代理事件 传递到外层
@protocol SafeKBInputViewDelegate <NSObject>
// 每次输入的代理事件
-(void)safeKBInputView:(TBSafeKBInputView *)inputView DidChangeText:(NSString *)text placeholderText:(NSString *)placeholder TextField:(TBSafeTextField *)textField;


@end

@interface TBSafeKBInputView : UIView<SafeTextFieldDelegate,UITextFieldDelegate>

@property (nonatomic, strong) TBSafeTextField *textField;
@property (nonatomic, copy) NSMutableString *placeholderText;
@property (nonatomic, copy) NSString *trueText;
@property (nonatomic, assign) CGFloat keyboardHeght;

@property (nonatomic, weak) id<SafeKBInputViewDelegate> InputViewDelegate;

+(TBSafeKBInputView *)shareKBInputViewWithTypeNum;
+(TBSafeKBInputView *)shareKBInputViewWithTypeNumDecimal;
+(TBSafeKBInputView *)shareKBInputViewWithTypeABC;
- (instancetype)initWithSafeKeyboardType:(SafeKeyboardType)type;
// 显示
-(void)show;

@end
