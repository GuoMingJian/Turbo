//
//  NavigationControllerBase.m
//  TBBusiness
//
//  Created by Apple on 2018/1/25.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TBNavigationControllerBase.h"
#import "TBConstant.h"

@interface TBNavigationControllerBase ()<UIGestureRecognizerDelegate>

@end

@implementation TBNavigationControllerBase

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置导航控制器背景颜色
    self.navigationBar.barTintColor = NAV_BACKGROUND_COLOR;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    return [super pushViewController:viewController animated:animated];
}

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
