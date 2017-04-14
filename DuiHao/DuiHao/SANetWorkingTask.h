//
//  NetWorkingTask.h
//  SAFramework
//
//  Created by 王建男 on 15/3/7.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "SAReachabilityManager.h"
#import "KVNProgress.h"

@interface SANetWorkingTask : NSObject
/**
 *  GET
 *
 *  @param URL        requestURL
 *  @param dictionary parameters
 *  @param block      result
 */
+ (void)request:(NSString *)URL parmater:(NSDictionary *)dictionary block:(void(^)(NSDictionary *result))block;
/**
 *  POST
 *
 *  @param URL        requestURL
 *  @param dictionary parameters
 *  @param block      result
 */
+ (void)requestWithPost:(NSString *)URL parmater:(NSDictionary *)dictionary block:(void(^)(id result))block;

+ (void)requestWithPost:(NSString *)URL parmater:(NSDictionary *)dictionary blockOrError:(void (^)(id result, NSError *error))block;

+ (void)requestProgressWithPost:(NSString *)URL parmater:(NSDictionary *)dictionary blockOrError:(void (^)(id result, NSError *error))block;

/**
 *  POST UPDATA
 *
 *  @param URL        requestURL
 *  @param dictionary parameters
 *  @param data       filedata
 *  @param fileName   filename
 *  @param block      result
 */
+ (void)updataWithPost:(NSString *)URL parmater:(NSDictionary *)dictionary withData:(NSData *)data  withFileName:(NSString *)fileName block:(void(^)(id result))block;


/**
 POST Download

 @param URL requestURL
 @param dictionary parameters
 @param block result
 */
+ (void)downloadWithPost:(NSString *)URL parmater:(NSDictionary *)dictionary block:(void(^)(id result))block;

/**
 * CancelNetworking
 */
+ (void)cancelAllOperations;
@end
