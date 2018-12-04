//
//  TBDetectNetworkStatus.m
//  TBBusiness
//
//  Created by Apple on 2018/7/23.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TBDetectNetworkStatus.h"
#import "TBAlertViewManager.h"

@implementation TBDetectNetworkStatus
+(kNetworkStatus)detectNetworkStatus {
    kNetworkStatus netStatus = [[TBNetworkStatusManager shareInstance] getNetworkStatus];
    if (netStatus == 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [TBAlertViewManager showAlertViewWithTitle:@"提示" content:@"网络不可用" confirmBlock:^{
                //NSLog(@"确认");
            } cnacelBlock:nil];
            
        });
    }
    return netStatus;
}
@end
