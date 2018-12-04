//
//  AppDelegate.m
//  TBBusiness
//
//  Created by Apple on 2018/1/25.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TBDelegate.h"
#import "TBTabBarController.h"
#import "TBURLProtocol.h"
#import <Turbo/Turbo.h>
#import "XGPush.h"          // 腾讯信鸽推送
#import <TACCore/TACCore.h> // 腾讯移动分析（MTA）
#import "TBH5BrowserViewController.h"
#import "TBUpdateModuleFactory.h"
#import "YYCache.h"
#import "TBH5SourceModel.h"
#import "TBDetectNetworkStatus.h"
#import "TBUpdateTipsView.h"
#import <TBCatchException/TBExceptionManager.h>
#import "TBGuideViewManager.h"
#import "IQKeyboardManager.h"
#import "HTTPServer.h"

@interface TBDelegate ()<XGPushDelegate>

@property (nonatomic) Reachability *networkReachability;
/**
 *  APP是否已经启动过标志位
 *  应用场景：因为APP从后台返回前台，会调用增量更新接口检查模块更新，
 *          如果有提醒更新APP的flag，在APP的生命周期内只提示一次，
 *          用户如果重启APP再进行提示，避免造成用户反感
 */
@property (nonatomic) BOOL isStartedFlag;
@property (nonatomic, strong) HTTPServer *localHttpServer;
@property (nonatomic, assign) NSString *port;

@end

@implementation TBDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 创建存放下载文件的文件夹
    if (![[NSFileManager defaultManager] fileExistsAtPath:DOWNLOAD_DIRECTORY]) {
        NSError *error;
        if ([[NSFileManager defaultManager] createDirectoryAtPath:DOWNLOAD_DIRECTORY withIntermediateDirectories:YES attributes:nil error:&error]) {
            TBLog(@"【存放下载文件的文件夹创建成功】");
        } else {
            NSLog(@"【存放下载文件的文件夹创建失败！！】");
        }
    } else {
        TBLog(@"【存放下载文件的文件夹已存在！！】");
    }
    
    // 崩溃日志收集
    [self collectCrashLog];
    // 配置Turbo框架
    [self configureTurboFramework];
    
    // 复制appConfigFile文件到沙箱(临时)
    if (![self copyAppConfigFileToDocuments]) {
        NSLog(@"appConfigFile.json复制失败");
    } else {
        NSLog(@"appConfigFile.json复制成功");
    }
    
    // 复制H5资源到沙箱(首次安装或者APP更新时执行)
    [self compareH5Source];
    // 调用增量更新接口
    [self connectUpdateInterface];
    
    // 设置根视图控制器
    [self setRootViewController];
    
    // 开始监听网络请求
    //[TBURLProtocol startListeningNetWorking];
    
    // 配置信鸽推送
    //[self configureXG:launchOptions];
    // 配置腾讯移动分析（MTA）
    //[self configureAnalytics];
    
    // 配置键盘自动弹出&缩回
    [self configIQKeyboardManager];

    // 搭建本地服务器
    //[self setupLocalHttpServer];

    return YES;
}

#pragma mark - 异常日志收集
- (void)collectCrashLog
{
    TBExceptionManager *manager = [TBExceptionManager sharedInstance];
    manager.appCode = APP_CODE;
    manager.macAddress = [TBDeviceID getDeviceID];
    [manager startCollectCrashLogs];
    
    //获取设备信息接口
    [manager uploadDeviceMessageComplete:^(id result, NSError *error) {
        NSLog(@"异常监控-上传设备信息：%@", result);
    }];
    
    //模拟[异常监控--错误]上传
    /*
     @try {
     NSArray *arr = [NSArray array];
     NSString *str = arr[2];
     NSLog(@"%@", str);
     } @catch (NSException *exception) {
     //NSLog(@"%@", exception);
     TBExceptionManager *manager = [TBExceptionManager sharedInstance];
     manager.appCode = APP_CODE;
     manager.macAddress = [TBDeviceID getDeviceID];
     [manager uploadErrorMsg:exception];
     } @finally {
     }
     */
}

#pragma mark - 复制appConfigFile.json到沙箱(临时)
- (BOOL)copyAppConfigFileToDocuments {
    BOOL isSuccess = NO;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"appConfigFile" ofType:@"json" inDirectory:@""];
    if (filePath.length > 0) {
        // 1 沙盒中创建保存appConfigFile.json文件的文件夹名为TBConfigFile
        if (![[NSFileManager defaultManager] fileExistsAtPath:CONFIG_FILE_DIR_PATH]) {
            // 2 不存在-->开始创建
            if (![[NSFileManager defaultManager] createDirectoryAtPath:CONFIG_FILE_DIR_PATH withIntermediateDirectories:YES attributes:nil error:nil]) {
                // 2-1 创建失败
            } else {
                // 2-2 创建成功 --> 开始复制
                if (![TBFileHandleManager copyFile:filePath toPath:CONFIG_JSON_PATH]) {
                    // 2-2-1 复制失败
                } else {
                    // 2-2-2 复制成功
                    isSuccess = YES;
                }
            }
        } else {
            // 3 文件夹已存在 --> 检查appConfigFile.json是否存在
            if (![[NSFileManager defaultManager] fileExistsAtPath:CONFIG_JSON_PATH]) {
                if (![TBFileHandleManager copyFile:filePath toPath:CONFIG_JSON_PATH]) {
                    // 3-1 复制失败
                } else {
                    // 3-2 复制成功
                    isSuccess = YES;
                }
            } else {
                NSLog(@"appConfigFile.json文件已存在，无需复制！");
            }
            
        }
    } else {
        NSLog(@"appConfigFile.json文件不存在！");
    }
    return isSuccess;
}

#pragma mark - 计算文件哈希值
- (NSString *)calculateFileHashValue:(NSString *)filePath {
    if (filePath) {
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        if (fileData.length > 0) {
            NSString *fileHashString = [TBMD5 getMD5String:fileData];
            if (fileHashString.length > 0) {
                return fileHashString;
            }
        }
    }
    return @"";
}

#pragma mark - 对比H5资源，确定是否需要将工程中的H5资源拷贝到沙箱中(首次安装或者APP更新)
- (void)compareH5Source {
    if ([TB_WWW_DIRECTORY fileSizeCalculate] == 0) {
        /**
         *  1.  沙箱中无内容，属于首次安装，需要拷贝
         */
        TBLog(@"【首次安装，需要拷贝H5资源】");
        [self copyH5SourceToDocuments];
    } else {
        /**
         *  2.  有内容，根据appConfigFile的信息判断是否需要回滚
         */
        id obj = [CONFIG_JSON_PATH jsonAnalyze];
        id rollBack = [obj objectForKey:@"rollBack"];
        id rollBackUrl = [obj objectForKey:@"rollBackUrl"];
        id rollBackVersion = [obj objectForKey:@"rollBackVersion"];
        
        if ([rollBack isKindOfClass:[NSNull class]] ||
            [rollBackUrl isKindOfClass:[NSNull class]] ||
            [rollBackVersion isKindOfClass:[NSNull class]])
        {
            /**
             * 2-1.如果不需要回滚，对比工程中的dist包和沙箱中dist包的版本号，
             以确定APP是否在App Store更新过。如有更新，重新将H5资源复制到沙箱
             */
            NSString *projectListPath = [[NSBundle mainBundle] pathForResource:[TB_DIST stringByAppendingPathComponent:FILE_NAME_LIST] ofType:nil];
            NSString *diskListPath = [TB_WWW_DIRECTORY stringByAppendingPathComponent:FILE_NAME_LIST];

            if (projectListPath && [[NSFileManager defaultManager] fileExistsAtPath:diskListPath]) {
                id obj = [projectListPath jsonAnalyze];
                NSDictionary *tempDict = (NSDictionary *)obj;
                NSString *projectListVersion = [tempDict objectForKey:@"version"];
                NSString *diskListVersion = [[diskListPath jsonAnalyze] objectForKey:@"version"];
                
                NSInteger projectVersion = [[projectListVersion stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
                NSInteger diskVersion = [[diskListVersion stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
                if (projectVersion > diskVersion) {
                    // 工程中的dist包版本号 > 沙箱中的，说明APP有更新了，需要重新拷贝
                    if ([TBFileHandleManager removeFile:TB_WWW_DIRECTORY]) {
                        [self copyH5SourceToDocuments];
                    }
                }
            }
        } else {
            /**
             *  2-2. 如果需要回滚，不再重新拷贝H5资源到沙箱
             */
        }
    }
}

#pragma mark - 拷贝H5资源到沙箱
- (void)copyH5SourceToDocuments {
    NSString *h5FilePath = [[NSBundle mainBundle] pathForResource:TB_DIST ofType:nil];
    // 异常处理
    if (!h5FilePath) {
        NSLog(@"【H5资源路径不存在！】");
        return;
    }
    
    // 开始复制
    BOOL isSuccess = [TBFileHandleManager copyFile:h5FilePath toPath:TB_WWW_DIRECTORY];
    if (!isSuccess) {
        NSLog(@"【H5资源复制到TBwww失败！】");
        return;
    }
    TBLog(@"【H5资源复制成功】");
    // 缓存dist文件夹中file_name_list.json数据到Disk中
    [self saveFileNameListDataToDisk];
}

#pragma mark - 缓存file_name_list.json数据到Disk中
- (BOOL)saveFileNameListDataToDisk {
    NSString *listJsonPath = [NSString stringWithFormat:@"%@/%@",TB_WWW_DIRECTORY,FILE_NAME_LIST];
    __block BOOL isSuccess = YES;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:listJsonPath]) {
        // 解析json文件
        id listObj = [listJsonPath jsonAnalyze];
        if (listObj && [listObj isKindOfClass:[NSDictionary class]]) {
            NSArray *listArr = [listObj objectForKey:@"modelList"];
            
            YYCache *cache = [YYCache cacheWithName:FILE_NAME_LIST];
            // 先执行移除
            [cache removeAllObjects];
            
            // 记录dist版本号
            NSString *version = [listObj objectForKey:@"version"];
            [cache setObject:version forKey:DIST_VERSION];
            
            // 记录模块信息
            [listArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *tempDict = (NSDictionary *)obj;
                    NSString *moduleName = [tempDict objectForKey:@"module"];
                    if (moduleName && moduleName.length > 0) {
                        // 建模
                        TBH5SourceModel *sourceModel = [TBH5SourceModel new];
                        sourceModel.moduleVersion = [tempDict objectForKey:@"version"];
                        sourceModel.module        = [tempDict objectForKey:@"module"];
                        sourceModel.moduleId      = [tempDict objectForKey:@"moduleId"];
                        sourceModel.path          = [tempDict objectForKey:@"path"];
                        sourceModel.files         = [tempDict objectForKey:@"files"];
                        
                        [cache setObject:sourceModel forKey:moduleName];
                    }
                } else {
                    NSLog(@"file_name_list.json内层数据格式异常");
                    isSuccess = NO;
                    [cache removeAllObjects];
                }
            }];
        } else {
            NSLog(@"file_name_list.json外层数据格式异常");
            return NO;
        }
    }
    
    return isSuccess;
}

#pragma mark - 设置根视图控制器
- (void)setRootViewController {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    // APP首次安装或者更新时，显示引导视图
    TBGuideViewManager *manager = [TBGuideViewManager shareManager];
    manager.window = self.window;
    manager.guideViewManagerBlock = ^(){
        self.window.rootViewController = [[TBTabBarController alloc] init];
    };
    [manager showGuideView];
}

#pragma mark - 增量更新、APP提示更新相关
- (void)connectUpdateInterface {
    NSString *timestamp = [self getTimestamp];
    timestamp = timestamp == nil ? @"" : timestamp;
    NSDictionary *headDict = @{@"timestamp":timestamp};
    
    NSString *versionNum = [self getVersionNum];
    versionNum = versionNum == nil ? @"" : versionNum;
    
    NSDictionary *dataDict = @{
                               @"systemType":@"0",//"0":代表iOS系统 "1":代表Android系统
                               @"appVersion":versionNum,
                               @"appCode":APP_CODE
                               };
    NSDictionary *dict = @{
                           @"head":headDict,
                           @"data":dataDict
                           };
    
    // 网络状态检测
    if ([TBDetectNetworkStatus detectNetworkStatus] == 0) {
        return;
    }
    
    [TBHTTPRequestClient syncPostRequestWithUrl:UPDATE_INTERFACE_URL params:dict timeoutInterval:5.0f success:^(id  _Nullable obj) {
        TBLog(obj);
        /**
         *  增量更新
         */
        id tempObj = [obj objectForKey:@"data"];
        if ([tempObj isKindOfClass:[NSNull class]]) {
            return;
        }
        // 获取配置文件的hash值
        NSString *configHashValue = [tempObj objectForKey:@"configHashValue"];
        if (![configHashValue isKindOfClass:[NSNull class]] && configHashValue.length > 0) {
            // 获取本地配置文件的hash值
            NSString *localConfigHashValue = [self calculateFileHashValue:CONFIG_JSON_PATH];
            if (![configHashValue isEqualToString:localConfigHashValue]) {
                // 两个hash值不一致，则下载配置，开始增量更新
                TBLog(@"---> 【两个hash值不一致，开始下载配置列表】 <---");
                NSString *configFileUrl = [[obj objectForKey:@"data"] objectForKey:@"configFileUrl"];
                [self downloadConfigFile:configFileUrl];
            } else {
                TBLog(@"【两个hash值一致，无需下载配置列表】");
            }
        }
        
        /**
         *  提示更新
         */
        NSString *releaseType = [tempObj objectForKey:@"releaseType"];
        if (![releaseType isKindOfClass:[NSNull class]] &&
            [releaseType isEqualToString:@"1"] && !self.isStartedFlag) {
            // 将标志位置为YES，避免二次提醒
            self.isStartedFlag = YES;
            // 安装包(提示更新/强制更新)
            NSString *noteFlag = [tempObj objectForKey:@"noteFlag"];
            // 异常处理
            if ([noteFlag isKindOfClass:[NSNull class]]) {
                return;
            }
            
            // 默认不强制更新
            BOOL isCompelUpdate = NO;
            if ([noteFlag isEqualToString:@"0"]) {
                // "0":强制更新 "1":不强制更新
                isCompelUpdate = YES;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                TBUpdateTipsView *tipsView = [[TBUpdateTipsView alloc] init];
                tipsView.isHideCloseBtn = isCompelUpdate;
                NSString *message = [tempObj objectForKey:@"noteDes"];
                if (![message isKindOfClass:[NSNull class]] && message.length > 0) {
                    tipsView.message = message;
                } else {
                    // 默认话术
                    tipsView.message = @"APP改版啦！";
                }
                
                tipsView.updateTipsViewBlock = ^{
                    // 获取URL并跳转到下载更新页面
                    NSString *urlString = [tempObj objectForKey:@"pkgUrl"];
                    if (![urlString isKindOfClass:[NSNull class]] && urlString.length > 0) {
                        NSURL *url = [NSURL URLWithString:urlString];
                        [[UIApplication sharedApplication] openURL:url];
                    }
                };
            });
        } else if (![releaseType isKindOfClass:[NSNull class]] && [releaseType isEqualToString:@"2"]) {
            // 修复包(热更新)
        }
        
    } fail:^(id  _Nullable obj, NSError * _Nullable error) {
        NSLog(@"失败回调：%@",obj);
    }];
}

#pragma mark - 获取APP版本号
- (NSString *)getVersionNum {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    return [infoDict objectForKey:@"CFBundleShortVersionString"];
}

#pragma mark - 时间戳
- (NSString *)getTimestamp {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString *timestamp = [dateFormatter stringFromDate:[NSDate date]];
    return timestamp;
}

#pragma mark - 下载config配置文件 --> 检查common模块是否需要更新
- (void)downloadConfigFile:(NSString *)url {
    // 网络状态检测
    if ([TBDetectNetworkStatus detectNetworkStatus] == 0) {
        return;
    }
    
    url = URL_ENCODE(url);
    
    NSURL *requestUrl = [NSURL URLWithString:url];
    NSURLRequest *request =  [NSURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:6.0];
    NSError *error = nil;
    NSURLResponse *respond = nil;
    // 同步请求
    NSData *tempData = [NSURLConnection sendSynchronousRequest:request returningResponse:&respond error:&error];
    
    if (tempData && tempData.length > 0) {
        if ([tempData writeToFile:CONFIG_JSON_PATH atomically:YES]) {
            TBLog(@"【appConfigFile写入成功】");
            /**
             *  检测是否是要回滚：
             *  1：无需回滚 --> 检测common模块是否需要更新
             *  2：需要回滚 --> 下载整个H5资源包
             */
            [self checkUpRollBackAndUpdate];
        } else {
            NSLog(@"【appConfigFile写入失败】");
        }
        ;
    } else {
        NSLog(@"【请求appConfigFile为空\n error = %@ \n respond = %@】",error,respond);
    }
}

#pragma mark - 检测回滚
- (void)checkUpRollBackAndUpdate {
    id obj = [CONFIG_JSON_PATH jsonAnalyze];
    BOOL rollBack = [[obj objectForKey:@"rollBack"] boolValue];
    if (!rollBack) {
        // 无需执行回滚 --> 检查common模块是否需要更新
        
        NSString *updateUrl = [[TBUpdateModuleFactory shareFactoryInstance] analyzeWithModuleName:@"common"];
        if (updateUrl && updateUrl.length > 0) {
            // 下载模块zip包、解压并移动文件
            [[TBUpdateModuleFactory shareFactoryInstance] downloadModuleZipWithUrlAndMoveFiles:updateUrl];
        }
    } else {
        // 需要执行回滚 --> 下载整个H5资源包
        
        // 先获取需要回滚版本号与本地的对比，如果一致，则无需回滚！
        NSString *rollBackVersion = [obj objectForKey:@"rollBackVersion"];
        YYCache *cache = [YYCache cacheWithName:FILE_NAME_LIST];
        NSString *localVersion = (NSString *)[cache objectForKey:DIST_VERSION];
        if ([rollBackVersion isEqualToString:localVersion]) {
            return;
        }
        
        NSString *rollBackUrl = [obj objectForKey:@"rollBackUrl"];
        if (![rollBackUrl isKindOfClass:[NSNull class]] && rollBackUrl.length > 0) {
            // 保存在Documents下
            NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            [[TBFileDownload shareFileDownloadManager] downloadFileWithUrl:rollBackUrl
                                                                  savePath:savePath
                                                                  progress:^(CGFloat progress)
             {
                 NSLog(@"%@",[NSString stringWithFormat:@"dist包下载进度：%.2f",progress]);
             } success:^(NSURLResponse *response, NSURL *filePath) {
                 NSString *suggestedFilename = response.suggestedFilename;
                 NSString *absolutePath = [savePath stringByAppendingPathComponent:suggestedFilename];
                 // 下载成功，执行解压
                 BOOL isSuccess = [TBZipArchive unzipFileAtPath:absolutePath toDestination:savePath];
                 if (isSuccess) {
                     TBLog(@"【dist.zip解压成功！】");
                     // 删除zip包
                     if ([TBFileHandleManager removeFile:absolutePath]) {
                         TBLog(@"【dist.zip删除成功】");
                     } else {
                         TBLog(@"【dist.zip删除失败】");
                     }
                     
                     // 重新缓存数据
                     [self saveFileNameListDataToDisk];
                 } else {
                     TBLog(@"【dist.zip解压失败！】");
                 }
             } fail:^(NSError *error) {
                 // 下载失败
             }];
        }
    }
}

#pragma mark - 配置Turbo(密钥协商)
- (void)configureTurboFramework {
    // 1、设置HTTPS证书路径
    NSString *httpsCertPath = [[NSBundle mainBundle] pathForResource:@"95508" ofType:@"pem" inDirectory:@"RSA_Der"];
    [[TBDefaultsManager shareInstance] setHttpsCertPath:httpsCertPath];
    
    // 2、设置RSA公钥证书路径
    NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:@"rsa_public_key" ofType:@"der" inDirectory:@"RSA_Der"];
    [[TBDefaultsManager shareInstance] setRsaPublicKeyCertPath:publicKeyPath];
    
    // 3、设置RSA私钥证书路径
    NSString *privateKeyPath = [[NSBundle mainBundle] pathForResource:@"rsaPri" ofType:@"p12" inDirectory:@"RSA_Der"];
    [[TBDefaultsManager shareInstance] setRsaPrivateKeyCertPath:privateKeyPath];
    
    // 4、设置加密通道(国密加密or国际加密，默认采用国密加密)
    [[TBDefaultsManager shareInstance] setEncryptChannel:NationalEncrypted];
    
    // 5、初始化Turbo框架
    TurboFramework *turbo = [TurboFramework shareInstance];
    [turbo initTurboFramework:^(BOOL isSuccess) {
        if (isSuccess) {
            // 握手成功
        } else {
            // 握手失败
        }
    }];
}

#pragma mark - 配置腾讯信鸽推送
- (void)configureXG:(NSDictionary *)launchOptions {
    [[XGPush defaultManager] setEnableDebug:YES];
    XGNotificationAction *action1 = [XGNotificationAction actionWithIdentifier:@"xgaction001" title:@"xgAction1" options:XGNotificationActionOptionNone];
    XGNotificationAction *action2 = [XGNotificationAction actionWithIdentifier:@"xgaction002" title:@"xgAction2" options:XGNotificationActionOptionDestructive];
    XGNotificationCategory *category = [XGNotificationCategory categoryWithIdentifier:@"xgCategory" actions:@[action1, action2] intentIdentifiers:@[] options:XGNotificationCategoryOptionNone];
    XGNotificationConfigure *configure = [XGNotificationConfigure configureNotificationWithCategories:[NSSet setWithObject:category] types:XGUserNotificationTypeAlert|XGUserNotificationTypeBadge|XGUserNotificationTypeSound];
    
    [[XGPush defaultManager] setNotificationConfigure:configure];
    [[XGPush defaultManager] startXGWithAppID:2200292529 appKey:@"I1K4Y3SG8W1A" delegate:self];
    [[XGPush defaultManager] setXgApplicationBadgeNumber:0];
    [[XGPush defaultManager] reportXGNotificationInfo:launchOptions];
}

#pragma mark - XGPushDelegate
- (void)xgPushDidFinishStart:(BOOL)isSuccess error:(NSError *)error {
    if (isSuccess) {
        NSLog(@"【启动信鸽服务成功】");
    } else {
        NSLog(@"【启动信鸽服务失败】");
    }
}

- (void)xgPushDidFinishStop:(BOOL)isSuccess error:(NSError *)error {
    if (isSuccess) {
        NSLog(@"【注销信鸽服务成功】");
    } else {
        NSLog(@"【注销信鸽服务失败】");
    }
    
}

- (void)xgPushDidRegisteredDeviceToken:(NSString *)deviceToken error:(NSError *)error {
    NSLog(@"deviceToken = %@",deviceToken);
}

#pragma mark - 配置腾讯移动分析（MTA）
- (void)configureAnalytics{
    TACApplicationOptions *options = [TACApplicationOptions defaultApplicationOptions];
    options.analyticsOptions.strategy = TACAnalyticsStrategyInstant;
    [TACApplication configurateWithOptions:options];
}

#pragma mark - 创建高斯模糊视图
- (UIView *)createBlurImgView {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.alpha = 0.98;
    [effectView setFrame:[UIScreen mainScreen].bounds];
    
    return effectView;
}

#pragma mark -
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
    // 添加高斯模糊视图
    UIView *blurView = [self createBlurImgView];
    blurView.tag = 10010;
    [[UIApplication sharedApplication].keyWindow addSubview:blurView];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    // APP准备返回前端时，重新调用增量更新接口
    [self connectUpdateInterface];
    // 发送通知让webView刷新（三个导航控制器一级界面）
    [[NSNotificationCenter defaultCenter] postNotificationName:ENTER_FOREGROUND_NOTICE object:nil];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // 移除高斯模糊视图
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if (view.tag == 10010) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [view removeFromSuperview];
            });
        }
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"[XGDemo] register APNS fail.\n[XGDemo] reason : %@", error);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"registerDeviceFailed" object:nil];
}


/**
 收到通知的回调
 
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"[XGDemo] receive Notification");
    [[XGPush defaultManager] reportXGNotificationInfo:userInfo];
}


/**
 收到静默推送的回调
 
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 @param completionHandler 完成回调
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"[XGDemo] receive slient Notification");
    NSLog(@"[XGDemo] userinfo %@", userInfo);
    [[XGPush defaultManager] reportXGNotificationInfo:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - 信鸽推送
// iOS 10 新增 API
// iOS 10 会走新 API, iOS 10 以前会走到老 API
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// App 用户点击通知
// App 用户选择通知中的行为
// App 用户在通知中心清除消息
// 无论本地推送还是远程推送都会走这个回调
- (void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSLog(@"[XGDemo] click notification");
    if ([response.actionIdentifier isEqualToString:@"xgaction001"]) {
        NSLog(@"click from Action1");
    } else if ([response.actionIdentifier isEqualToString:@"xgaction002"]) {
        NSLog(@"click from Action2");
    }
    
    [[XGPush defaultManager] reportXGNotificationResponse:response];
    
    completionHandler();
}

// App 在前台弹通知需要调用这个接口
- (void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    [[XGPush defaultManager] reportXGNotificationInfo:notification.request.content.userInfo];
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}
#endif

#pragma mark - 键盘自动弹出&缩回
- (void)configIQKeyboardManager
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.shouldResignOnTouchOutside = YES;//点击背景回缩键盘
    manager.keyboardDistanceFromTextField = 30.0f;//textField与键盘间距
    manager.enableAutoToolbar = YES;//是否显示Toolbar
}

#pragma mark - 搭建本地服务器

- (void)setupLocalHttpServer
{
    _localHttpServer = [[HTTPServer alloc] init];
    [_localHttpServer setType:@"_http._tcp."];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    //NSString *webLocalPath = TB_WWW_DIRECTORY;
    NSString * webLocalPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"];
    if (![fileManager fileExistsAtPath:webLocalPath])
    {
        NSLog(@"File path error!");
    }
    else
    {
        [_localHttpServer setDocumentRoot:webLocalPath];
        [self startServer];
    }
}

- (void)startServer
{
    NSError *error;
    if([_localHttpServer start:&error])
    {
        NSLog(@"HTTP-Server启动端口: %hu", [_localHttpServer listeningPort]);
        _port = [NSString stringWithFormat:@"%d", [_localHttpServer listeningPort]];
        //保存端口号，在调用的时候使用
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        [accountDefaults setObject:_port forKey:@"webPort"];
        [accountDefaults synchronize];
    }
    else
    {
        NSLog(@"本地HTTP-Server启动失败: %@", error);
    }
}

@end
