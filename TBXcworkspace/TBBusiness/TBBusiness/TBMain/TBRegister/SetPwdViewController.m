//
//  SetPwdViewController.m
//  TBBusiness
//
//  Created by Apple on 2018/10/24.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "SetPwdViewController.h"
#import "AddCardViewController.h"
#import "TBSafeTextField.h"
#import "Header.h"

@interface SetPwdViewController ()<SafeTextFieldDelegate>
@property (nonatomic, copy) NSString *firstPwd;
@property (nonatomic, copy) NSString *secondPwd;
@property (weak, nonatomic) IBOutlet TBSafeTextField *firstPwdTextField;
@property (weak, nonatomic) IBOutlet TBSafeTextField *secondPwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIView *warningView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation SetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"密码设置";
    [self createLeftItemWithImg:nil];
    [self hideNavigationBarShadowLine:YES];
    
    self.warningView.hidden = YES;
    self.nextBtn.enabled = NO;
    self.firstPwdTextField.safeTextDelegate = self;
    [self.firstPwdTextField setKBType:(SafeKeyboardTypeABC)];
    
    self.secondPwdTextField.safeTextDelegate = self;
    [self.secondPwdTextField setKBType:(SafeKeyboardTypeABC)];
    
    [self.firstPwdTextField addTarget:self action:@selector(firstPwdTextFieldChanged:) forControlEvents:(UIControlEventEditingChanged)];
    [self.secondPwdTextField addTarget:self action:@selector(secondPwdTextFieldChanged:) forControlEvents:(UIControlEventEditingChanged)];
    
    self.topConstraint.constant = Height_NavBar + 10;
}

#pragma mark -
-(void)firstPwdTextFieldChanged:(TBSafeTextField *)firstPwdTextField {
    [self checkBtnCanClick];
}

-(void)secondPwdTextFieldChanged:(TBSafeTextField *)secondPwdTextField {
    [self checkBtnCanClick];
}

#pragma mark -
-(void)setNextBtnEnabled:(BOOL)enabled {
    if (enabled) {
        self.nextBtn.enabled = YES;
        [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
        
    } else {
        self.nextBtn.enabled = NO;
        [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"unSelectBtn"] forState:UIControlStateNormal];
    }
}

#pragma mark -
// 点击完成 键盘消失
-(void)safeTextFieldDidResignFirstResponder:(TBSafeTextField *)textField {
    
}
// 删除字符 inputView需要知道，并传递给web
-(void)safeTextFieldDidDeleteString:(TBSafeTextField *)textField {
    
}

// 回调明文
-(void)plainText:(NSString *)plainStr safeTextField:(TBSafeTextField *)textField {
    if (textField == self.firstPwdTextField) {
        self.firstPwd = plainStr;
    } else if (textField == self.secondPwdTextField) {
        self.secondPwd = plainStr;
    }
}

#pragma mark -
- (void)checkBtnCanClick {
    self.warningView.hidden = YES;
    if (self.firstPwdTextField.text.length == 0 ||
        self.secondPwdTextField.text.length == 0) {
        [self setNextBtnEnabled:NO];
    } else {
        [self setNextBtnEnabled:YES];
    }
}

- (IBAction)nextBtnClick:(UIButton *)sender {
    NSLog(@"1 == %@",self.firstPwd);
    NSLog(@"2 == %@",self.secondPwd);
    // 密码不一致，弹出警告
    if (![self.firstPwd isEqualToString:self.secondPwd]) {
        self.warningView.hidden = NO;
        [self setNextBtnEnabled:NO];
        return;
    }
    AddCardViewController *addCardVC = [[AddCardViewController alloc] init];
    [self.navigationController pushViewController:addCardVC animated:YES];
}




@end
