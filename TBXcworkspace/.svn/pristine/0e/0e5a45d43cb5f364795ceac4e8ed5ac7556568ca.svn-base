//
//  GesturesLoginViewController.m
//  LoginDemo
//
//  Created by 郭明健 on 2018/10/18.
//  Copyright © 2018年 GuoMingJian. All rights reserved.
//

#import "GesturesLoginViewController.h"
#import "PwdLoginViewController.h"
#import "FingerprintLoginViewController.h"
#import "Header.h"
#import "TBGesturePasswordView.h"
#import "TBTipView.h"
//#import "MainViewController.h"

@interface GesturesLoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *stateContainerView;//手势状态容器
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stateViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stateViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *gesturesContainerView;//放置手势密码的容器
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gesturesTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;
//
@property (strong, nonatomic) TBGesturePasswordView *topGPView;
@property (strong, nonatomic) TBGesturePasswordView *gpView;

@end

@implementation GesturesLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
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
    _stateViewTopConstraint.constant = kHeight(65);
    _gesturesTopConstraint.constant = kHeight(12);
    _bottomViewBottomConstraint.constant = kHeight(10) + Height_Bottom;
    _stateViewWidthConstraint.constant = kWidth(45);
    if (kiPhone4)
    {
        _logoTopConstraint.constant = 50;
        _stateViewTopConstraint.constant = 25;
        _gesturesTopConstraint.constant = 12;
    }
    //
    [self initGesturesView];
}

- (void)clearAllSubViews:(UIView *)view
{
    for (UIView *subView in view.subviews)
    {
        [subView removeFromSuperview];
    }
}

- (void)initGesturesView
{
    [self clearAllSubViews:self.stateContainerView];
    _topGPView = [[TBGesturePasswordView alloc] initWithFrame:self.stateContainerView.bounds];
    _topGPView.backgroundColor = [UIColor clearColor];
    _topGPView.type = TBUnTouch;
    //NSLog(@"%@", NSStringFromCGRect(_stateContainerView.frame));
    _topGPView.btnWidth = kWidth(10);
    _topGPView.normalImgStr = @"gs_node";
    _topGPView.correctImgStr = @"gs_correct";
    [_topGPView setupUI];
    [self.stateContainerView addSubview:_topGPView];
    //
    [self clearAllSubViews:self.gesturesContainerView];
    CGRect frame = self.gesturesContainerView.frame;
    CGSize containerSize = self.gesturesContainerView.frame.size;
    CGFloat width = (containerSize.width > containerSize.height) ? containerSize.height : containerSize.width;
    CGFloat bWidth = kWidth(58);
    _gpView = [[TBGesturePasswordView alloc] initWithFrame:CGRectMake((frame.size.width - width)/2, 0, width, width)];
    _gpView.backgroundColor = [UIColor clearColor];
    _gpView.btnWidth = bWidth;
    _gpView.type = TBCheckPassword;
    _gpView.maxInputErrorCount = 5;//当错误次数过多导致禁用时，切换到指纹登录再回来又可以手势登录。
    [_gpView setupUI];
    //_gpView.backgroundColor = [UIColor orangeColor];
    [self.gesturesContainerView addSubview:_gpView];
    //
    kWeakSelf(self)
    //手势密码输入错误
    [_gpView setInputPwdError:^(NSInteger chanceCount, NSArray *pwdArray) {
        [weakself.topGPView updateUIWithBtnArr:pwdArray isSelected:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself.topGPView updateUIWithBtnArr:pwdArray isSelected:NO];
        });
        if (chanceCount > 0)
        {
            NSString *msg = [NSString stringWithFormat:@"密码输入错误，您还可以输入%ld次", (long)chanceCount];
            [TBTipView showTipView:msg];
        }
        else
        {
            [TBTipView showTipView:@"输错次数太多，手势密码登录已被禁止。"];
        }
    }];
    //手势密码输入正确
    [_gpView setInputSecondSuccess:^(NSArray *pwdArray, NSString *pwd) {
//        MainViewController *mainVC = [[MainViewController alloc] init];
//        [weakself presentViewController:mainVC animated:YES completion:nil];
    }];
}

#pragma mark - actions

//账号密码登录
- (IBAction)pwdLoginAction:(id)sender {
    PwdLoginViewController *pwdVC = [[PwdLoginViewController alloc] init];
    pwdVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:pwdVC animated:YES completion:nil];
}

//指纹登录
- (IBAction)fingerprintLoginAction:(id)sender {
    FingerprintLoginViewController *fingerVC = [[FingerprintLoginViewController alloc] init];
    fingerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:fingerVC animated:YES completion:nil];
}

@end
