//
//  TBConstant.h
//  TBBusiness
//
//  Created by Apple on 2018/1/25.
//  Copyright © 2018年 Apple. All rights reserved.
//

#ifndef TBConstant_h
#define TBConstant_h

// 屏幕宽高宏定义
#define MAIN_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define MAIN_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

// 状态栏高度
#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height

// 导航栏高度
#define NAVIGATION_BAR_HEIGHT [[UINavigationController alloc] init].navigationBar.frame.size.height

// 分栏控制器高度
#define TAB_BAR_HEIGHT ([UIApplication sharedApplication].statusBarFrame.size.height > 20 ? 83.0:49.0)

// 网络状态key名
#define NETWORK_STATUS @"networkStatus"

// 主题颜色
#define TB_BASE_COLOR [UIColor colorWithRed:240/255.0f green:80/255.0f blue:29/255.0f alpha:1.0f]

// 导航控制器背景颜色
#define NAV_BACKGROUND_COLOR [UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:1.0f]

// 拼凑完整的URL地址
#define REQUEST_URL(frmt,...) [NSString stringWithFormat:@"%@/%@",[[TBDefaultsManager shareInstance] getBaseServerUrl],frmt]

// URL转码，避免访问不了
#define URL_ENCODE(frmt,...) [frmt stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]

/**  增量更新相关宏定义 */
#define APP_CODE @"mbank"
// 服务器地址
#define BASE_SERVER_URL @"http://139.199.158.23"
// 下载增量更新配置文件接口
#define UPDATE_INTERFACE_URL [NSString stringWithFormat:@"%@/operate/release/queryAppUpdate",BASE_SERVER_URL]
// 在线服务器地址(检测到模块需要更新时，先访问远程资源)
#define REMOTE_BASE_URL [NSString stringWithFormat:@"%@:81/service/%@",BASE_SERVER_URL, APP_CODE]

// 沙盒Documents
#define DOCUMENTS [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
// 存放下载文件的文件夹
#define DOWNLOAD_DIRECTORY [DOCUMENTS stringByAppendingPathComponent:@"Download"]

// 工程中存放H5资源的文件夹名称
#define TB_DIST @"dist"
// 存放H5资源的沙盒路径
#define TB_WWW_DIRECTORY [DOCUMENTS stringByAppendingPathComponent:TB_DIST]

// dist包版本号(在file_name_list.json里面)
#define DIST_VERSION @"dist_version"
// 文件列表
#define FILE_NAME_LIST @"file_name_list.json"

// 配置文件相关宏定义
#define CONFIG_FILE_DIR_PATH [DOCUMENTS stringByAppendingPathComponent:@"TBConfigFile"]
#define CONFIG_JSON_NAME @"appConfigFile.json"
#define CONFIG_JSON_PATH [NSString stringWithFormat:@"%@/%@",CONFIG_FILE_DIR_PATH,CONFIG_JSON_NAME]

// APP从后台返回前台通知名称
#define ENTER_FOREGROUND_NOTICE @"EnterForeground"
#endif /* TBConstant_h */
