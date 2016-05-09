//
//  SAURLManager.h
//  SAFramework
//
//  Created by 王建男 on 15/3/7.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAURLManager : NSObject


//登陆
+ (NSString *)loginURL;

//获取习题
+ (NSString *)downloadURL;

//获取考试是否开启
+ (NSString *)getExamStade;

//上传成绩
+ (NSString *)upScore;

//下载考试题
+ (NSString *)downloadExamURL;

/**
 *  主机域名
 */

+ (NSString *)hostDomain;

/**
 *  请求学校名称
 *  POST
 *  schoolCity:城市名称
 *  schoolName：学校名称
 *  当学校名称为空的时候返回城市内的所有大学
 */


+ (NSString *)querySchoolInfo;

/**
 * 注册
 * POST
 * studentPhone:手机号
 */

+ (NSString *)verifyRegister;

/**
 * 确认密码
 * POST
 * studentPhoneNum:手机号
 * studentPassword:密码
 */

+ (NSString *)affirmPassWorld;

/**
 *  登录
 *  POST
 *  schoolNumber:学校编号
 *  sid:学号
 *  spassword:密码
 */

+ (NSString *)login;

/**
 *  获取验证码
 *  POST
 *  studentPhoneNum:手机号
 */

+ (NSString *)captcha;

/**
 *  验证
 *  POST
 *  studentPhoneNum:手机号
 *  identifyingCode:验证码
 */

+ (NSString *)verify;

/**
 *  课程
 *  POST
 *  schoolNumber:学校编号
 *  sid:学号
 */

+ (NSString *)queryCourseInfo;

/**
 *  课程试题
 *  POST
 *  teacherName:教师别名
 *  curriculumName:课程别名
 */

+ (NSString *)downloadQuestion;

/**
 *  修改密码
 *  POST
 *  schoolNumber:学校编号
 *  studentNum:学生学号
 *  oldSecret:旧密码
 *  newSecret:新密码
 */

+ (NSString *)modifyStuSecret;

/**
 *  上传头像
 *  schoolNumber:学校编号
 *  studentNumber:学号
 *  imageName:图片名
 *  image:图片data 64编码字符串
 */

+ (NSString *)uploadPersonPic;

/**
 *  获取排名
 *  teacherName:教师别名
 *  curriculumName:课程别名
 */

+ (NSString *)myRanking;

/**
 *  检验是否开通考试
 *  teacherName:教师别名
 *  curriculumName:课程别名
 *  schoolNumber:学校编号
 *  sid:学号
 */

+ (NSString *)isOpenExam;

/**
 *  上传分数
 *  examSetId:考试ID
 *  schoolNumber:学校编号
 *  teacherName:教师别名
 *  curriculumName:课程别名
 *  sid:学号
 *  score:分数
 *  错题数组
 */

+ (NSString *)uploadScore;

@end
