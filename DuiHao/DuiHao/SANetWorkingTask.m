//
//  NetWorkingTask.m
//  SAFramework
//
//  Created by 王建男 on 15/3/7.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SANetWorkingTask.h"
#import "URLKeyManager.h"
#import <UIKit/UIKit.h>
#import "LoginViewController.h"

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
    
	AFHTTPSessionManager *mannager = [AFHTTPSessionManager manager];
	[mannager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", @"text/plain", nil]];
    mannager.requestSerializer.timeoutInterval = 10.0f;
    
//  manager.securityPolicy = [self customSecurityPolicy];
    
    [mannager GET:URL parameters:dictionary progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        block(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    NSString *stringPath = [NSString stringWithFormat:@"%@/%@", path, @"SESSIONID"];
    NSString *sessionId = [[NSString alloc] initWithContentsOfFile:stringPath encoding:NSUTF8StringEncoding error:nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", @"text/plain", nil]];
     manager.requestSerializer.timeoutInterval = 10.0f;
    // add SesionId
    if (sessionId && sessionId.length) {
        [manager.requestSerializer setValue:sessionId forHTTPHeaderField:@"SessionID"];
    }
    
//  manager.securityPolicy = [self customSecurityPolicy];
    
    [manager POST:URL parameters:dictionary progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     
        if ([responseObject[ERRORCODE] isEqualToString:RESULT_LOGIN]) {
            UIViewController *vc = [self getCurrentVC];
            [KVNProgress showErrorWithStatus:@"登录信息已过期，请重新登录"];
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [vc presentViewController:loginVC animated:YES completion:nil];
            return ;
        }
        
        block(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#ifdef DEBUG
        NSLog(@"error:%@", error);
#endif
        [KVNProgress dismiss];
        if (error.code == -1001) {
            [KVNProgress showErrorWithStatus:@"网络错误，请检查网络"];
        } else {
            [KVNProgress showErrorWithStatus:@"服务器访问失败"];
        }

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
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    NSString *stringPath = [NSString stringWithFormat:@"%@/%@", path, @"SESSIONID"];
    NSString *sessionId = [[NSString alloc] initWithContentsOfFile:stringPath encoding:NSUTF8StringEncoding error:nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", @"text/plain", nil]];
     manager.requestSerializer.timeoutInterval = 10.0f;
    // add SesionId
    if (sessionId && sessionId.length) {
        [manager.requestSerializer setValue:sessionId forHTTPHeaderField:@"SessionID"];
    }

//  manager.securityPolicy = [self customSecurityPolicy];
    
    [manager POST:URL parameters:dictionary progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[ERRORCODE] isEqualToString:RESULT_LOGIN]) {
            UIViewController *vc = [self getCurrentVC];
            [KVNProgress showErrorWithStatus:@"登录信息已过期，请重新登录"];
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [vc presentViewController:loginVC animated:YES completion:nil];
            return ;
        }
        block(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#ifdef DEBUG
        NSLog(@"error:%@", error);
#endif
        [KVNProgress dismiss];
        if (error.code == -1001) {
            [KVNProgress showErrorWithStatus:@"网络错误，请检查网络"];
        } else {
            [KVNProgress showErrorWithStatus:@"服务器访问失败"];
        }
        block(nil, error);
    }];
}

+ (void)requestProgressWithPost:(NSString *)URL parmater:(NSDictionary *)dictionary blockOrError:(void (^)(id result, NSError *error))block {
    
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
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    NSString *stringPath = [NSString stringWithFormat:@"%@/%@", path, @"SESSIONID"];
    NSString *sessionId = [[NSString alloc] initWithContentsOfFile:stringPath encoding:NSUTF8StringEncoding error:nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", @"text/plain", nil]];
    manager.requestSerializer.timeoutInterval = 10.0f;
    // add SesionId
    if (sessionId && sessionId.length) {
        [manager.requestSerializer setValue:sessionId forHTTPHeaderField:@"SessionID"];
    }
    
    //  manager.securityPolicy = [self customSecurityPolicy];
    [KVNProgress showProgress:0.0f status:@"正在上传"];
    [manager POST:URL parameters:dictionary progress:^(NSProgress * _Nonnull uploadProgress) {
        [KVNProgress updateProgress:uploadProgress.fractionCompleted animated:YES];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[ERRORCODE] isEqualToString:RESULT_LOGIN]) {
            UIViewController *vc = [self getCurrentVC];
            [KVNProgress showErrorWithStatus:@"登录信息已过期，请重新登录"];
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [vc presentViewController:loginVC animated:YES completion:nil];
            return ;
        }
        block(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#ifdef DEBUG
        NSLog(@"error:%@", error);
#endif
        [KVNProgress dismiss];
        if (error.code == -1001) {
            [KVNProgress showErrorWithStatus:@"网络错误，请检查网络"];
        } else {
            [KVNProgress showErrorWithStatus:@"服务器访问失败"];
        }
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
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    NSString *stringPath = [NSString stringWithFormat:@"%@/%@", path, @"SESSIONID"];
    NSString *sessionId = [[NSString alloc] initWithContentsOfFile:stringPath encoding:NSUTF8StringEncoding error:nil];
    
    URL = resultStr;
    [KVNProgress showProgress:0.0f status:@"正在上传"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", @"text/plain", @"application/x-javascript",nil]];
    manager.requestSerializer.timeoutInterval = 10.0f;
    
    if (sessionId && sessionId.length) {
        [manager.requestSerializer setValue:sessionId forHTTPHeaderField:@"SessionID"];
    }

    
    [manager POST:URL parameters:dictionary constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSString *otherFileName = fileName;
        
        if (!fileName) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            otherFileName = [NSString stringWithFormat:@"%@.png", str];
        }
        
         [formData appendPartWithFileData:data name:IMAGEFILE fileName:otherFileName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        [KVNProgress updateProgress:uploadProgress.fractionCompleted animated:YES];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[ERRORCODE] isEqualToString:RESULT_LOGIN]) {
            UIViewController *vc = [self getCurrentVC];
            [KVNProgress showErrorWithStatus:@"登录信息已过期，请重新登录"];
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [vc presentViewController:loginVC animated:YES completion:nil];
            return ;
        }
        
        block(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#ifdef DEBUG
        NSLog(@"error:%@", error);
#endif
        [KVNProgress dismiss];
        if (error.code == -1001) {
            [KVNProgress showErrorWithStatus:@"网络错误，请检查网络"];
        } else {
            [KVNProgress showErrorWithStatus:@"服务器访问失败"];
        }

    }];
}

- (AFSecurityPolicy*)customSecurityPolicy {
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"testClient" ofType:@"crt"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    [securityPolicy setAllowInvalidCertificates:YES];
    [securityPolicy setPinnedCertificates:[NSSet setWithObject:certData]];
//    [securityPolicy setSSLPinningMode:AFSSLPinningModeCertificate];
    /**** SSL Pinning ****/
    return securityPolicy;
}

+ (void)cancelAllOperations {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.operationQueue cancelAllOperations];
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
