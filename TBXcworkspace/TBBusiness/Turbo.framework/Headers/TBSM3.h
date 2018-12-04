//
//  TBSM3.h
//  Turbo
//
//  Created by Apple on 2018/4/25.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBSM3 : NSObject
#pragma mark - SM3 哈希计算
/**
 * 计算字符串SM3
 * @param src     要计算SM3的字符串
 * @return        SM3 Hash值
 *      <b> nil : 计算失败 </b><br/>
 *      <b> 非空 : 计算成功，计算后的数据 </b><br/>
 */
+ (NSData *)getSM3Hash:(NSString *)src;
@end
