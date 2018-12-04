//
//  TBScanView.h
//  TBBusiness
//
//  Created by Apple on 2018/10/23.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TBScanView : UIView
// 设置扫描的有效区域
@property (nonatomic, assign) CGSize scanAreaSize;

// 设置二维码扫描框的位置
@property (nonatomic, assign) CGRect cameraImageViewRect;

@property (nonatomic, strong) NSTimer *myTimer;
@end

NS_ASSUME_NONNULL_END
