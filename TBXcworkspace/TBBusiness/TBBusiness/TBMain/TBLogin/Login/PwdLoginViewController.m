//
//  PwdLoginViewController.m
//  LoginDemo
//
//  Created by 郭明健 on 2018/10/17.
//  Copyright © 2018年 GuoMingJian. All rights reserved.
//

#import "PwdLoginViewController.h"
#import "Header.h"
#import "SetGesturesViewController.h"
#import "TBSafeTextField.h"
#import "RegisterViewController.h"
//#import "UIView+TBKeyboardOffset.h"
#import "TBAuthentication.h"
#import "TBTipView.h"
#import "TestViewController.h"//测试卡顿

//#import "MainViewController.h"

@interface PwdLoginViewController ()<UITextFieldDelegate,SafeTextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTopConstraint;//顶部间距
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet TBSafeTextField *pwdTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewBottomConstraint;//底部间距
@property (weak, nonatomic) IBOutlet UIImageView *errorImageView;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwdTipLabel;
//
@property (strong, nonatomic) UITextField *currentTextField;
// 指纹登录/面容ID登录
@property (weak, nonatomic) IBOutlet UIButton *recognizeBtn;

@end

@implementation PwdLoginViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.view openKeyboardOffsetView];
//    self.view.keyboardGap = 25;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createLeftItemWithImg:@"close"];
    [self hideNavigationBarShadowLine:YES];
    [self setupUI];
}

#pragma mark - setupUI

- (void)setupUI
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    //
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
    //
    _logoTopConstraint.constant = kHeight(88);
    _loginViewBottomConstraint.constant = kHeight(23) + Height_Bottom;
    
    if (STATUS_BAR_HEIGHT == 44) {
        // iPhoneX系列，指纹登录改为面容识别
        [self.recognizeBtn setTitle:@"面容识别" forState:UIControlStateNormal];
    }
    
    [self.pwdTextField setKBType:SafeKeyboardTypeABC];
    self.pwdTextField.safeTextDelegate = self;
}

//- (void)keyboardWillShow:(NSNotification *)notification
//{
//    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    //
//    CGFloat tf_Y = _loginView.frame.origin.y + _currentTextField.frame.origin.y + _currentTextField.frame.size.height;
//    if (tf_Y + keyboardFrame.size.height > self.view.frame.size.height)
//    {
//        CGFloat y = tf_Y + keyboardFrame.size.height - self.view.frame.size.height + 60;
//        [UIView animateWithDuration:duration animations:^{
//            CGRect rect = self.view.frame;
//            CGRect frame = CGRectMake(rect.origin.x, -y, rect.size.width, rect.size.height);
//            self.view.frame = frame;
//        }];
//    }
//    else
//    {
//        if (self.view.frame.origin.y != 0)
//        {
//            [self keyboardWillHide];
//        }
//    }
//}

- (void)keyboardWillHide
{
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.view.frame = frame;
    }];
}

- (void)tapAction
{
    [self.view endEditing:YES];
    [self keyboardWillHide];
}

//显示输入错误
- (void)showErrorIcon:(NSString *)text
{
    _errorImageView.hidden = NO;
    _errorLabel.hidden = NO;
    _errorLabel.text = text;
}

//隐藏输入
- (void)hideErrorIcon
{
    _errorImageView.hidden = YES;
    _errorLabel.hidden = YES;
    _errorLabel.text = @"";
}

#pragma mark - actions

//忘记密码
- (IBAction)forgetPwdAction:(id)sender {
    
}

//登录
- (IBAction)loginAction:(id)sender {
    if ([_phoneTextField.text isEqualToString:@"15899670225"] && ![_pwdTextField.text isEqualToString:@"123456"])
    {
        [self showErrorIcon:@"密码输入有误"];
    }
    
    //
    if ([_phoneTextField.text isEqualToString:@"15899670225"] && [_pwdTextField.text isEqualToString:@"123456"])
    {
//        MainViewController *mainVC = [[MainViewController alloc] init];
//        [self presentViewController:mainVC animated:YES completion:nil];
    }
}

#pragma mark - 快速注册
- (IBAction)registerAction:(id)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark - 手势登录
- (IBAction)gestureLoginClick:(UIButton *)sender {
    SetGesturesViewController *gestureVC = [[SetGesturesViewController alloc] init];
    [self.navigationController pushViewController:gestureVC animated:YES];
}

#pragma mark - 指纹识别登录/面容识别登录
- (IBAction)authenticationLoginClick:(UIButton *)sender {
    [TBAuthentication startRecognizeWithDescription:@"" callBack:^(NSInteger status, NSError * _Nonnull error) {
        if (status == TBAuthenticationSuccess) {
            [TBTipView showTipView:@"认证成功" duration:2];
        } else if (status == TBAuthenticationFailed) {
            [TBTipView showTipView:@"认证失败" duration:2];
        } else if (status == TBErrorBiometryLockout) {
            [TBTipView showTipView:@"FaceID认证超出次数" duration:2];
        } else if (status == TBErrorTouchIDLockout) {
            [TBTipView showTipView:@"TouchID认证超出次数" duration:2];
        }  else if (status == TBAuthenticationNotValid) {
            [TBTipView showTipView:@"无法使用ID认证" duration:2];
        }
        
    }];
}

#pragma mark - E账户开户
- (IBAction)accountAction:(id)sender {
    //测试卡顿
    TestViewController *testVC = [[TestViewController alloc] init];
    [self presentViewController:testVC animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _currentTextField = textField;
    if (textField == self.phoneTextField && self.view.frame.origin.y != 0)
    {
        [self keyboardWillHide];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.phoneTextField)
    {//手机号码
        if (textField.text.length > 0)
        {
            NSString *firstNum = [textField.text substringToIndex:1];
            if (textField.text.length < 11 || ![firstNum isEqualToString:@"1"])
            {
                [self showErrorIcon:@"手机号码输入有误"];
            }
            else if (textField.text.length == 11)
            {
                if ([_errorLabel.text containsString:@"手机"])
                {
                    [self hideErrorIcon];
                }
            }
        }
        else
        {
            [self showErrorIcon:@"请输入手机号码"];
            _phoneTipLabel.hidden = YES;
        }
    }
//    else if (textField == self.pwdTextField)
//    {//密码
//        if (textField.text.length > 0)
//        {}
//        else
//        {
//            [self showErrorIcon:@"请输入密码"];
//            _pwdTipLabel.hidden = YES;
//        }
//    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.phoneTextField)
    {
        if (range.length == 1 && string.length == 0)
        {
            return YES;
        }
        else if (self.phoneTextField.text.length >= 11)
        {
            self.phoneTextField.text = [textField.text substringToIndex:11];
            return NO;
        }
        //
        _phoneTipLabel.hidden = textField.text.length >= 0 ? NO : YES;
    }
//    else if (textField == self.pwdTextField)
//    {
//        //
//        _pwdTipLabel.hidden = textField.text.length >= 0 ? NO : YES;
//    }
    return YES;
}

// 点击完成 键盘消失
-(void)safeTextFieldDidResignFirstResponder:(TBSafeTextField *)textField {
    NSLog(@"点击完成");
}
// 删除字符 inputView需要知道，并传递给web
-(void)safeTextFieldDidDeleteString:(TBSafeTextField *)textField {
    NSLog(@"删除字符");
}
// 明文回调
-(void)plainText:(NSString *)plainStr safeTextField:(TBSafeTextField *)textField {
    NSLog(@"明文回调 == 【%@】",plainStr);
}
@end
