//
//  TBCharButton.h
//  TBBusiness
//
//  Created by Apple on 2018/6/6.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    NHKBImageLeft = 0,
    NHKBImageInner,
    NHKBImageRight,
    NHKBImageMax
};

@interface TBCharButton : UIButton
@property (nonatomic, copy, nullable) NSString *chars;
@property (nonatomic, assign) BOOL isShift;

// 更新字符显示
- (void)updateChar:(nullable NSString *)chars;

// 是否额外更新大小写状态
- (void)updateChar:(nullable NSString *)chars shift:(BOOL)shift;

// 增加遮罩层
- (void)addPopup;
@end
