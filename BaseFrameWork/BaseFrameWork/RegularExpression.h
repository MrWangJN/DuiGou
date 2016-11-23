//
//  RegularExpression.h
//  BaseFrameWork
//
//  Created by wjn on 16/4/4.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegularExpression : NSObject

+ (BOOL)affirmPhoneNum:(NSString *)phoneNum;
+ (BOOL)affirmPassword:(NSString *)password; 

@end
