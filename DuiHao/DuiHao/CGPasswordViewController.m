//
//  CGPasswordViewController.m
//  StudyAssisTant
//
//  Created by wjn on 15/9/2.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "CGPasswordViewController.h"

@interface CGPasswordViewController ()

@property (weak, nonatomic) IBOutlet UIView *otherPassWordView;
@property (weak, nonatomic) IBOutlet UIView *passWordNewView;
@property (weak, nonatomic) IBOutlet UIView *passWordView;

@end

@implementation CGPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationItem setTitle:@"密码修改"];
    
    self.passWordView.layer.borderWidth = 1;
    self.passWordView.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
    self.passWordNewView.layer.borderWidth = 1;
    self.passWordNewView.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
    self.otherPassWordView.layer.borderWidth = 1;
    self.otherPassWordView.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonDidPress:(id)sender {
    
    [self backBtuDidPress];
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    
    if (!self.passWord.text.length) {
        [KVNProgress showErrorWithStatus:@"请输入旧密码"];
        return;
    }
    if (!self.passWordNew.text.length) {
        [KVNProgress showErrorWithStatus:@"请输入新密码"];
        return;
    }
    if (![self.otherPassWord.text isEqualToString:self.passWordNew.text]) {
        [KVNProgress showErrorWithStatus:@"确认密码与新密码不一致"];
        return;
    }
    
    NSDictionary *dic = @{STUDENTID : onceLogin.studentID, OLDSECRET : [self.passWord.text md5ForString], NEWSECRET : [self.otherPassWord.text md5ForString]};
//    [KVNProgress showWithStatus:@"正在修改密码"];
    [JKAlert alertWaitingText:@"正在修改密码"];
    [SANetWorkingTask requestWithPost:[SAURLManager modifyStuSecret] parmater:dic block:^(id result) {
        
        [JK_M dismissElast];
        
        if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
//            [KVNProgress showSuccessWithStatus:@"密码修改成功"];
            [JKAlert alertText:@"密码修改成功"];
            if ([self.delegate respondsToSelector:@selector(showLoginViewController)]) {
                [self.delegate showLoginViewController];
            }
            [self.navigationController popToRootViewControllerAnimated:NO];
        } else {
            [KVNProgress showErrorWithStatus:result[ERRORMESSAGE]];
        }
    }];
    
}

- (void)backBtuDidPress {
    [self.passWord resignFirstResponder];
    [self.passWordNew resignFirstResponder];
    [self.otherPassWord resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
