//
//  TBDetectJailbreak.h
//  Turbo
//
//  Created by Apple on 2018/9/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  越狱检测类
 */
@interface TBDetectJailbreak : NSObject
/**
 *  YES:已越狱 NO:未越狱
 */
+(BOOL)detectJailbreak;
@end
