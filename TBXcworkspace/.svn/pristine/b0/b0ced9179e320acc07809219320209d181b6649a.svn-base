//
//  TBTabBarController.m
//  TBBusiness
//
//  Created by Apple on 2018/1/25.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TBTabBarController.h"
#import "TBNavigationControllerBase.h"
#import "TBFirstViewController.h"
#import "TBSecondViewController.h"
#import "TBThirdViewController.h"
#import "TBFourthViewController.h"
#import "TBConstant.h"

@interface TBTabBarController ()

@end

@implementation TBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /**
     *  第一视图控制器
     */
    TBFirstViewController *firstVC = [[TBFirstViewController alloc] init];
    TBNavigationControllerBase *nav1 = [[TBNavigationControllerBase alloc]
                                        initWithRootViewController:firstVC];
    
    UIImage *selectImg1 =[[UIImage imageNamed:@"icon1-select"]
                          imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav1.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"icon1"] selectedImage:selectImg1];
    [nav1.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:TB_BASE_COLOR} forState:UIControlStateSelected];
    
    /**
     *  第二视图控制器
     */
    TBSecondViewController *secondVC = [[TBSecondViewController alloc] init];
    TBNavigationControllerBase *nav2 = [[TBNavigationControllerBase alloc]
                                        initWithRootViewController:secondVC];

    UIImage *selectImg2 = [[UIImage imageNamed:@"icon2-select"]
                           imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"财富" image:[UIImage imageNamed:@"icon2"] selectedImage:selectImg2];
    [nav2.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:TB_BASE_COLOR} forState:UIControlStateSelected];
    
    /**
     *  第三视图控制器
     */
    TBThirdViewController *thirdVC = [[TBThirdViewController alloc] init];
    TBNavigationControllerBase *nav3 = [[TBNavigationControllerBase alloc]
                                        initWithRootViewController:thirdVC];
    
    UIImage *selectImg3 = [[UIImage imageNamed:@"icon3-select"]
                           imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"信用卡" image:[UIImage imageNamed:@"icon3"] selectedImage:selectImg3];
    [nav3.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:TB_BASE_COLOR} forState:UIControlStateSelected];
    
    /**
     *  第四视图控制器
     */
    TBFourthViewController *fourthVC = [[TBFourthViewController alloc] init];
    TBNavigationControllerBase *nav4 = [[TBNavigationControllerBase alloc]
                                        initWithRootViewController:fourthVC];
    UIImage *selectImg4 = [[UIImage imageNamed:@"icon4-select"]
                           imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"icon4"] selectedImage:selectImg4];
    [nav4.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:TB_BASE_COLOR} forState:UIControlStateSelected];
    
    self.viewControllers = @[nav1,nav2,nav3,nav4];
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
