//
//  TBViewControllerBase.m
//  TBBusiness
//
//  Created by Apple on 2018/1/25.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TBViewControllerBase.h"
#import "TBViewControllerManager.h"
#import "TBActivityView.h"

@interface TBViewControllerBase ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) TBActivityView *activityView;
@end

@implementation TBViewControllerBase
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置状态栏文字为白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    /**
     *  为了右划返回上一页的操作体验良好，开启导航栏半透明属性；
     *  因此，视图控制器view的布局从导航控制器的MaxY开始;
     **/
    self.navigationController.navigationBar.translucent = YES;
    
    /**
     *  针对设置了webView全屏却无法覆盖到状态栏做的处理
     */
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    /**
     *  设置默认的导航控制器背景视图
     */
    [self setNavigationBarBackgroundImageWithClearImg];
    
    /**
     *  设置左侧返回手势
     */
    [self setPopGestureRecognizer];
}

#pragma mark - 隐藏导航控制器底部的灰色线条
-(void)hideNavigationBarShadowLine:(BOOL)isHidden {
    if (isHidden) {
        self.navigationController.navigationBar.shadowImage = [UIImage new];
    } else {
        self.navigationController.navigationBar.shadowImage = nil;
    }
}

#pragma mark - 设置左侧返回手势
- (void)setPopGestureRecognizer {
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark - 设置默认的导航控制器背景视图
-(void)setNavigationBarBackgroundImageWithClearImg {
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
}

- (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - 创建导航控制器左返回按钮
- (void)createLeftItemWithImg:(NSString *)imgName {
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if (imgName && imgName.length > 0) {
        [leftBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    } else {
        [leftBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    }
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

#pragma mark - 导航控制器左上角返回按钮动作
- (void)leftBtnClick:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 设置状态栏的背景颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

#pragma mark - 创建waiting图
-(void)createWaitingView {
    if (!self.activityView) {
        self.activityView = [[TBActivityView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.activityView.center = self.view.center;
        [self.view addSubview:self.activityView];
    }
}

#pragma mark - 销毁waiting图
-(void)removeWaitingView {
    if (self.activityView) {
        [self.activityView removeFromSuperview];
        self.activityView = nil;
    }
}

#pragma mark - 设置导航栏标题颜色
-(void)setNavigationItemTitleColor:(UIColor *)color {
    if (color && [color isKindOfClass:[UIColor class]]) {
      self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:color};
    }
    
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
