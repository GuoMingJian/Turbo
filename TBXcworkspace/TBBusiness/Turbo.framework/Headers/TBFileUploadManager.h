//
//  TBFileUpload.h
//  Turbo
//
//  Created by Apple on 2018/4/23.
//  Copyright © 2018年 Apple. All rights reserved.
//  文件上传类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^progressBlock) (CGFloat progress);
typedef void(^successBlock) (NSData *data, NSHTTPURLResponse *response);
typedef void(^failBlock) (NSHTTPURLResponse *response, NSError *error);

@interface TBFileUploadManager : NSObject

/**
 *  GCD单例
 *  @return 返回TBFileUpload实例；
 */
+(instancetype)shareInstance;

/**
 *  @param urlString        接口
 *  @param filePath         上传文件的路径
 *  @param fileName         上传文件的文件名称(可以不传；如果不传则取filePath的lastPathComponent)
 *  @param mimeType         媒体类型
 *  @param progressBlock    进度回调(百分比)
 *  @param successBlock     成功回调
 *  @param failBlock        失败回调
 */
-(NSURLSessionUploadTask *)uploadFileWithUrl:(NSString *)urlString
                                    filePath:(NSString *)filePath
                                    fileName:(NSString *)fileName
                                    mimeType:(NSString *)mimeType
                                    progress:(progressBlock)progressBlock
                                     success:(successBlock)successBlock
                                        fail:(failBlock)failBlock;

/**
 *  取消所有上传任务
 */
-(void)cancelAllUploadTasks;

/**
 *  取消某个上传任务
 *  @param url  接口地址
 *  @param filePath 上传文件的路径
 *  逻辑说明：1、因为存在向同一个接口上传不同文件或者同一份文件向不同接口上传的可能，
               因此内部建立了model以达到精准操控上传任务；
            2、此方法一般不用，因为上传API已经返回NSURLSessionUploadTask；
 */
-(void)cancelUploadTaskWithUrl:(NSString *)url andFilePath:(NSString *)filePath;

@end
