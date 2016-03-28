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

#define KEYBOARDHIGHT 253

@interface LoginViewController : UIViewController<SearchViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *schoolButton;

@property (weak, nonatomic) IBOutlet UIControl *control;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UITextField *studentId;
@property (weak, nonatomic) IBOutlet UITextField *studentPassword;

@property (nonatomic, assign) NSInteger keyBoardHight;

@property (copy, nonatomic) NSString *schoolNumber;

//- (instancetype)initWithButton:(UIButton *)button;

@end
