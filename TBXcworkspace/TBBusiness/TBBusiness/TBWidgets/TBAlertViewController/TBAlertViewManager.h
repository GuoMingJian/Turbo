//
//  TBAlertViewManager.h
//  TBBusiness
//
//  Created by Apple on 2018/7/12.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBAlertViewManager : NSObject
+(void)showAlertViewWithTitle:(NSString *)title
                      content:(NSString *)content
                 confirmBlock:(void (^)(void))confirmBlock
                  cnacelBlock:(void (^)(void))cancelBlock;

+(void)showAlertViewWithTitle:(NSString *)title
                      content:(NSString *)content
              confirmBtnTitle:(NSString *)confirmBtnTitle
                 confirmBlock:(void (^)(void))confirmBlock
               cancelBtnTitle:(NSString *)cancelBtnTitle
                  cnacelBlock:(void (^)(void))cancelBlock;

@end
