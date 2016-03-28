//
//  CGPasswordViewController.h
//  StudyAssisTant
//
//  Created by wjn on 15/9/2.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"
#import "OnceLogin.h"

@protocol CGPasswordViewControllerDelegate;

@interface CGPasswordViewController : SAViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *passWordNew;
@property (weak, nonatomic) IBOutlet UITextField *otherPassWord;
@property (assign, nonatomic) id<CGPasswordViewControllerDelegate>delegate;

@end

@protocol CGPasswordViewControllerDelegate <NSObject>

- (void)showLoginViewController;

@end