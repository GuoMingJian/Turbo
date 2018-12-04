//
//  TBUpdateModuleFactory.h
//  TBBusiness
//
//  Created by Apple on 2018/6/22.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBUpdateModuleFactory : NSObject

+(instancetype)shareFactoryInstance;

/**
 *  检测模块是否有版本更新
 *  @param moduleName 模块名称
 *  return 返回模块地址（本地or远程）
 */
-(NSString *)analyzeWithModuleName:(NSString *)moduleName;

/**
 *  下载模块zip包、解压并移动文件
 *  @param url 模块zip包的下载地址
 */
-(void)downloadModuleZipWithUrlAndMoveFiles:(NSString *)url;
@end
