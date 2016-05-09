//
//  ChangeInformationViewController.h
//  DuiHao
//
//  Created by wjn on 16/5/7.
//  Copyright © 2016年 WJN. All rights reserved.
//
#import "SAKit.h"

@interface ChangeInformationViewController : SAViewController

typedef enum : NSUInteger {
    StudentName,
    StudentSex,
    StudentPhoneNum,
    OrganizationName,
    StudentNumber
} ChangeInformationType;

- (instancetype)initWithType:(ChangeInformationType )type withTitle:(NSString *)title whitContent:(NSString *)content withKeyboardType:(UIKeyboardType)keyboardType;

@end
