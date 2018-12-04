//
//  TBFileHandleManager.h
//  Turbo
//
//  Created by Apple on 2018/3/28.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBFileHandleManager : NSObject
/**
 *  文件移动
 *  @param sourcePath   需要移动的文件的路径
 *  @param targetPath   文件移动的目标路径
 *  @return             返回移动结果
 *
 *  注意事项：
 *  1、sourcePath可以是文件夹也可以是文件，但该路径必须存在，否则会失败；
 *  2、targetPath不能为空字符串；
 *  3、targetPath可以传入一个未创建的文件夹路径，内部会实现创建，并且执行移动操作；
 *  4、如果targetPath是一个已有文件(是已有文件，非已有文件夹)的路径，内部会先将其删除再执行后面的移动操作；
 */
+(BOOL)moveFile:(NSString *)sourcePath toPath:(NSString *)targetPath;


/**
 *  文件复制
 *  @param sourcePath   需要复制的文件的路径
 *  @param targetPath   文件复制的目标路径
 *  @return             返回复制结果
 *
 *  注意事项：
 *  1、sourcePath可以是文件夹也可以是文件，但该路径必须存在，否则会失败；
 *  2、targetPath不能为空字符串；
 *  3、targetPath可以传入一个未创建的文件夹路径，内部会实现创建，并且执行复制操作；
 *  4、如果targetPath是一个已有文件(是已有文件，非已有文件夹)的路径，复制操作会失败；
 */
+(BOOL)copyFile:(NSString *)sourcePath toPath:(NSString *)targetPath;

/**
 *  文件删除
 *  @param filePath   需要删除的文件或文件夹的路径
 *  @return           返回删除结果
 *
 *  注意事项：如果传入的是文件夹路径，会将整个文件夹删除，请谨慎操作！
 */
+ (BOOL)removeFile:(NSString *)filePath;

@end
