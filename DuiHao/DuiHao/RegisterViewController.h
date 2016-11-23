//
//  RegisterViewController.h
//  DuiHao
//
//  Created by wjn on 16/3/31.
//  Copyright © 2016年 WJN. All rights reserved.
//


#import "SAKit.h"
#import "PassWordViewController.h"

@protocol RegisterViewControllerDelegate;

@interface RegisterViewController : SAViewController

@property (assign, nonatomic) id<RegisterViewControllerDelegate>delegate;
@property (assign, nonatomic) GetType getType;

- (instancetype)initGetPassword;
- (instancetype)initRegister;

@end

@protocol RegisterViewControllerDelegate <NSObject>

- (void)setPhoneNumAndPassWorld:(NSString *)phoneNum withpassWorld:(NSString *)passworld;

@end
