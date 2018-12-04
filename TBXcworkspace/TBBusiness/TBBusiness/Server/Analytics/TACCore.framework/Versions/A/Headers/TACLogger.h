//
//  TACLogger.h
//  TACCore
//
//  Created by Dong Zhao on 2017/11/21.
//

#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudCore.h>


#define TACLogError(frmt, ...) \
QCloudLogError(frmt, ##__VA_ARGS__)

#define TACLogWarning(frmt, ...) \
QCloudLogWarning(frmt, ##__VA_ARGS__)

#define TACLogInfo(frmt, ...) \
QCloudLogInfo(frmt, ##__VA_ARGS__)

#define TACLogDebug( frmt, ...) \
QCloudLogDebug(frmt, ##__VA_ARGS__)


#define TACLogVerbose(frmt, ...) \
QCloudLogVerbose(frmt, ##__VA_ARGS__)

#define TACLogException(exception) \
QCloudLogException(exception)

#define TACLogTrance()\
QCloudLogTrance()

