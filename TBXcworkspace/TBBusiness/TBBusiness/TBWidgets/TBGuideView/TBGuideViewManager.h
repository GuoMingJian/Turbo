//
//  TBGuideViewManager.h
//  TBBusiness
//
//  Created by Apple on 2018/10/12.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^guideViewManagerBlock)(void);

@interface TBGuideViewManager : NSObject
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) guideViewManagerBlock guideViewManagerBlock;

+(instancetype)shareManager;
- (void)showGuideView;
@end

NS_ASSUME_NONNULL_END
