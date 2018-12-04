//
//  MJSearchBar.h
//  OceanhighRelation
//
//  Created by 郭明健 on 2018/8/15.
//  Copyright © 2018年 MH. All rights reserved.
//

#import "MJSearchBar.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MJSearchBar;

@protocol MJSearchBarDelegate <NSObject>

@optional

- (BOOL)searchBarShouldBeginEditing:(MJSearchBar *)searchBar;
- (void)searchBarTextDidBeginEditing:(MJSearchBar *)searchBar;
- (BOOL)searchBarShouldEndEditing:(MJSearchBar *)searchBar;
- (void)searchBarTextDidEndEditing:(MJSearchBar *)searchBar;
- (void)searchBar:(MJSearchBar *)searchBar textDidChange:(NSString *)searchText;
- (void)searchBarSearchButtonClicked:(MJSearchBar *)searchBar;//点击键盘搜索按钮
//弃用
//- (void)searchBarCancelButtonClicked:(BYSearchBar *)searchBar;

@end

@interface MJSearchBar : UIView

//文本的颜色
@property (nonatomic,strong)UIColor *textColor;
//字体
@property (nonatomic,strong)UIFont *searBarFont;
//内容
@property (nonatomic,strong)NSString *text;
//背景颜色
@property (nonatomic,strong)UIColor *searBarColor;
//默认文本
@property (nonatomic,copy)NSString *placeholder;
//默认文本的颜色
@property (nonatomic,strong)UIColor *placeholdesColor;
//默认文本字体大小
@property (nonatomic,strong)UIFont *placeholdesFont;
//是否弹出键盘
@property (nonatomic,assign)BOOL isbecomeFirstResponder;
//设置右边按钮的样式
@property (nonatomic,strong)UIImage * deleteImage;
//设置代理
@property (nonatomic,weak)id<MJSearchBarDelegate> delegate;

@end
