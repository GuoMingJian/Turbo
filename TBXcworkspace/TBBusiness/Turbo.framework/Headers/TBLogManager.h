//
//  TBLogManager.h
//  Turbo
//
//  Created by Apple on 2018/3/29.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBLogManager : NSObject

/**
 *  获取日志文件的路径
 *  @return 返回日志文件夹的路径
 *  说明：内部实现了在沙盒Documents文件夹下创建了名为"TurboLog"的文件夹，存放日志文件
 */
+ (NSString *)getLogDocumentPath;

/**
 *  写日志操作
 *  @return 返回操作结果
 *  说明：内部实现了操作日志的按天记录；
 *       日志名称是以日期命名的txt文件，例如：2018-03-29.txt;
 *       记录内容的格式为：“时间+内容”
 */
+(BOOL)writeLog:(NSString *)content;

/**
 *  删除日志操作
 *  @return 返回操作结果
 *  说明：该操作会将Documents下的TurboLog文件夹的所有日志删除
 */
+ (BOOL)deleteLog;

@end
