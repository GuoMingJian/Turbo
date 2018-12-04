//
//  TACAnalyticsOptions.h
//  TACCore
//
//  Created by Dong Zhao on 2017/11/15.
//

#import <Foundation/Foundation.h>
#import "TACBaseOptions.h"
#import "TACAnalyticsStrategy.h"
#import "TACApplicationOptions.h"

/**
 分析模块的配置信息，通过实例化并配置该类可以改变分析模块的行为。
 */
@interface TACAnalyticsOptions : TACBaseOptions

/**
 客户端鉴权密钥，与appID共同验证以确定调用合法。需要配置到客户端SDK中，无法更换。该配置只能在json配置文件中设置。
 @note 该配置只能在json配置文件中设置。
 */
@property (nonatomic, strong, readonly) NSString* appKey;

/**
 Analytics数据上报策略,您只能选择一种上报策略，不可叠加使用
 @warning 您只能选择一种上报策略，不可叠加使用.
 @note 默认值采用：TACAnalyticsStrategyLaunch
 */
@property (nonatomic, assign) TACAnalyticsStrategy strategy;

/**
 最大批量发送消息个数，默认30，注意仅在发送策略为BATCH时有效
 */
@property (nonatomic, assign) NSInteger minBatchReportCount;

/**
 上报策略为PERIOD时发送间隔，单位毫秒，默认一天（24*60*60*1000）
 @note 单位为毫秒
 */
@property (nonatomic, assign) uint64_t sendPeriodMillis;

/**
 会话超时时长，在该时间段内用户再次应用则视为同一次会话，默认30000ms。
 @ntoe 单位为毫
 */
@property (nonatomic, assign) uint64_t sessionTimeoutMillis;


/**
 设置是否开启自动统计页面访问，默认开启
 @note 默认为YES
 */
@property (nonatomic, assign) BOOL autoTrackPageEvents;


/**
 智能上报，开启以后设备接入WIFI会实时上报。否则按照全局策略上报。默认打开。
 @note 默认为YES
 */
@property (nonatomic, assign) BOOL smartReporting;


@end


@interface TACApplicationOptions (Analytics)
@property (nonatomic, strong, readonly) TACAnalyticsOptions* analyticsOptions;
@end
