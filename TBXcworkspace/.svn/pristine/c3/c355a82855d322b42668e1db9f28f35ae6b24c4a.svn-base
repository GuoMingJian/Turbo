//
//  TBViewControllerManager.m
//  TBBusiness
//
//  Created by Apple on 2018/6/14.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TBViewControllerManager.h"

@implementation TBViewControllerManager

+(instancetype)shareInstance {
    static TBViewControllerManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[TBViewControllerManager alloc] init];
        _instance.viewControllerArr = [NSMutableArray array];
        _instance.pathDict = [NSMutableDictionary dictionary];
    });
    return _instance;
}

#pragma mark - 控制视图控制器出栈
-(void)popViewControllerWithNavigationController:(UINavigationController *)navigationController andAmount:(NSInteger)amount {
    NSMutableArray *controllerArr = [NSMutableArray arrayWithArray:navigationController.viewControllers];
    NSInteger controllerCount = controllerArr.count;
    if (navigationController.viewControllers.count > 0) {
        UIViewController *vc = nil;
        /**
         *  逻辑说明：如果导航控制器中的视图控制器数量减去需要关闭页面的数量小于或等于0
         则获取导航控制器中的第一个视图控制器并出栈；
         */
        if (controllerCount - amount <= 0) {
            vc = [navigationController.viewControllers firstObject];
        } else {
            vc = [navigationController.viewControllers objectAtIndex:(controllerCount-1-amount)];
        }
        
        if (vc) {
            [navigationController popToViewController:vc animated:YES];
        } else {
            // 异常处理
            [navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        
    } else {
        // 异常处理
        [navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 移除viewControllerArr数组中的元素
-(void)removeElements:(NSInteger)num {
    for (NSInteger i = 0; i < num; i++) {
        // 保留viewControllerArr第一个元素，避免全部删除；
        if (self.viewControllerArr.count == 1) {
            break;
        }
        [self.viewControllerArr removeLastObject];
    }
}
@end
