//
//  LoginViewController.m
//  StudyAssisTant
//
//  Created by 王建男 on 15/3/8.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "UMMobClick/MobClick.h"

@interface LoginViewController ()<RegisterViewControllerDelegate>

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
    onceLogin.studentSex = nil;
    onceLogin.studentName = nil;
    onceLogin.studentPassword = nil;
    onceLogin.studentPhoneNum = nil;
    onceLogin.privacyState = nil;
    onceLogin.studentNumber = nil;
    onceLogin.organizationName = nil;
    onceLogin.organizationCode = nil;
    onceLogin.sessionId = @"";
    [onceLogin writeToLocal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setnLoginBtu];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - private

- (UIColor *)getColor:(NSString *)hexColor
{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}

- (void)setnLoginBtu {
 
    _LoginBtn.contentColor = [self getColor:@"ffffff"];
    _LoginBtn.progressColor = MAINCOLOR;
    
    [_LoginBtn.forDisplayButton setTitle:@"登录" forState:UIControlStateNormal];
    [_LoginBtn.forDisplayButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_LoginBtn.forDisplayButton setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    [_LoginBtn.forDisplayButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    
    //    [deformationBtn.forDisplayButton setImage:[UIImage imageNamed:@"logo_.png"] forState:UIControlStateNormal];
   // UIImage *bgImage = [UIImage imageNamed:@"LoginBG"];
   // [_LoginBtn.forDisplayButton setBackgroundImage:[bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];

    [_LoginBtn addTarget:self action:@selector(btnEvent) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnEvent{
    
    if (_LoginBtn.isLoading) {
        [self.studentId resignFirstResponder];
        [self.studentPassword resignFirstResponder];
        
        if (!self.studentId.text.length) {
            [KVNProgress showErrorWithStatus:@"请输入手机号"];
             [_LoginBtn setIsLoading:NO];
            return;
        }
        
        if (!self.studentPassword.text.length) {
            [KVNProgress showErrorWithStatus:@"请输入密码"];
            [_LoginBtn setIsLoading:NO];
            return;
        }
        
        [self sendNetworkingTask];
    } else {
        [SANetWorkingTask cancelAllOperations];
    }
    
   

    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
//    self.control.top = 0;
    self.controlTop.constant = 0;
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
    self.controlTop.constant = -offset;
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
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.studentId.text, STUDENTPHONENUM, [self.studentPassword.text md5ForString], STUDENTPASSWORD, nil];
   // [KVNProgress showWithStatus:@"正在登陆中"];
 
    [SANetWorkingTask requestWithPost:[SAURLManager login] parmater:dictionary blockOrError:^(id result, NSError *error) {
        
        if (error) {
            [_LoginBtn setIsLoading:NO];
            return ;
        }
        
        if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
            
            [KVNProgress showSuccessWithStatus:@"登陆成功"];
            result = result[RESULT];
            OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
            onceLogin.studentID = result[STUDENTID];
            onceLogin.imageURL = result[IMAGEURL];
            onceLogin.studentSex = result[STUDENTSEX];
            onceLogin.studentName = result[STUDENTNAME];
            onceLogin.studentPassword = self.studentPassword.text;
            onceLogin.studentPhoneNum = self.studentId.text;
            onceLogin.privacyState = result[PRIVACYSTATE];
            onceLogin.studentNumber = result[STUDENTNUMBER];
            onceLogin.organizationName = result[ORGANIZATIONNAME];
            onceLogin.organizationCode = result[ORGANIZATIONCODE];
            onceLogin.sessionId = result[SESSIONID];
            
            [onceLogin writeToLocal];
            // 当用户登录时统计信息
            [MobClick profileSignInWithPUID:self.studentId.text];
            
            [self dismissViewControllerAnimated:YES completion:^{
            }];
            
        } else {
            [KVNProgress showErrorWithStatus:@"账号或密码错误"];
             [_LoginBtn setIsLoading:NO];
        }
    }];
}

- (IBAction)loginDidPress:(id)sender {
	
    [self.studentId resignFirstResponder];
    [self.studentPassword resignFirstResponder];
    
	if (!self.studentId.text.length) {
		[KVNProgress showErrorWithStatus:@"请输入手机号"];
		return;
	}

	if (!self.studentPassword.text.length) {
		[KVNProgress showErrorWithStatus:@"请输入密码"];
		return;
	}
    
	[self sendNetworkingTask];
}

- (IBAction)registerAction:(id)sender {
    
    RegisterViewController *res = [[RegisterViewController alloc] initRegister];
    res.delegate = self;
    [self presentViewController:res animated:YES completion:^{
    }];
    
}

- (IBAction)getPasswordAction:(id)sender {
    
    RegisterViewController *res = [[RegisterViewController alloc] initGetPassword];
    res.delegate = self;
    [self presentViewController:res animated:YES completion:^{
    }];
}

#pragma mark - RegisterViewControllerDelegate

- (void)setPhoneNumAndPassWorld:(NSString *)phoneNum withpassWorld:(NSString *)passworld {
    self.studentId.text = phoneNum;
    self.studentPassword.text = passworld;
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

//- (void)schoolAndNumber:(NSDictionary *)school {
//    
//    [self.schoolButton setTitle:school[SCHOOLNAME] forState:UIControlStateNormal];
//    [self.schoolButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    
//    self.schoolNumber = school[SCHOOLNUMBER];
//    
//    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
//    onceLogin.schoolName = school[SCHOOLNAME];
//    onceLogin.schoolNumber = school[SCHOOLNUMBER];
//}

@end
