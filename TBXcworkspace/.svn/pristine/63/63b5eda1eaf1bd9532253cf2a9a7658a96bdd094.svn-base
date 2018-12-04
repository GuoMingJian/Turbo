//
//  TBUpdateModuleFactory.m
//  TBBusiness
//
//  Created by Apple on 2018/6/22.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TBUpdateModuleFactory.h"
#import "YYCache.h"
#import "TBH5SourceModel.h"
#import <Turbo/Turbo.h>

@implementation TBUpdateModuleFactory

/**
 *  APP首次安装的时候会将工程中的dist文件夹复制一份到沙箱中，dist文件夹中的各模块没有单独的file_name_list.json文件，
     只有外层总的file_name_list.json文件；
 *  模块更新完毕后，需要修改file_name_list.json文件模块的版本号
 */

+(instancetype)shareFactoryInstance {
    static TBUpdateModuleFactory *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[TBUpdateModuleFactory alloc] init];
    });
    return _instance;
}

#pragma mark - 检测模块是否有版本更新，返回下载地址
-(NSString *)analyzeWithModuleName:(NSString *)moduleName {
    // 异常处理
    if (!moduleName || moduleName.length == 0) {
        return nil;
    }
    
    // 查找appConfigFile.json中的模块数据
    NSDictionary *moduleDict = [self searchAppConfigFileModuleInfo:moduleName];
    NSString *updateUrl = nil;
    if (moduleDict && moduleDict.count > 0) {
        /**
         *  有数据，说明查找到模块 --> 对比版本号，确定是否需要下载更新；
         */
        YYCache *cache = [YYCache cacheWithName:FILE_NAME_LIST];
        TBH5SourceModel *sourceModel = (TBH5SourceModel *)[cache objectForKey:moduleName];
        
        // 缓存中的某模块version --> 3.x.x
        NSString *localModuleVersion = sourceModel.moduleVersion;
        NSInteger localModuleVersionFirstNum = [[localModuleVersion substringToIndex:1] integerValue];
        NSInteger localModuleVersionNum = [[localModuleVersion stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
        
        // appConfigFile.json中某模块的version --> 4.x.x
        NSString *newVersion = [[moduleDict objectForKey:@"newModule"] objectForKey:@"version"];
        NSInteger newVersionFirstNum = [[newVersion substringToIndex:1] integerValue];
        NSInteger newVersionNum = [[newVersion stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
        
        if (localModuleVersionNum >= newVersionNum) {
            // 如果本地模块的版本 >= appConfigFile对应模块的版本，直接返回nil
            return nil;
        } else if (newVersionFirstNum > localModuleVersionFirstNum) {
            // 如果版本号的首位有跨度，说明有大版本，做一个全量更新
            updateUrl = [[moduleDict objectForKey:@"newModule"] objectForKey:@"url"];
        } else if (newVersionNum > localModuleVersionNum) {
            // 小版本更新，对比新旧version，在versionList中查找对应的版本url，做增量更新
            __block NSString *url = @"";
            NSArray *versionListArr = [moduleDict objectForKey:@"versionList"];
            [versionListArr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([[dict objectForKey:@"version"] isEqualToString:localModuleVersion]) {
                    // 找到对应的版本
                    url = [dict objectForKey:@"url"];
                    *stop = YES;
                }
            }];
            
            if (url.length > 0) {
                // 如果url有内容，说明查找到对应版本的增量信息
                updateUrl = url;
            } else {
                // 如果url没内容，直接拿newModule里面的url做全量更新
                updateUrl = [[moduleDict objectForKey:@"newModule"] objectForKey:@"url"];
            }
        }
    }
    
    return updateUrl;
}

#pragma mark - 下载模块zip包、解压并移动文件
-(void)downloadModuleZipWithUrlAndMoveFiles:(NSString *)url {
    [[TBFileDownload shareFileDownloadManager] downloadFileWithUrl:url savePath:DOWNLOAD_DIRECTORY progress:^(CGFloat progress) {
        NSLog(@"下载进度 == %.2f",progress);
    } success:^(NSURLResponse *response, NSURL *filePath) {
        NSString *suggestedFilename = response.suggestedFilename;
        NSString *absolutePath = [DOWNLOAD_DIRECTORY stringByAppendingPathComponent:suggestedFilename];
        BOOL isSuccess = [TBZipArchive unzipFileAtPath:absolutePath toDestination:DOWNLOAD_DIRECTORY];
        // 删除zip包
        [TBFileHandleManager removeFile:absolutePath];
        if (isSuccess) {
            NSString *tips = [NSString stringWithFormat:@"%@解压成功",suggestedFilename];
            TBLog(tips);
            
            // 1、执行文件移动操作
            NSArray *tempArr = [suggestedFilename componentsSeparatedByString:@"."];
            if (tempArr.count > 0) {
                // moduleName --> 模块名称
                NSString *moduleName = [tempArr objectAtIndex:0];
                NSString *directoryPath = [DOWNLOAD_DIRECTORY stringByAppendingPathComponent:moduleName];
                NSString *jsonPath = [directoryPath stringByAppendingPathComponent:FILE_NAME_LIST];
                NSDictionary *tempDict = [jsonPath jsonAnalyze];
                NSArray *fileArr = [tempDict objectForKey:@"files"];
                [fileArr enumerateObjectsUsingBlock:^(NSString *path, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *filePath = [directoryPath stringByAppendingPathComponent:path];
                    NSString *filePath2 = [NSString stringWithFormat:@"%@/%@%@",TB_WWW_DIRECTORY,moduleName,path];
                    // 开始移动文件
                    if ([TBFileHandleManager moveFile:filePath toPath:filePath2]) {
                        NSLog(@"成功 idx == 【%ld】",(unsigned long)idx);
                    } else {
                        NSLog(@"失败 idx == 【%ld】",(unsigned long)idx);
                    }
                }];
                
                // 2、将file_name_list.json文件也移动到文件夹中
                if ([TBFileHandleManager moveFile:jsonPath toPath:[NSString stringWithFormat:@"%@/%@/%@",TB_WWW_DIRECTORY,moduleName,FILE_NAME_LIST]]) {
                    NSLog(@"file_name_list.json 文件移动成功！！");
                }
                
                // 3、更新数据库中模块的版本号
                NSDictionary *moduleDict = [self searchAppConfigFileModuleInfo:moduleName];
                if (moduleDict && moduleDict.count > 0) {
                    YYCache *cache = [YYCache cacheWithName:FILE_NAME_LIST];
                    TBH5SourceModel *sourceModel = (TBH5SourceModel *)[cache objectForKey:moduleName];
                    sourceModel.moduleVersion = [[moduleDict objectForKey:@"newModule"] objectForKey:@"version"];
                    [cache setObject:sourceModel forKey:moduleName];
                } else {
                    NSLog(@"【appConfigFile.json模块数据异常】");
                }
                
                // 4、移除模块文件夹
                BOOL isSuccess = [TBFileHandleManager removeFile:directoryPath];
#if DEBUG
                if (isSuccess) {
                    NSLog(@"%@",[NSString stringWithFormat:@"【%@文件夹删除成功！】",moduleName]);
                } else {
                    NSLog(@"%@",[NSString stringWithFormat:@"【%@文件夹删除失败！】",moduleName]);
                }
#endif
            }
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@解压失败",suggestedFilename]);
        }
    } fail:^(NSError *error) {
        NSLog(@"%@",[NSString stringWithFormat:@"%@--->【模块下载失败】",url]);
    }];
}

#pragma mark - 查找appConfigFile.json中模块信息
-(NSDictionary *)searchAppConfigFileModuleInfo:(NSString *)moduleName {
    /**
     *  读取沙箱中的appConfigFile.json数据
     *  CONFIG_JSON_PATH = Documents/TBConfigFile/appConfigFile.json
     */
    id tempObj1 = [CONFIG_JSON_PATH jsonAnalyze];
    __block NSDictionary *moduleDict = nil;
    if (tempObj1 && [tempObj1 isKindOfClass:[NSDictionary class]]) {
        NSDictionary *configFileDict = (NSDictionary *)tempObj1;
        if (configFileDict.count > 0) {
            id tempObj2 = [configFileDict objectForKey:@"module"];
            if ([tempObj2 isKindOfClass:[NSArray class]]) {
                NSArray *moduleArr = (NSArray *)tempObj2;
                // 开始查找模块
                [moduleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *configOneModuleDict = (NSDictionary *)obj;
                        if ([[configOneModuleDict objectForKey:@"moduleName"] isEqualToString:moduleName]) {
                            // 保存模块信息
                            moduleDict = configOneModuleDict;
                            *stop = YES;
                        }
                        
                    } else {
                        NSLog(@"【appConfigFile.json模块数据格式异常】");
                    }
                }];
            } else {
                NSLog(@"【appConfigFile.json内层数据格式异常】");
            }
        }
    } else {
        NSLog(@"【appConfigFile.json外层数据格式异常】");
    }
    
    return moduleDict;
}
@end
