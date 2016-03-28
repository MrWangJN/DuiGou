//
//  NetWorkingTask.m
//  SAFramework
//
//  Created by 王建男 on 15/3/7.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SANetWorkingTask.h"

@implementation SANetWorkingTask

+(void)request:(NSString *)URL parmater:(NSDictionary *)dictionary block:(void (^)(NSDictionary *))block {
	
	if ([SAReachabilityManager sharedReachabilityManager].currentReachabilityStatus == NotReachable) {
        [KVNProgress showErrorWithStatus:@"请检查网络"];
		return;
	}
	
    if ([SAReachabilityManager sharedReachabilityManager].currentReachabilityStatus == ReachableViaWWAN) {
//        [KVNProgress showErrorWithStatus:@"您正处于非WIFI状态下"];
    }
    
    NSString *resultStr = URL;
    CFStringRef originalString = (__bridge CFStringRef)URL;
    CFStringRef leaveUnescaped = CFSTR(" ");
    CFStringRef forceEscaped = CFSTR("!*'();@+$,#[]");
    CFStringRef escapedStr;
    
    escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                         originalString,
                                                         leaveUnescaped,
                                                         forceEscaped,
                                                         kCFStringEncodingUTF8);
    if(escapedStr)
    {
        NSMutableString *mutableStr = [NSMutableString stringWithString:(__bridge NSString *)escapedStr];
        CFRelease(escapedStr);
        
        // replace spaces with plusses
        [mutableStr replaceOccurrencesOfString:@" "
                                    withString:@""
                                       options:0
                                         range:NSMakeRange(0, [mutableStr length])];
        resultStr = mutableStr;
    }
    
    URL = resultStr;
    
	AFHTTPRequestOperationManager *mannager = [AFHTTPRequestOperationManager manager];
	[mannager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", @"text/plain", nil]];
	[mannager GET:URL parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
	
		NSDictionary *data = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:NULL];
		
		block(data);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[KVNProgress dismiss];
	}];
}

+ (void)requestWithPost:(NSString *)URL parmater:(NSDictionary *)dictionary block:(void (^)(id))block {
    
    if ([SAReachabilityManager sharedReachabilityManager].currentReachabilityStatus == NotReachable) {
        [KVNProgress showErrorWithStatus:@"请检查网络"];
        return;
    }
    
    if ([SAReachabilityManager sharedReachabilityManager].currentReachabilityStatus == ReachableViaWWAN) {
//        [KVNProgress showErrorWithStatus:@"您正处于非WIFI状态下"];
    }
    
    NSString *resultStr = URL;
    CFStringRef originalString = (__bridge CFStringRef)URL;
    CFStringRef leaveUnescaped = CFSTR(" ");
    CFStringRef forceEscaped = CFSTR("!*'();@+$,#[]");
    CFStringRef escapedStr;
    
    escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                         originalString,
                                                         leaveUnescaped,
                                                         forceEscaped,
                                                         kCFStringEncodingUTF8);
    if(escapedStr)
    {
        NSMutableString *mutableStr = [NSMutableString stringWithString:(__bridge NSString *)escapedStr];
        CFRelease(escapedStr);
        
        // replace spaces with plusses
        [mutableStr replaceOccurrencesOfString:@" "
                                    withString:@""
                                       options:0
                                         range:NSMakeRange(0, [mutableStr length])];
        resultStr = mutableStr;
    }
    
    URL = resultStr;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", @"text/plain", nil]];
    
    [manager POST:URL parameters:dictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id data = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:NULL];
        block(data);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#ifdef DEBUG 
        NSLog(@"error:%@", error);
#endif
        [KVNProgress dismiss];
        [KVNProgress showErrorWithStatus:@"请求服务器失败"];
    }];
}

+ (void)requestWithPost:(NSString *)URL parmater:(NSDictionary *)dictionary blockOrError:(void (^)(id result, NSError *error))block {
    
    if ([SAReachabilityManager sharedReachabilityManager].currentReachabilityStatus == NotReachable) {
        [KVNProgress showErrorWithStatus:@"请检查网络"];
        NSError *error = [NSError errorWithDomain:@"error" code:1 userInfo:nil];
        block(nil, error);
        return;
    }
    
    if ([SAReachabilityManager sharedReachabilityManager].currentReachabilityStatus == ReachableViaWWAN) {
        //        [KVNProgress showErrorWithStatus:@"您正处于非WIFI状态下"];
    }
    
    NSString *resultStr = URL;
    CFStringRef originalString = (__bridge CFStringRef)URL;
    CFStringRef leaveUnescaped = CFSTR(" ");
    CFStringRef forceEscaped = CFSTR("!*'();@+$,#[]");
    CFStringRef escapedStr;
    
    escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                         originalString,
                                                         leaveUnescaped,
                                                         forceEscaped,
                                                         kCFStringEncodingUTF8);
    if(escapedStr)
    {
        NSMutableString *mutableStr = [NSMutableString stringWithString:(__bridge NSString *)escapedStr];
        CFRelease(escapedStr);
        
        // replace spaces with plusses
        [mutableStr replaceOccurrencesOfString:@" "
                                    withString:@""
                                       options:0
                                         range:NSMakeRange(0, [mutableStr length])];
        resultStr = mutableStr;
    }
    
    URL = resultStr;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", @"text/plain", nil]];
    
    [manager POST:URL parameters:dictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id data = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:NULL];
        block(data, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#ifdef DEBUG
        NSLog(@"error:%@", error);
#endif
        [KVNProgress dismiss];
        [KVNProgress showErrorWithStatus:@"请求服务器失败"];
        block(nil, error);
    }];
}

+ (void)updataWithPost:(NSString *)URL parmater:(NSDictionary *)dictionary withData:(NSData *)data  withFileName:(NSString *)fileName block:(void (^)(id))block {
    
    if ([SAReachabilityManager sharedReachabilityManager].currentReachabilityStatus == NotReachable) {
        [KVNProgress showErrorWithStatus:@"请检查网络"];
        return;
    }
    
    if ([SAReachabilityManager sharedReachabilityManager].currentReachabilityStatus == ReachableViaWWAN) {
        //        [KVNProgress showErrorWithStatus:@"您正处于非WIFI状态下"];
    }
    
    NSString *resultStr = URL;
    CFStringRef originalString = (__bridge CFStringRef)URL;
    CFStringRef leaveUnescaped = CFSTR(" ");
    CFStringRef forceEscaped = CFSTR("!*'();@+$,#[]");
    CFStringRef escapedStr;

    escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                         originalString,
                                                         leaveUnescaped,
                                                         forceEscaped,
                                                         kCFStringEncodingUTF8);
    if(escapedStr)
    {
        NSMutableString *mutableStr = [NSMutableString stringWithString:(__bridge NSString *)escapedStr];
        CFRelease(escapedStr);
        
        // replace spaces with plusses
        [mutableStr replaceOccurrencesOfString:@" "
                                    withString:@""
                                       options:0
                                         range:NSMakeRange(0, [mutableStr length])];
        resultStr = mutableStr;
    }
    
    URL = resultStr;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", @"text/plain", @"application/x-javascript",nil]];
    
    [manager POST:URL parameters:dictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"imagefile" fileName:fileName mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id data = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:NULL];
        
        block(data);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#ifdef DEBUG
        NSLog(@"error:%@", error);
#endif
        
        [KVNProgress dismiss];
        [KVNProgress showErrorWithStatus:@"请求服务器失败"];
    }];
}

@end
