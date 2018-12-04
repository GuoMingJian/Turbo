//
//  RegisterViewController.m
//  TBBusiness
//
//  Created by Apple on 2018/10/24.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "RegisterViewController.h"
#import "SetPwdViewController.h"
#import "TBCountDownButton.h"
#import "Header.h"

@interface RegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeNumTextField;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *selectBtnImgView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet TBCountDownButton *countdownBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"快速注册";
    [self createLeftItemWithImg:nil];
    [self hideNavigationBarShadowLine:YES];
    
    self.selectBtn.selected = YES;
    
    self.nextBtn.enabled = NO;
    self.phoneNumTextField.delegate = self;
    self.codeNumTextField.delegate = self;
    
    [self.phoneNumTextField addTarget:self action:@selector(phoneNumTextFieldChanged:) forControlEvents:(UIControlEventEditingChanged)];
    [self.codeNumTextField addTarget:self action:@selector(codeNumTextFieldChanged:) forControlEvents:(UIControlEventEditingChanged)];
    if (MAIN_SCREEN_WIDTH <= 320) {
        // 小屏手机
        [self.codeNumTextField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    }

    self.topConstraint.constant = Height_NavBar + 10;
}

#pragma mark -
-(void)phoneNumTextFieldChanged:(UITextField *)phoneTextField {
    [self checkBtnCanClick];
}
-(void)codeNumTextFieldChanged:(UITextField *)codeNumTextField {
    [self checkBtnCanClick];
}

#pragma mark -
- (IBAction)selectBtnClick:(UIButton *)sender {
    self.selectBtn.selected = !self.selectBtn.selected;
    if (self.selectBtn.selected) {
        self.selectBtnImgView.image = [UIImage imageNamed:@"check"];
    } else {
        self.selectBtnImgView.image = [UIImage imageNamed:@"unCheck"];
    }
    [self checkBtnCanClick];
}

#pragma mark -
- (IBAction)nextBtnClick:(UIButton *)sender {
    SetPwdViewController *pwdVC = [[SetPwdViewController alloc] init];
    [self.navigationController pushViewController:pwdVC animated:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.phoneNumTextField) {
        if (self.phoneNumTextField.text.length >= 11) {
            return NO;
        }
    } else if (textField == self.codeNumTextField) {
        if (self.codeNumTextField.text.length >= 6) {
            return NO;
        }
    }
    
    
    return YES;
}

#pragma mark -
- (void)checkBtnCanClick {
    if (self.phoneNumTextField.text.length == 0 ||
        self.codeNumTextField.text.length == 0 ||
        !self.selectBtn.selected) {
        [self setNextBtnEnabled:NO];
    } else {
        [self setNextBtnEnabled:YES];
    }
}

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
- (IBAction)countBtnClick:(TBCountDownButton *)sender {
    sender.enabled = NO;
    [sender startWithSecond:59];
    [sender didChange:^NSString *(TBCountDownButton *countDownButton,int second) {
        NSString *title = [NSString stringWithFormat:@"%ds重新发送",second];
        return title;
    }];
    [sender didFinished:^NSString *(TBCountDownButton *countDownButton, int second) {
        countDownButton.enabled = YES;
        return @"获取验证码";
    }];
}

@end
