//
//  RegisterViewController.h
//  DuiHao
//
//  Created by wjn on 16/3/31.
//  Copyright © 2016年 WJN. All rights reserved.
//


#import "SAKit.h"

@protocol RegisterViewControllerDelegate;

@interface RegisterViewController : UIViewController

@property (assign ,nonatomic) id<RegisterViewControllerDelegate>delegate;

@end

@protocol RegisterViewControllerDelegate <NSObject>

- (void)setPhoneNumAndPassWorld:(NSString *)phoneNum withpassWorld:(NSString *)passworld;

@end