//
//  OnlyLogin.h
//  单例登陆
//
//  Created by 王建男 on 14/10/21.
//  Copyright (c) 2014年 WJN_work@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OnceLogin : NSObject<NSCoding>
// 老版个人信息
@property (copy, nonatomic) NSString *schoolName;
@property (copy, nonatomic) NSString *schoolNumber;
@property (copy, nonatomic) NSString *passWord;
@property (copy, nonatomic) NSString *sName;
@property (copy, nonatomic) NSString *version;
@property (strong, nonatomic) NSArray *message;
@property (strong, nonatomic) NSString *adsImageURL;
@property (assign, nonatomic) NSInteger asdState;

// 学生ID
@property (copy, nonatomic) NSString *studentID;
// 学生头像
@property (copy, nonatomic) NSString *imageURL;

// V1.0 个人信息
// 返回结果
@property (copy, nonatomic) NSString *returnCode;
// 错误编码
@property (copy, nonatomic) NSString *errorCode;
// 错误描述
@property (copy, nonatomic) NSString *errorMsg;
// 学生姓名
@property (copy, nonatomic) NSString *studentName;
// 密码
@property (copy, nonatomic) NSString *studentPassword;
// 学生用户手机号
@property (copy, nonatomic) NSString *studentPhoneNum;
// 隐藏标识
@property (copy, nonatomic) NSString *privacyState;
// 学生学号
@property (copy, nonatomic) NSString *studentNumber;
// 机构名称
@property (copy, nonatomic) NSString *organizationName;
// 所属机构
@property (copy, nonatomic) NSString *organizationCode;

+ (OnceLogin *)getOnlyLogin;
- (void)writeToLocal;

@end
