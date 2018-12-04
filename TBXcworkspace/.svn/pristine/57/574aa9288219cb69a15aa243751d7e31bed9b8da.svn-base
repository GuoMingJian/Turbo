//
//  SafeKeyboard.h
//  TBBusiness
//
//  Created by Apple on 2018/5/31.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
// 键盘高度
#define KEYBOARDHEIGHT 216

typedef NS_ENUM(NSInteger,SafeKeyboardType){
    SafeKeyboardTypeNum         = 1 << 0,
    SafeKeyboardTypeNumDecimal  = 1 << 1,
    SafeKeyboardTypeABC         = 1 << 2
};

@interface TBSafeKeyboard : UIView

/**
 *  title
 */
@property (nonatomic,copy) NSString *enterprise;

/*!
 *  @brief such as UITextField,UITextView,UISearchBar
 */
@property (nonatomic,strong) UIView *inputSource;

/**
 *  是否隐藏浮标
 */
@property (nonatomic, assign) BOOL isHideBuoy;

+ (instancetype)keyboardWithType:(SafeKeyboardType)type;

// 设置键盘文字
- (void)setRandomNumberText;

//+ (SafeKeyboard *)shareKeyboardViewWithType:(KeyboardType)type;
@end
