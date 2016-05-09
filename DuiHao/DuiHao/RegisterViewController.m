//
//  RegisterViewController.m
//  DuiHao
//
//  Created by wjn on 16/3/31.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "RegisterViewController.h"
#import "PassWordViewController.h"

@interface RegisterViewController ()<PassWordViewControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *phoneNum;
@property (strong, nonatomic) IBOutlet UITextField *captcha;
@property (strong, nonatomic) IBOutlet UIButton *getCaocha;

@property (strong, nonatomic) IBOutlet UINavigationBar *navtigationbar;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.getCaocha.layer.borderColor = MAINCOLOR.CGColor;
    
    self.phoneNum.returnKeyType = UIReturnKeyDone;
    self.phoneNum.delegate = self;
    
    self.captcha.returnKeyType = UIReturnKeyDone;
    self.captcha.delegate = self;
}

- (IBAction)caotchaAction:(id)sender {
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.phoneNum.text, STUDENTPHONENUM, nil];
//    [KVNProgress showWithStatus:@"正在登陆中"];
    // 测试
    //    [self dismissViewControllerAnimated:YES completion:^{
    //    }];
    [SANetWorkingTask requestWithPost:[SAURLManager captcha] parmater:dictionary block:^(id result) {
        
        NSLog(@"%@", result);
        
//        if ([result[@"retCode"] isEqualToString:@"0001"]) {
//            NSLog(@"");
//        }
    }];
}

- (IBAction)submitAction:(id)sender {
    
    if (!self.phoneNum.text.length) {
        [KVNProgress showErrorWithStatus:@"请输入手机号"];
    }
    if (![RegularExpression affirmPhoneNum:self.phoneNum.text]) {
         [KVNProgress showErrorWithStatus:@"手机号格式不正确"];
        return;
    }
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.phoneNum.text, STUDENTPHONENUM, self.captcha.text, IDENTIFYINGCODE,nil];
    [KVNProgress showWithStatus:@"正在登陆中"];
    // 测试
    //    [self dismissViewControllerAnimated:YES completion:^{
    //    }];
    [SANetWorkingTask requestWithPost:[SAURLManager verify] parmater:dictionary block:^(id result) {
        
            if ([result[@"retCode"] isEqualToString:@"0001"]) {
                PassWordViewController *pwVC = [[PassWordViewController alloc] initWithPhoneNum:self.phoneNum.text];
                pwVC.delegate = self;
                [self presentViewController:pwVC animated:YES completion:^{
                }];
            } else {
                [KVNProgress showErrorWithStatus:result[@"errMsg"]];
            }
    }];
    
 
    
}

-(void)phoneNumAndpassWorld:(NSString *)passWorld {
    [self.delegate setPhoneNumAndPassWorld:self.phoneNum.text withpassWorld:passWorld];
}


#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.phoneNum resignFirstResponder];
    [self.captcha resignFirstResponder];
    return YES;
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
