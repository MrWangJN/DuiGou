//
//  ChangeInformationViewController.m
//  DuiHao
//
//  Created by wjn on 16/5/7.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "ChangeInformationViewController.h"
#import "OnceLogin.h"


@interface ChangeInformationViewController ()

@property (strong, nonatomic) IBOutlet UITextField *contentTF;
@property (assign, nonatomic) ChangeInformationType type;

@property (strong, nonatomic) NSString *content;
@property (assign, nonatomic) UIKeyboardType keyboardType;

@end

@implementation ChangeInformationViewController

- (instancetype)initWithType:(ChangeInformationType )type withTitle:(NSString *)title whitContent:(NSString *)content withKeyboardType:(UIKeyboardType)keyboardType {
    self = [super init];
    if (self) {
        self.type = type;
        [self.navigationItem setTitle:title];
        
        self.content = content;
        self.keyboardType = keyboardType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    if (self.content) {
        self.contentTF.text = self.content;
    }
    
    self.contentTF.keyboardType = self.keyboardType;
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)buttonDidPress:(id)sender {

    [self.contentTF resignFirstResponder];
    
    if (!self.contentTF.text.length) {
//        [KVNProgress showErrorWithStatus:@"请输入信息"];
        [JKAlert alertText:@"请输入信息"];
        return;
    }
    
    NSString *uploadType;
    
    switch (self.type) {
        case StudentName:
            uploadType = NAME;
//            [KVNProgress showWithStatus:@"正在绑定姓名"];
            [JKAlert alertWaitingText:@"正在绑定姓名"];
            break;
        case StudentNumber:
            uploadType = NUMBER;
//            [KVNProgress showWithStatus:@"正在绑定学号"];
             [JKAlert alertWaitingText:@"正在绑定学号"];
            break;
        default:
            break;
    }
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    [SANetWorkingTask requestWithPost:[SAURLManager bindInformation] parmater:@{STUDENTID: onceLogin.studentID,INFOFLAG: uploadType, STUDENTINFO: self.contentTF.text, IDENTIFYINGCODE : @"0000"} block:^(id result) {
//        [KVNProgress dismiss];
        [JK_M dismissElast];
        if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
            switch (self.type) {
                case StudentName:
                    onceLogin.studentName = self.contentTF.text;
                    break;
                case StudentNumber:
                    onceLogin.studentNumber = self.contentTF.text;
                    break;
                default:
                    break;
            }
            
            [onceLogin writeToLocal];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [KVNProgress showErrorWithStatus:result[ERRORMESSAGE]];
        }
        
    }];
    
}

- (void)backBtuDidPress {
    [self.contentTF resignFirstResponder];
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
