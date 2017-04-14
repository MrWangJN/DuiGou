//
//  RegisterViewController.m
//  DuiHao
//
//  Created by wjn on 16/3/31.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "RegisterViewController.h"
#import "OnceLogin.h"

@interface RegisterViewController ()<PassWordViewControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *phoneNum;
@property (strong, nonatomic) IBOutlet UITextField *captcha;
@property (strong, nonatomic) IBOutlet UIButton *getCaocha;

@property (strong, nonatomic) IBOutlet UINavigationBar *navtigationbar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navtigationItem;

@end

@implementation RegisterViewController

- (instancetype)initGetPassword
{
    self = [super init];
    if (self) {
        self.getType = GetPassword;
    }
    return self;
}

- (instancetype)initRegister
{
    self = [super init];
    if (self) {
        self.getType = Register;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.getCaocha.layer.borderColor = MAINCOLOR.CGColor;
    
    self.phoneNum.returnKeyType = UIReturnKeyDone;
    self.phoneNum.delegate = self;
    
    self.captcha.returnKeyType = UIReturnKeyDone;
    self.captcha.delegate = self;
    
    if (self.getType == GetPassword) {
        self.navtigationItem.title = @"忘记密码";
    }
    
}

- (IBAction)backBtnAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
}

- (IBAction)caotchaAction:(id)sender {
    
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
                
                //设置界面的按钮显示 根据自己需求设置
//                [self.timeLabel setNewText:[NSString stringWithFormat:@"%ds", timeout % 60]];
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

- (IBAction)submitAction:(id)sender {
    
    [self.phoneNum resignFirstResponder];
    [self.captcha resignFirstResponder];
    
    if (!self.phoneNum.text.length) {
//        [KVNProgress showErrorWithStatus:@"请输入手机号"];
        [JKAlert alertText:@"请输入手机号"];
        return;
    }
    if (![RegularExpression affirmPhoneNum:self.phoneNum.text]) {
//         [KVNProgress showErrorWithStatus:@"手机号格式不正确"];
        [JKAlert alertText:@"手机号格式不正确"];
        return;
    }
    
    if (!self.captcha.text.length) {
//        [KVNProgress showErrorWithStatus:@"请输入验证码"];
        [JKAlert alertText:@"请输入验证码"];
        return;
    }
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.phoneNum.text, STUDENTPHONENUM, self.captcha.text, IDENTIFYINGCODE, self.getType == GetPassword ? @"01" : @"00", FLAG, nil];
    
    if (self.getType == GetPassword) {
//        [KVNProgress showWithStatus:@"正在验证中"];
        [JKAlert alertWaitingText:@"正在验证中"];
    } else {
//        [KVNProgress showWithStatus:@"正在注册中"];
         [JKAlert alertWaitingText:@"正在注册中"];
    }
    
    [SANetWorkingTask requestWithPost:[SAURLManager verify] parmater:dictionary block:^(id result) {
        
        [JKAlert alertWaiting:NO];
        
        if ([result[@"retCode"] isEqualToString:@"0001"]) {
            PassWordViewController *pwVC = [[PassWordViewController alloc] initWithPhoneNum:self.phoneNum.text withType:self.getType];
            pwVC.delegate = self;
            [self presentViewController:pwVC animated:YES completion:^{
            }];
        } else {
            [JKAlert alertText:result[@"errMsg"]];
//            [KVNProgress showErrorWithStatus:result[@"errMsg"]];
        }
    }];    
}

-(void)phoneNumAndpassWorld:(NSString *)passWorld {
    [self.delegate setPhoneNumAndPassWorld:self.phoneNum.text withpassWorld:passWorld];
}


- (void)backBtuDidPress {
    [self.phoneNum resignFirstResponder];
    [self.captcha resignFirstResponder];
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
