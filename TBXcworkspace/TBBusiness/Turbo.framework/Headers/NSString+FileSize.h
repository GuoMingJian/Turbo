//
//  NSString+FileSize.h
//  Turbo
//
//  Created by Apple on 2018/6/19.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FileSize)

/**
 *  文件及文件夹的大小计算
 */
-(unsigned long long)fileSizeCalculate;

@end
