//
//  PassWordViewController.m
//  DuiHao
//
//  Created by wjn on 16/4/4.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "PassWordViewController.h"
#import "KVNProgress.h"

@interface PassWordViewController ()

@property (strong, nonatomic) IBOutlet UITextField *passWorldTF;
@property (strong, nonatomic) IBOutlet UITextField *againPassWorldTF;
@property (copy, nonatomic) NSString *phoneNum;
@property (strong, nonatomic) IBOutlet UINavigationBar *getCaocha;
@property (weak, nonatomic) IBOutlet UINavigationItem *navtigationItem;

@end

@implementation PassWordViewController

- (instancetype)initWithPhoneNum:(NSString *)phoneNum withType:(GetType )type
{
    self = [super init];
    if (self) {
        self.phoneNum = phoneNum;
        self.getType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.getCaocha.layer.borderColor = MAINCOLOR.CGColor;
    
    if (self.getType == GetPassword) {
        self.navtigationItem.title = @"重置密码";
    }
}

- (IBAction)affirmAction:(id)sender {
    
    [self.passWorldTF resignFirstResponder];
    [self.againPassWorldTF resignFirstResponder];
    
    if (!_passWorldTF.text.length && !_againPassWorldTF.text.length) {
//        [KVNProgress showErrorWithStatus:@"密码不能为空"];
        [JKAlert alertText:@"密码不能为空"];
        return;
    }
    
    if (![self.passWorldTF.text isEqualToString:self.againPassWorldTF.text]) {
//        [KVNProgress showErrorWithStatus:@"密码输入不一致"];
        [JKAlert alertText:@"密码输入不一致"];
    }
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.phoneNum, STUDENTPHONENUM, [self.passWorldTF.text md5ForString], STUDENTPASSWORD, self.getType == GetPassword ? @"01" : @"00", FLAG, nil];
    
    if (self.getType == GetPassword) {
//        [KVNProgress showWithStatus:@"正在修改密码"];
        [JKAlert alertWaitingText:@"正在修改密码"];
    } else {
//        [KVNProgress showWithStatus:@"正在注册"];
        [JKAlert alertWaitingText:@"正在注册"];
    }

    [SANetWorkingTask requestWithPost:[SAURLManager affirmPassWorld] parmater:dictionary block:^(id result) {
        
        [JK_M dismissElast];
        
        if ([result[@"retCode"] isEqualToString:@"0001"]) {
    
            if (self.getType == GetPassword) {
//                [KVNProgress showSuccessWithStatus:@"成功修改密码"];
                [JKAlert alertText:@"修改密码成功"];
            } else {
//                [KVNProgress showSuccessWithStatus:@"注册成功"];
                [JKAlert alertText:@"注册成功"];
            }
            
             [self.delegate phoneNumAndpassWorld:self.passWorldTF.text];
            
            if ([self respondsToSelector:@selector(presentingViewController)]){
                [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }
            else {
                [self.parentViewController.parentViewController dismissViewControllerAnimated:YES completion:^{
                }];
            }
        } else {
            if (self.getType == GetPassword) {
//                [KVNProgress showErrorWithStatus:@"修改密码失败"];
                [JKAlert alertText:@"修改密码失败"];
            } else {
//                [KVNProgress showErrorWithStatus:@"注册失败"];
                [JKAlert alertText:@"注册失败"];
            }
        }
    }];
}

- (void)backBtuDidPress {
    [self.passWorldTF resignFirstResponder];
    [self.againPassWorldTF resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
