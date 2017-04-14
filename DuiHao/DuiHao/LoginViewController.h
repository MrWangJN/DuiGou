//
//  LoginViewController.h
//  StudyAssisTant
//
//  Created by 王建男 on 15/3/8.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//
#import "ViewController.h"
#import "SANetWorkingTask.h"
#import "SAURLManager.h"
#import "KVNProgress.h"
#import "OnceLogin.h"
#import "SearchViewController.h"
#import "SAKit.h"

#define KEYBOARDHIGHT 253
typedef NS_ENUM(NSInteger, LoginShowType) {
    LoginShowType_NONE,
    LoginShowType_USER,
    LoginShowType_PASS
};

@protocol LoginViewControllerDelegate <NSObject>

- (void)loginInSuccess;

@end

@interface LoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet DeformationButton *LoginBtn;

@property (weak, nonatomic) IBOutlet UIControl *control;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *controlTop;

@property (weak, nonatomic) IBOutlet DeformationButton *login;
@property (weak, nonatomic) IBOutlet UITextField *studentId;
@property (weak, nonatomic) IBOutlet UITextField *studentPassword;

@property (nonatomic, assign) NSInteger keyBoardHight;

@property (copy, nonatomic) NSString *schoolNumber;

@property (assign, nonatomic) id<LoginViewControllerDelegate>delegate;

//- (instancetype)initWithButton:(UIButton *)button;

@end
