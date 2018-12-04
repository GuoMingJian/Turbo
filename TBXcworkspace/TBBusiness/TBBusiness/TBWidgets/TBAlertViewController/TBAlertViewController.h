//
//  TBAlertViewController.h
//  TBBusiness
//
//  Created by Apple on 2018/6/27.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cancelBlock)(void);
typedef void(^confirmBlock)(void);

@interface TBAlertViewController : UIAlertController

@property (nonnull, nonatomic, strong) UIAlertAction *confirmAction;
@property (nonnull, nonatomic, strong) UIAlertAction *cancelAction;
@property (nonnull, nonatomic, strong) cancelBlock cancelBlock;
@property (nonnull, nonatomic, strong) confirmBlock confirmBlock;
@end
