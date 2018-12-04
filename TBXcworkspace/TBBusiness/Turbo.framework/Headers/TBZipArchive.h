//
//  TBZipArchive.h
//  Turbo
//
//  Created by Apple on 2018/3/22.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBZipArchive : NSObject

/**
 *  压缩
 *  @param path     需要创建的zip包的路径(例如：@"/Users/Apple/Desktop/img.zip")
 *  @param paths    文件路径的数组(例如：@[@"/Users/Apple/Desktop/1.png",@"/Users/Apple/Desktop/2.png"])
 *  return 压缩结果
 */
+ (BOOL)createZipFileAtPath:(NSString *_Nullable)path withFilesAtPaths:(NSArray *_Nullable)paths;

/**
 *  压缩
 *  @param path             需要创建的zip包的路径(例如：@"/Users/Apple/Desktop/Turbo.zip")
 *  @param directoryPath    需要压缩的文件夹的路径(例如：@[@"/Users/Apple/Desktop/Turbo")
 *  return 压缩结果
 */
+ (BOOL)createZipFileAtPath:(NSString *_Nullable)path withContentsOfDirectory:(NSString *_Nullable)directoryPath;

/**
 *  【加密】压缩
 *  @param path             需要创建的zip包的路径(例如：@"/Users/Apple/Desktop/Turbo.zip")
 *  @param directoryPath    需要压缩的文件夹的路径(例如：@[@"/Users/Apple/Desktop/Turbo")
 *  @param password         压缩包的密码
 *  return 压缩结果
 */
+ (BOOL)createZipFileAtPath:(NSString *_Nullable)path withContentsOfDirectory:(NSString *_Nullable)directoryPath withPassword:(NSString *_Nullable)password;

/**
 *  解压缩
 *  @param path         zip路径
 *  @param destination  解压的路径
 *  return 解压结果
 */
+ (BOOL)unzipFileAtPath:(NSString *_Nullable)path toDestination:(NSString *_Nullable)destination;


/**
 *  解压缩【需要密码】
 *  @param path         zip路径
 *  @param destination  解压的路径
 *  return 解压结果
 */
+ (BOOL)unzipFileAtPath:(NSString *_Nullable)path
          toDestination:(NSString *_Nullable)destination
              overwrite:(BOOL)overwrite
               password:(NSString *_Nullable)password
                  error:(NSError *_Nullable *_Nullable)error;
@end
