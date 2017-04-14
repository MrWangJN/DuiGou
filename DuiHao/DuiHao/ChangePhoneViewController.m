//
//  ChangePhoneViewController.m
//  DuiHao
//
//  Created by wjn on 2016/10/31.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "ChangePhoneViewController.h"
#import "OnceLogin.h"

@interface ChangePhoneViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *phoneNum;
@property (strong, nonatomic) IBOutlet UITextField *captcha;
@property (strong, nonatomic) IBOutlet UIButton *getCaocha;

@end

@implementation ChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.getCaocha.layer.borderColor = MAINCOLOR.CGColor;
    
    self.phoneNum.returnKeyType = UIReturnKeyDone;
    self.phoneNum.delegate = self;
    
    self.captcha.returnKeyType = UIReturnKeyDone;
    self.captcha.delegate = self;
    
    self.navigationItem.title = @"更绑手机号";
}

- (IBAction)catchAction:(id)sender {
    
    [self.phoneNum resignFirstResponder];
    [self.captcha resignFirstResponder];
    
    if (!self.phoneNum.text.length) {
//        [KVNProgress showErrorWithStatus:@"请输入手机号"];
        [JKAlert alertText:@"请输入手机号"];
        return;
    }
    if (![RegularExpression affirmPhoneNum:self.phoneNum.text]) {
//        [KVNProgress showErrorWithStatus:@"手机号格式不正确"];
        [JKAlert alertText:@"手机号格式不正确"];
        return;
    }
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    
    if ([self.phoneNum.text isEqualToString:onceLogin.studentPhoneNum]) {
//        [KVNProgress showErrorWithStatus:@"与当前使用手机号相同"];
        [JKAlert alertText:@"与当前使用手机号相同"];
        return;
    }
    
    self.getCaocha.userInteractionEnabled = NO;
    
    __block int timeout = 60;
    [self.getCaocha setTitleColor:[UIColor colorWithWhite:0.5 alpha:0.8] forState:UIControlStateNormal];
    self.getCaocha.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.8].CGColor;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //                [self buttonDidPress:self.button];
                [self.getCaocha setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self.getCaocha setTitleColor:MAINCOLOR forState:UIControlStateNormal];
                self.getCaocha.layer.borderColor = MAINCOLOR.CGColor;
                self.getCaocha.userInteractionEnabled = YES;
            });
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.getCaocha setTitle:[NSString stringWithFormat:@"%ds", timeout % 60] forState:UIControlStateNormal];
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.phoneNum.text, STUDENTPHONENUM, nil];
    [SANetWorkingTask requestWithPost:[SAURLManager captcha] parmater:dictionary blockOrError:^(id result, NSError *error) {
        
        if (error) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.getCaocha setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self.getCaocha setTitleColor:MAINCOLOR forState:UIControlStateNormal];
                self.getCaocha.layer.borderColor = MAINCOLOR.CGColor;
                self.getCaocha.userInteractionEnabled = YES;
            });
            return ;
        }
        
        if (![result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
            
            [KVNProgress showErrorWithStatus:result[ERRORMESSAGE]];
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.getCaocha setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self.getCaocha setTitleColor:MAINCOLOR forState:UIControlStateNormal];
                self.getCaocha.layer.borderColor = MAINCOLOR.CGColor;
                self.getCaocha.userInteractionEnabled = YES;
            });
            return ;
        }
    }];

}

- (IBAction)confirmAction:(id)sender {
    
    [self.phoneNum resignFirstResponder];
    [self.captcha resignFirstResponder];
    
    if (!self.phoneNum.text.length) {
//        [KVNProgress showErrorWithStatus:@"请输入手机号"];
        [JKAlert alertText:@"请输入手机号"];
    }
    if (![RegularExpression affirmPhoneNum:self.phoneNum.text]) {
//        [KVNProgress showErrorWithStatus:@"手机号格式不正确"];
        [JKAlert alertText:@"手机号格式不正确"];
        return;
    }
 
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    
    NSString *identifyingCode = @"02";
    
    [SANetWorkingTask requestWithPost:[SAURLManager bindInformation] parmater:@{STUDENTID: onceLogin.studentID,INFOFLAG: PHONE, STUDENTINFO: self.phoneNum.text, IDENTIFYINGCODE : identifyingCode} block:^(id result) {
        [KVNProgress dismiss];
        if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
            onceLogin.studentPhoneNum = self.phoneNum.text;
            [onceLogin writeToLocal];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
//            [KVNProgress showErrorWithStatus:result[ERRORMESSAGE]];
            [JKAlert alertText:result[ERRORMESSAGE]];
        }
    }];
}

- (void)backBtuDidPress {
    [self.phoneNum resignFirstResponder];
    [self.captcha resignFirstResponder];
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
