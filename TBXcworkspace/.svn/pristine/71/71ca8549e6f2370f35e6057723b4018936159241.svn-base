//
//  TBAlertViewManager.m
//  TBBusiness
//
//  Created by Apple on 2018/7/12.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TBAlertViewManager.h"
#import "TBAlertViewController.h"

@implementation TBAlertViewManager
+(void)showAlertViewWithTitle:(NSString *)title
                      content:(NSString *)content
                 confirmBlock:(void (^)(void))confirmBlock
                  cnacelBlock:(void (^)(void))cancelBlock {
    TBAlertViewController *alertView = [TBAlertViewController alertControllerWithTitle:title message:content preferredStyle:(UIAlertControllerStyleAlert)];
    
    if (confirmBlock) {
        alertView.confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            confirmBlock();
        }];
    }
    
    if (cancelBlock) {
        alertView.cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            cancelBlock();
        }];
    }
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertView animated:YES completion:nil];
}

+(void)showAlertViewWithTitle:(NSString *)title
                      content:(NSString *)content
              confirmBtnTitle:(NSString *)confirmBtnTitle
                 confirmBlock:(void (^)(void))confirmBlock
               cancelBtnTitle:(NSString *)cancelBtnTitle
                  cnacelBlock:(void (^)(void))cancelBlock {
    TBAlertViewController *alertView = [TBAlertViewController alertControllerWithTitle:title message:content preferredStyle:(UIAlertControllerStyleAlert)];
    
    if (confirmBlock) {
        alertView.confirmAction = [UIAlertAction actionWithTitle:confirmBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            confirmBlock();
        }];
    }
    
    if (cancelBlock) {
        alertView.cancelAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            cancelBlock();
        }];
    }
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertView animated:YES completion:nil];
}
@end
