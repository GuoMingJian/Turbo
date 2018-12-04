//
//  FingerprintLoginViewController.m
//  LoginDemo
//
//  Created by 郭明健 on 2018/10/18.
//  Copyright © 2018年 GuoMingJian. All rights reserved.
//

#import "FingerprintLoginViewController.h"
#import "GesturesLoginViewController.h"
#import "PwdLoginViewController.h"
#import "TBTouchIDManager.h"
#import "TBTipView.h"
#import "Header.h"
//#import "MainViewController.h"

@interface FingerprintLoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;

@end

@implementation FingerprintLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidLayoutSubviews
{
    [self setupUI];
}

#pragma mark - setupUI

- (void)setupUI
{
    //毛玻璃
    [self clearAllSubViews:_bgImageView];
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];//UIBlurEffectStyleDark
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = _bgImageView.bounds;
    [_bgImageView addSubview:effectView];
    //
    _logoTopConstraint.constant = kHeight(69);
    _bottomViewBottomConstraint.constant = kHeight(10) + Height_Bottom;
}

- (void)clearAllSubViews:(UIView *)view
{
    for (UIView *subView in view.subviews)
    {
        [subView removeFromSuperview];
    }
}

#pragma mark - actions

//点击指纹按钮
- (IBAction)clickFingerAction:(id)sender {
    [self touchIDClick];
}

- (void)touchIDClick
{
    TBTouchIDManager *touchManager = [[TBTouchIDManager alloc] init];
    [touchManager setLocalizedFallbackTitle:@"输入密码"];
    NSError *error;
    //判断是否支持Touch ID
    if ([touchManager canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error])
    {
        kWeakSelf(self)
        //[TBTipView showTipView:@"设备支持Touch ID"];
        [touchManager evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"通过Home键验证已有手机指纹" reply:^(BOOL success, NSError * _Nullable error) {
            if (success)
            {//验证成功执行
                dispatch_async(dispatch_get_main_queue(), ^{
                    [TBTipView showTipView:@"指纹识别成功!"];
                    [weakself gotoMainVC];
                });
            }
            else
            {
                if (error.code == kLAErrorUserFallback)
                {
                    //忘记密码按钮被点击
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [TBTipView showTipView:@"您点击了忘记密码按钮!"];
                    });
                }
                else if (error.code == kLAErrorUserCancel)
                {
                    //取消按钮被点击
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [TBTipView showTipView:@"您点击了取消按钮!"];
                    });
                }
                else
                {
                    //指纹识别失败
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [TBTipView showTipView:@"指纹识别失败!"];
                    });
                }
            }
        }];
    }
    else
    {
        NSString *msg = [NSString stringWithFormat:@"设备不支持Touch ID:%@", error];
        [TBTipView showTipView:msg];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备不支持Touch ID" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)gotoMainVC
{
//    MainViewController *mainVC = [[MainViewController alloc] init];
//    [self presentViewController:mainVC animated:YES completion:nil];
}

//账号密码登录
- (IBAction)pwdLoginAction:(id)sender {
    PwdLoginViewController *pwdVC = [[PwdLoginViewController alloc] init];
    pwdVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:pwdVC animated:YES completion:nil];
}

//手势密码登录
- (IBAction)gesturesLoginAction:(id)sender {
    GesturesLoginViewController *gestureVC = [[GesturesLoginViewController alloc] init];
    gestureVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:gestureVC animated:YES completion:nil];
}

@end
