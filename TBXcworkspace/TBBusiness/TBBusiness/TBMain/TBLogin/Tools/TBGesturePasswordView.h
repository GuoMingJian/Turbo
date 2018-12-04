//
//  TBGesturePasswordView.h
//  ZXToolProjects
//
//  Created by 郭明健 on 2018/6/26.
//  Copyright © 2018年 GuoMingJian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+MJExt.h"

#define kSavedPasswordKey @"kSavedPasswordKey"      //已保存的密码
#define kFirstPasswordKey @"kFirstPasswordKey"      //上一次设置成功的密码
#define kTimeInterval 1.0               //默认密码错误时UI状态改变，动画时间
#define kButtonWidth 60                 //默认按钮宽度
#define kMinSelectedCount 4             //默认密码长度至少选中4个
#define kNormalImgName @"gs_node"       //默认按钮图片
#define kCorrectImgName @"gs_correct"   //默认选中图片
#define kErrorImgName @"gs_correct"     //默认错误图片
#define kLineColor @"#929AA0"           //默认轨迹画线颜色

//业务类型
typedef NS_ENUM (NSInteger, TBBusinessType)
{
    TBSetPassword = 0,  //设置手势密码类型
    TBCheckPassword,    //验证手势密码类型
    TBUnTouch,          //展示选中密码类型，不能触摸画轨迹。
};

@interface TBGesturePasswordView : UIView

@property (nonatomic, assign) TBBusinessType type;      //业务类型
@property (nonatomic, assign) CGFloat   btnWidth;
@property (nonatomic, assign) CGFloat   btnSpac;
@property (nonatomic,   copy) NSString  *normalImgStr;
@property (nonatomic,   copy) NSString  *correctImgStr;
@property (nonatomic,   copy) NSString  *errorImgStr;
@property (nonatomic, strong) UIColor   *lineColor;
@property (nonatomic, assign) NSInteger minSelectedCount;       //默认设置密码长度  >=4
@property (nonatomic, assign) NSInteger maxInputErrorCount;     //默认输入错误次数  =5

//Block
//密码个数不对（过于简单）
typedef void(^InputLengthError)(NSInteger minCount);
//第一次密码正确（已保存第一次密码）
typedef void(^InputFirstSuccess)(NSArray *pwdArray, NSString *pwd);
//第二次密码错误
typedef void(^InputSecondFailure)(void);
//第二次密码正确
typedef void(^InputSecondSuccess)(NSArray *pwdArray, NSString *pwd);
//密码错误，剩下可输入次数
typedef void(^InputPwdError)(NSInteger chanceCount, NSArray *pwdArray);

@property (nonatomic, copy) InputLengthError    inputLengthError;
@property (nonatomic, copy) InputFirstSuccess   inputFirstSuccess;
@property (nonatomic, copy) InputSecondFailure  inputSecondFailure;
@property (nonatomic, copy) InputSecondSuccess  inputSecondSuccess;
@property (nonatomic, copy) InputPwdError       inputPwdError;

#pragma mark - 外部调用API

/**
 展示手势密码UI
 */
- (void)setupUI;

/**
 根据字符串数组和参数state，设置按钮选中或取消选中状态
 
 @param array 字符串数组
 @param state yes:选中状态，no:normal状态
 */
- (void)updateUIWithBtnArr:(NSArray *)array isSelected:(BOOL)state;

//获取本地保存的手势密码
+ (NSString *)getPassword;
+ (void)setPassword:(NSString *)pwd;

//获取第一次设置的手势密码（两次密码相同才能设置成功）
+ (NSString *)getFirstPassword;
+ (void)setFirstPassword:(NSString *)pwd;

@end
