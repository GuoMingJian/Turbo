//
//  TBGuideViewManager.m
//  TBBusiness
//
//  Created by Apple on 2018/10/12.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TBGuideViewManager.h"
#import "TBGuideViewController.h"

@implementation TBGuideViewManager
/**
 *  设计思路：
 *  1.先获取保存在本地的APP版本号，如果没有，说明是首次安装，显示引导视图；
 *  2.如果本地保存有APP版本号，将其与info.plist中的对比，如果不相同，显示引导视图；
 *  （正常逻辑应该是小于才显示，因为小于才代表APP更新了）
 */
+(instancetype)shareManager {
    static TBGuideViewManager *_instace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[TBGuideViewManager alloc] init];
    });
    return _instace;
}

#pragma mark - 显示引导视图
- (void)showGuideView {
    if (![[self getLocalVersionNumber] isEqualToString:[self getAppVersionNumber]]) {
        TBGuideViewController *guideVC = [[TBGuideViewController alloc] init];
        self.window.rootViewController = guideVC;
        
        __weak TBGuideViewManager *weakSelf = self;
        guideVC.guideViewBlock = ^(){
            [self saveVersionNumber];
            weakSelf.guideViewManagerBlock();
        };
    } else {
        if (self.guideViewManagerBlock) {
            self.guideViewManagerBlock();
        }
        
    }
}


#pragma mark - 保存版本号
-(void)saveVersionNumber {
    NSString *version = [self getAppVersionNumber];
    if (version && version.length > 0) {
        [version writeToFile:[self getVersionNumberSavePath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

#pragma mark - 获取info.plist中的APP版本号
-(NSString *)getAppVersionNumber {
    NSString *version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    return version;
}

#pragma mark - 获取保存在本地的APP版本号
-(NSString *)getLocalVersionNumber {
    NSString *path = [self getVersionNumberSavePath];
    NSData *tempData = [NSData dataWithContentsOfFile:path];
    NSString *version = [[NSString alloc] initWithData:tempData encoding:NSUTF8StringEncoding];
    return version;
}

#pragma mark - 获取保存路径
-(NSString *)getVersionNumberSavePath {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/version"];
}

@end
