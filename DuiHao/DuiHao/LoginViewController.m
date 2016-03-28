//
//  LoginViewController.m
//  StudyAssisTant
//
//  Created by 王建男 on 15/3/8.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (instancetype)init{
	self = [super initWithNibName:@"LoginViewController" bundle:nil];
	if (self) {
		self.view.userInteractionEnabled = YES;
		self.control.userInteractionEnabled = YES;
		[self.control addTarget:self action:@selector(pressed) forControlEvents:UIControlEventTouchUpInside];
        self.keyBoardHight = KEYBOARDHIGHT;
	}
	return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    onceLogin.studentID = nil;
    onceLogin.imageURL = nil;
    onceLogin.sName = nil;
    onceLogin.version = nil;
    onceLogin.message = nil;
    [onceLogin writeToLocal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - private

- (void)keyboardWillHide:(NSNotification *)notification {
	
	self.control.top = 0;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect rect = [notification.userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    self.keyBoardHight = rect.size.height;
}


/**
 *  开始编辑输入框的时候，软键盘出现，执行此事件
 */

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    int offset =  textField.superview.origin.y + 40 - (self.control.size.height - self.keyBoardHight);
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    if(offset > 0)
        self.control.top = -offset;
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



- (void)pressed {
    
    [self.studentId resignFirstResponder];
    [self.studentPassword resignFirstResponder];
}

- (void)sendNetworkingTask {
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.schoolNumber, SCHOOLNUMBER,
                                                                          self.studentId.text, STUDENTID,
                                self.studentPassword.text, STUDENTPASSWORD, nil];
    [KVNProgress showWithStatus:@"正在登陆中"];
    [SANetWorkingTask requestWithPost:[SAURLManager login] parmater:dictionary block:^(id result) {
        
        if ([result[@"flag"] isEqualToString:@"001"] || [result[@"flag"] isEqualToString:@"003"]) {
            [KVNProgress showSuccessWithStatus:@"登陆成功"];
            
            OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
            onceLogin.studentID = self.studentId.text;
            onceLogin.imageURL = result[@"imageurl"];
            onceLogin.sName = result[@"sname"];
            onceLogin.version = result[@"version"];
            onceLogin.message = result[@"message"];
            onceLogin.passWord = self.studentPassword.text;
            
            NSDictionary *dic = result[@"ads"];
            onceLogin.adsImageURL = dic[@"imageName"];
            NSString *str = dic[@"state"];
            onceLogin.asdState = str.integerValue;
            
            [onceLogin writeToLocal];
            
            [self dismissViewControllerAnimated:YES completion:^{
            }];
            
        } else {
            [KVNProgress showErrorWithStatus:@"登陆失败"];
        }
       

    }];
}

- (IBAction)locationButtonDidPress:(id)sender {
    
    SearchViewController *search = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    search.delegate = self;
//    [search setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:search animated:YES completion:^{
    }];
}

- (IBAction)loginDidPress:(id)sender {
	
	if (!self.schoolNumber.length) {
		[KVNProgress showErrorWithStatus:@"请选择所在学校"];
		return;
	}
	
	if (!self.studentId.text.length) {
		[KVNProgress showErrorWithStatus:@"请输入学号"];
		return;
	}

	if (!self.studentPassword.text.length) {
		[KVNProgress showErrorWithStatus:@"请输入密码"];
		return;
	}
    
	[self sendNetworkingTask];
}


#pragma mark - getFileSizeForPath

- (long long) fileSizeAtPath:(NSString*) filePath{
	NSFileManager* manager = [NSFileManager defaultManager];
	if ([manager fileExistsAtPath:filePath]){
		return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
	}
	
	return 0;
}

- (float ) folderSizeAtPath:(NSString*) folderPath{
	NSFileManager* manager = [NSFileManager defaultManager];
	if (![manager fileExistsAtPath:folderPath]) return 0;
	NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
	NSString* fileName;
	long long folderSize = 0;
	while ((fileName = [childFilesEnumerator nextObject]) != nil){
		NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
		folderSize += [self fileSizeAtPath:fileAbsolutePath];
	}
	return folderSize/(1024.0*1024.0);
}

#pragma mark - SearchViewControllerDelegate

- (void)schoolAndNumber:(NSDictionary *)school {
    
    [self.schoolButton setTitle:school[SCHOOLNAME] forState:UIControlStateNormal];
    self.schoolNumber = school[SCHOOLNUMBER];
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    onceLogin.schoolName = school[SCHOOLNAME];
    onceLogin.schoolNumber = school[SCHOOLNUMBER];
}

@end
