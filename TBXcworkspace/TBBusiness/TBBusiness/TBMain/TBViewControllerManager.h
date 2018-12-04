//
//  TBViewControllerManager.h
//  TBBusiness
//
//  Created by Apple on 2018/6/14.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  目的
 *  1、存放跳转过的controller，以便执行pop动作的时候能查找需要pop的controller
 *  2、记录跳转的H5的页面是否隐藏导航控制器
 */
@interface TBViewControllerManager : NSObject
@property (nonatomic, strong) NSMutableArray *viewControllerArr;
@property (nonatomic, strong) NSMutableDictionary *pathDict;
+(instancetype)shareInstance;

/**
 *  控制视图控制器出栈
 *  @param navigationController 导航控制器对象
 *  @param amount 出栈的数量
 */
-(void)popViewControllerWithNavigationController:(UINavigationController *)navigationController andAmount:(NSInteger)amount;

/**
 *  移除viewControllerArr数组中的元素
 *  @param num 移除多少个元素(从最后一个元素开始)
 */
-(void)removeElements:(NSInteger)num;
@end
