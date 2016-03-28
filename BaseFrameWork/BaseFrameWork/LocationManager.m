//
//  LocationManager.m
//  SAFramework
//
//  Created by wjn on 15/8/19.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "LocationManager.h"


@implementation LocationManager

/**
 *  配置plist
 *  NSLocationAlwaysUsageDescription 提示
 *  NSLocationWhenInUseUsageDescription 提示
 */

- (void)startUpdatingLocation {
    if([CLLocationManager locationServicesEnabled]) {
        if (!_locationManager) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;            
        }
#ifdef DEBUG
        NSLog(@"开始定位");
#endif
    }else {
#ifdef DEBUG
        NSLog(@"无法定位");
#endif
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    //  start location
    [self.locationManager startUpdatingLocation];
}

/**
 *  success
 */

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation: currentLocation completionHandler:^(NSArray *array, NSError *error) {
        
        if (array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            
            if ([self.delegate respondsToSelector:@selector(address:)]) {
                
                NSArray *addressArray = [placemark.addressDictionary objectForKey:@"FormattedAddressLines"];
                NSMutableString *addRess = [[NSMutableString alloc] init];
                for (int i = 0; i < addressArray.count; i ++) {
                    [addRess appendString:addressArray[i]];
                }
                [self.delegate address:addRess];
            }
            
            if ([self.delegate respondsToSelector:@selector(country:)]) {
                [self.delegate country:[placemark.addressDictionary objectForKey:@"Country"]];
            }
            
            if ([self.delegate respondsToSelector:@selector(state:)]) {
                [self.delegate state:[placemark.addressDictionary objectForKey:@"State"]];
            }
            
            if ([self.delegate respondsToSelector:@selector(city:)]) {
                [self.delegate city:[placemark.addressDictionary objectForKey:@"City"]];
            }
            
            if ([self.delegate respondsToSelector:@selector(subLocality:)]) {
                [self.delegate subLocality:[placemark.addressDictionary objectForKey:@"SubLocality"]];
            }
            
            if ([self.delegate respondsToSelector:@selector(street:)]) {
                [self.delegate street:[placemark.addressDictionary objectForKey:@"Street"]];
            }
            
            if ([self.delegate respondsToSelector:@selector(thoroughfare:)]) {
                [self.delegate thoroughfare:[placemark.addressDictionary objectForKey:@"Thoroughfare"]];
            }
            
            if ([self.delegate respondsToSelector:@selector(subLocality:)]) {
                [self.delegate subLocality:[placemark.addressDictionary objectForKey:@"SubLocality"]];
            }    
        }
    }];
    
    [_locationManager stopUpdatingLocation];
}

/**
 *  error
 *
 */

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        if ([self.delegate respondsToSelector:@selector(locationManagerWithError:)]) {
            [self.delegate locationManagerWithError:error];
        }
    }
}

@end
