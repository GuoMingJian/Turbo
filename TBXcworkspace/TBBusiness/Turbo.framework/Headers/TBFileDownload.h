//
//  TBFileRequest.h
//  Turbo
//
//  Created by Apple on 2018/3/27.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TBFileDownload : NSObject

/**
 *  GCD单例
 *  @return 返回TBFileDownload实例；
 */
+ (instancetype)shareFileDownloadManager;


/**
 *  文件下载API 该API实现了后台下载、断点续传两大特色功能（基于AFN）
 *  @param  urlString        文件的下载路径
 *  @param  progressBlock    进度回调(百分比)
 *  @param  path             下载文件的保存路径
 *  @param  successBlock     成功回调
 *  @param  failBlock        失败回调
 *  @return 返回NSURLSessionDownloadTask实例
 */
-(NSURLSessionDownloadTask *)downloadFileWithUrl:(NSString *)urlString
                                        savePath:(NSString *)path
                                        progress:(void(^)(CGFloat progress))progressBlock
                                         success:(void(^)(NSURLResponse *response, NSURL *filePath))successBlock
                                            fail:(void(^)(NSError *error))failBlock;

/**
 *  取消所有下载任务
 */
-(void)cancelAllDownloadTasks;

/**
 *  取消某个下载任务
 */
-(void)cancelDownloadTaskWithUrl:(NSString *)url;

/**
 *  暂停所有下载任务
 */
-(void)suspendAllDownloadTasks;

/**
 *  暂停某个下载任务
 */
-(void)suspendDownloadTaskWithUrl:(NSString *)url;

@end
