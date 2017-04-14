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

@interface LoginViewController ()<RegisterViewControllerDelegate> {
    LoginShowType showType;
}

@property (strong, nonatomic) UIImageView* imgLeftHand;
@property (strong, nonatomic) UIImageView* imgRightHand;
@property (weak, nonatomic) IBOutlet UIImageView *headerIMageView;

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

    [JK_M dismissElast];
    
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
    
    [self.control addSubview:self.imgLeftHand];
    [self.control sendSubviewToBack:self.imgLeftHand];
    [self.control addSubview:self.imgRightHand];
    [self.control sendSubviewToBack:self.imgRightHand];
    
    [self.control sendSubviewToBack:self.headerIMageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - private

- (UIImageView *)imgLeftHand {
    if (!_imgLeftHand) {
//        self.imgLeftHand = [[UIImageView alloc] initWithFrame:CGRectMake(self.headerIMageView.center.x - 40, 90, 25, 75)];
        self.imgLeftHand = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_CENTER.x - 70, self.headerIMageView.bottom - 10, 25, 75)];
//        _imgLeftHand.bottom = self.headerIMageView.bottom;
        _imgLeftHand.image = [UIImage imageNamed:@"login_arm_left"];
    }
    return _imgLeftHand;
}

- (UIImageView *)imgRightHand {
    if (!_imgRightHand) {
//        self.imgRightHand = [[UIImageView alloc] initWithFrame:CGRectMake(self.headerIMageView.center.x + 15, 90, 25, 75)];
        self.imgRightHand = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_CENTER.x + 45, self.headerIMageView.bottom - 10, 25, 75)];
//        _imgRightHand.bottom = self.headerIMageView.bottom;
        _imgRightHand.image = [UIImage imageNamed:@"login_arm_right"];
    }
    return _imgRightHand;
}

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
 
    _LoginBtn.contentColor = [self getColor:@"1994fa"];
    _LoginBtn.progressColor = [self getColor:@"ffffff"];
    
    [_LoginBtn.forDisplayButton setTitle:@"登录" forState:UIControlStateNormal];
    [_LoginBtn.forDisplayButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_LoginBtn.forDisplayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
            [JKAlert alertText:@"请输入手机号"];
             [_LoginBtn setIsLoading:NO];
            return;
        }
        
        if (!self.studentPassword.text.length) {
            [JKAlert alertText:@"请输入密码"];
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
    
    int offset = self.LoginBtn.superview.bottom - (self.control.size.height - self.keyBoardHight) - 20;
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    if(offset > 0)
    self.controlTop.constant = -offset;
    [UIView commitAnimations];
    
    if ([textField isEqual:self.studentId]) {
        if (showType != LoginShowType_PASS)
        {
            showType = LoginShowType_USER;
            return;
        }
        showType = LoginShowType_USER;
        [self.headerIMageView setImage:[UIImage imageNamed:@"login"]];
        [UIView animateWithDuration:0.5 animations:^{
            self.imgLeftHand.frame = CGRectMake(self.imgLeftHand.frame.origin.x - 30, self.imgLeftHand.frame.origin.y + 60, self.imgLeftHand.frame.size.width, self.imgLeftHand.frame.size.height);
            
            self.imgRightHand.frame = CGRectMake(self.imgRightHand.frame.origin.x + 30, self.imgRightHand.frame.origin.y + 60, self.imgRightHand.frame.size.width, self.imgRightHand.frame.size.height);
            
        } completion:^(BOOL b) {
        }];
        
    }
    else if ([textField isEqual:self.studentPassword]) {
        if (showType == LoginShowType_PASS)
        {
            showType = LoginShowType_PASS;
            return;
        }
        showType = LoginShowType_PASS;
        [self.headerIMageView setImage:[UIImage imageNamed:@"login_closed"]];
        [UIView animateWithDuration:0.5 animations:^{
            self.imgLeftHand.frame = CGRectMake(self.imgLeftHand.frame.origin.x + 30, self.imgLeftHand.frame.origin.y - 60, self.imgLeftHand.frame.size.width, self.imgLeftHand.frame.size.height);
            self.imgRightHand.frame = CGRectMake(self.imgRightHand.frame.origin.x - 30, self.imgRightHand.frame.origin.y - 60, self.imgRightHand.frame.size.width, self.imgRightHand.frame.size.height);
            
        } completion:^(BOOL b) {
        }];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.studentPassword]) {
        if (showType == LoginShowType_PASS)
        {
            showType = LoginShowType_USER;
            [self.headerIMageView setImage:[UIImage imageNamed:@"login"]];
            [UIView animateWithDuration:0.5 animations:^{
                self.imgLeftHand.frame = CGRectMake(self.imgLeftHand.frame.origin.x - 30, self.imgLeftHand.frame.origin.y + 60, self.imgLeftHand.frame.size.width, self.imgLeftHand.frame.size.height);
                
                self.imgRightHand.frame = CGRectMake(self.imgRightHand.frame.origin.x + 30, self.imgRightHand.frame.origin.y + 60, self.imgRightHand.frame.size.width, self.imgRightHand.frame.size.height);
                
            } completion:^(BOOL b) {
            }];
            
        }
    }
    
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
            
//            [KVNProgress showSuccessWithStatus:@"登陆成功"];
            [JKAlert alertText:@"登陆成功"];
            result = result[RESULT];
            result = result[USER];
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
            
            if ([self.delegate respondsToSelector:@selector(loginInSuccess)]) {
                [self.delegate loginInSuccess];
            }
            
            [self dismissViewControllerAnimated:YES completion:^{
            }];
            
        } else {
//            [KVNProgress showErrorWithStatus:@"账号或密码错误"];
            [JKAlert alertText:@"账号或密码错误"];
             [_LoginBtn setIsLoading:NO];
        }
    }];
}

- (IBAction)loginDidPress:(id)sender {
	
    [self.studentId resignFirstResponder];
    [self.studentPassword resignFirstResponder];
    
	if (!self.studentId.text.length) {
        [JKAlert alertText:@"请输入手机号"];
		return;
	}

	if (!self.studentPassword.text.length) {
        [JKAlert alertText:@"请输入密码"];
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

@end
