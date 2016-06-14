//
//  AddCourseViewController.m
//  DuiHao
//
//  Created by wjn on 16/6/12.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "AddCourseViewController.h"
#import "OnceLogin.h"

@interface AddCourseViewController ()

@property (strong, nonatomic) IBOutlet UITextField *courseNUmTF;

@end

@implementation AddCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)addCourseDidPress:(id)sender {
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    [self.navigationItem setTitle:@"添加课程"];
    
    if ([onceLogin.studentNumber isEqualToString:@"未绑定"]) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert addButton:@"确定" actionBlock:^{
            
        }];
        [alert showError:self title:@"添加课程失败" subTitle:@"您未绑定学号" closeButtonTitle:nil duration:0.0f];
        return;
    } else if ([onceLogin.organizationCode isEqualToString:@"未绑定"]) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert addButton:@"确定" actionBlock:^{
            
        }];
        [alert showError:self title:@"添加课程失败" subTitle:@"您未绑定学校" closeButtonTitle:nil duration:0.0f];
        return;
    } else if (!self.courseNUmTF.text.length) {
        [KVNProgress showErrorWithStatus:@"请输入课程编号"];
        return;
    }
    
    
    
    [SANetWorkingTask requestWithPost:[SAURLManager addCourse] parmater:@{STUDENTID: onceLogin.studentID, STUDENTNUMBER: onceLogin.studentNumber, ORGANIZATIONCODE: onceLogin.organizationCode, COURSEPASSWORD: self.courseNUmTF.text} block:^(id result) {
        
        if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
            
            onceLogin.addCourseState = true;
            [onceLogin writeToLocal];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        } else {
           [KVNProgress showErrorWithStatus:@"添加课程失败"];
//            [KVNProgress showErrorWithStatus:result[@"errMsg"]];
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