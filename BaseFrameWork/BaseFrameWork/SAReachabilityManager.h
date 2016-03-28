//
//  SAReachabilityManager.h
//  SAFramework
//
//  Created by 王建男 on 15/3/7.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface SAReachabilityManager : NSObject {
	Reachability *internetReach;
}

@property (nonatomic, strong) Reachability *internetReach;

+ (SAReachabilityManager *)sharedReachabilityManager;

- (NetworkStatus)currentReachabilityStatus;

@end
