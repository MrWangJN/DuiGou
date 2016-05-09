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

@end

@implementation PassWordViewController

- (instancetype)initWithPhoneNum:(NSString *)phoneNum
{
    self = [super init];
    if (self) {
        self.phoneNum = phoneNum;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.getCaocha.layer.borderColor = MAINCOLOR.CGColor;
}

- (IBAction)affirmAction:(id)sender {
    
    if (!_passWorldTF.text.length && !_againPassWorldTF.text.length) {
        [KVNProgress showErrorWithStatus:@"密码不能为空"];
        return;
    }
    
    if (![self.passWorldTF.text isEqualToString:self.againPassWorldTF.text]) {
        [KVNProgress showErrorWithStatus:@"密码输入不一致"];
    }
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.phoneNum, STUDENTPHONENUM, [self.passWorldTF.text md5ForString], STUDENTPASSWORD, nil];
    [KVNProgress showWithStatus:@"正在注册"];
    [SANetWorkingTask requestWithPost:[SAURLManager affirmPassWorld] parmater:dictionary block:^(id result) {
        
        if ([result[@"retCode"] isEqualToString:@"0001"]) {
            [KVNProgress showSuccessWithStatus:@"注册成功"];
            
            
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
            [KVNProgress showErrorWithStatus:@"注册失败"];
        }
    }];
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
