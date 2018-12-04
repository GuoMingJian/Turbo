//
//  TBSafeTextField.h
//  TBBusiness
//
//  Created by Apple on 2018/5/31.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBSafeKeyboard.h"
@class TBSafeTextField;

@protocol SafeTextFieldDelegate <NSObject>
// 点击完成 键盘消失
-(void)safeTextFieldDidResignFirstResponder:(TBSafeTextField *)textField;
// 删除字符 inputView需要知道，并传递给web
-(void)safeTextFieldDidDeleteString:(TBSafeTextField *)textField;
// 回调明文
-(void)plainText:(NSString *)plainStr safeTextField:(TBSafeTextField *)textField;
@end

@interface TBSafeTextField : UITextField

@property (nonatomic, assign) SafeKeyboardType KBType;
@property (nonatomic, weak) id<SafeTextFieldDelegate> safeTextDelegate;
// 是否隐藏浮标
@property (nonatomic, assign) BOOL isHideBuoy;

- (instancetype)initWithkeyboardType:(SafeKeyboardType)type;
@end
