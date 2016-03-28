//
//  LocationManager.h
//  SAFramework
//
//  Created by wjn on 15/8/19.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationManagerDelegate;

@interface LocationManager : NSObject<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) id<LocationManagerDelegate>delegate;

/**
 *  getLocation
 */
- (void)startUpdatingLocation;

@end

@protocol LocationManagerDelegate <NSObject>

@optional

/**
 *  详细地址
 */

- (void)address:(NSString *)addressStr;

/**
 *  国家名称
 */

- (void)country:(NSString *)countryStr;

/**
 *  省
 */

- (void)state:(NSString *)stateStr;

/**
 *  市
 */

- (void)city:(NSString *)cityStr;

/**
 *  区名
 */

- (void)subLocality:(NSString *)subLocalityStr;

/**
 *  街道完成名称
 */

- (void)street:(NSString *)streetStr;

/**
 *  街道名称
 */

- (void)thoroughfare:(NSString *)thoroughfareStr;

/**
 *  具体地址
 */

- (void)subThoroughfare:(NSString *)subThoroughfare;

/**
 *  错误信息
 */

- (void)locationManagerWithError:(NSError *)error;

@end