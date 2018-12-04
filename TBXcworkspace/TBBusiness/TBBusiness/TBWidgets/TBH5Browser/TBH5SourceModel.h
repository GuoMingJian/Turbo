//
//  TBH5SourceModel.h
//  TBBusiness
//
//  Created by Apple on 2018/6/26.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  该类用于解析file_name_list.json资源
 *
 */
#define MODULE_VERSION          @"version"
#define MODULE                  @"module"
#define MODULE_ID               @"moduleId"
#define PATH                    @"path"
#define FILES                   @"files"

@interface TBH5SourceModel : NSObject <NSCoding>
@property (nonnull, nonatomic, copy)        NSString *moduleVersion;
@property (nonnull, nonatomic, copy)        NSString *module;
@property (nonnull, nonatomic, copy)        NSString *moduleId;
@property (nonnull, nonatomic, copy)        NSString *path;
@property (nonnull, nonatomic, strong)      NSArray  *files;
@end
