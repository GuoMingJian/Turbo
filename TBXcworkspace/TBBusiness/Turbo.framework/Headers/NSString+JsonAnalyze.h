//
//  NSString+JsonAnalyze.h
//  Turbo
//
//  Created by Apple on 2018/6/20.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JsonAnalyze)
/**
 *  json文件路径的NSString类型调用该类别方法，返回动态数据(NSArray、NSDictionary)
 */
-(id)jsonAnalyze;
@end
