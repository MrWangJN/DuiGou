//
//  RegularExpression.m
//  BaseFrameWork
//
//  Created by wjn on 16/4/4.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "RegularExpression.h"

@implementation RegularExpression

+ (BOOL)affirmPhoneNum:(NSString *)phoneNum {
    NSString *regex = @"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(1[4|7][0-9]))\\d{8}$";
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [preicate evaluateWithObject:phoneNum];
}

+ (BOOL)affirmPassword:(NSString *)password {
    
    return YES;
}

@end
