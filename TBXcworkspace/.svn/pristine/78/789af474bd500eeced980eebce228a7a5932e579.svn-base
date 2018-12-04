//
//  SetGesturesViewController.m
//  LoginDemo
//
//  Created by 郭明健 on 2018/10/19.
//  Copyright © 2018年 GuoMingJian. All rights reserved.
//

#import "SetGesturesViewController.h"
#import "GesturesLoginViewController.h"
#import "Header.h"
#import "TBGesturePasswordView.h"
#import "TBTipView.h"
//#import "MainViewController.h"

@interface SetGesturesViewController ()

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

@implementation SetGesturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createLeftItemWithImg:@"close"];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self resetPwd];
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
    _gpView.type = TBSetPassword;
    _gpView.maxInputErrorCount = 5;
    [_gpView setupUI];
    [self.gesturesContainerView addSubview:_gpView];
    //
    kWeakSelf(self)
    //
    [_gpView setInputLengthError:^(NSInteger minCount) {
        NSString *msg = [NSString stringWithFormat:@"至少连接%ld个点，请重新输入", (long)minCount];
        [TBTipView showTipView:msg];
    }];
    //
    [_gpView setInputFirstSuccess:^(NSArray *pwdArray, NSString *pwd) {
        NSString *msg = [NSString stringWithFormat:@"请再次绘制解锁图案"];
        [TBTipView showTipView:msg];
        [weakself.topGPView updateUIWithBtnArr:pwdArray isSelected:YES];
    }];
    //
    [_gpView setInputSecondFailure:^{
        NSString *msg = [NSString stringWithFormat:@"与上一次绘制不一致，请重新绘制"];
        [TBTipView showTipView:msg];
    }];
    //
    [_gpView setInputSecondSuccess:^(NSArray *pwdArray, NSString *pwd) {
        [weakself.topGPView updateUIWithBtnArr:pwdArray isSelected:YES];
        [TBTipView showTipView:@"密码设置成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself gotoMainVC];
        });
    }];
}

- (void)gotoMainVC
{
    //    MainViewController *mainVC = [[MainViewController alloc] init];
    //    [self presentViewController:mainVC animated:YES completion:nil];
//    GesturesLoginViewController *gestureVC = [[GesturesLoginViewController alloc] init];
//    [self presentViewController:gestureVC animated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - actions

//重置手势密码
- (IBAction)resetPwdAction:(id)sender {
    [self resetPwd];
}

- (void)resetPwd
{
    NSString *firstPwdStr = [TBGesturePasswordView getFirstPassword];
    if (firstPwdStr.length == 0)
    {
        return;
    }
    [self.topGPView updateUIWithBtnArr:nil isSelected:YES];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kFirstPasswordKey];
}

@end
