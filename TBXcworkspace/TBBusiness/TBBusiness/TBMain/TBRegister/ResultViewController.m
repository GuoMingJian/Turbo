//
//  ResultViewController.m
//  TBBusiness
//
//  Created by Apple on 2018/10/24.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ResultViewController.h"
#import "Header.h"

@interface ResultViewController ()
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopConstraint;

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"添加结果";
    [self createLeftItemWithImg:nil];
    [self hideNavigationBarShadowLine:YES];
    
    self.nextBtn.enabled = YES;

    self.viewTopConstraint.constant = Height_NavBar;
}

#pragma mark - 重写父类函数
-(void)leftBtnClick:(UIButton *)btn {
    [self backToLoginViewController];
}

#pragma mark -
- (IBAction)nextBtnClick:(UIButton *)sender {
    [self backToLoginViewController];
}

#pragma mark - 回到登录页
-(void)backToLoginViewController {
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 2) {
        UIViewController *vc = viewControllers[1];
        [self.navigationController popToViewController:vc animated:YES];
    }
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
