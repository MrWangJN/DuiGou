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

+ (NSString *)innterface;

/**
 *  请求学校名称
 *  POST
 *  ORGANIZATIONNAME:机构名称
 *  当学校名称为空的时候返回城市内的所有大学
 */


+ (NSString *)querySchoolInfo;

/**
 *  请求学校名称 - 根据城市
 *  POST
 *  cityName:城市名称
 *  当学校名称为空的时候返回城市内的所有大学
 */

+ (NSString *)querySchoolInfoForCity;

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
 * 添加课程
 * POST
 * studentId:学生ID
 * studentNumber:学号
 * organizationCode:机构编码
 * coursePassword:课程码
 */

+ (NSString *)addCourse;

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
 *  teacherId:教师ID
 *  courseId:课程ID
 */

+ (NSString *)downloadQuestion;

/**
 *  修改密码
 *  POST
 *  studentID:学生学号
 *  oldPassword:旧密码
 *  newPassWord:新密码
 */

+ (NSString *)modifyStuSecret;

/**
 *  上传头像
 *  POST
 *  schoolNumber:学校编号
 *  studentNumber:学号
 *  imageName:图片名
 *  image:图片data 64编码字符串
 */

+ (NSString *)uploadPersonPic;

/*
 * 绑定个人信息
 * POST
 * studentId:学生id
 * infoFalg:个人信息标示 - 00代表上传姓名，01代表性别，02代表手机号，03代表学校，04代表学号。
 * studentInfo:个人信息 
 */

+ (NSString *)bindInformation;

/**
 * 更改排行榜权限
 * POST
 * studentId:学生id
 * privacyState:权限 1-开启   2-关闭
 */

+ (NSString *)changePrivacyState;

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
 *  examId:考试ID
 *  studentId:学生Id
 *  teacherId:教师Id
 *  courseId:课程id
 *  teachingId:教学Id
 *  score:分数
 *  errorQuestion:错题数组
 */

+ (NSString *)uploadScore;

/*
 * 获取消息
 * studentId：学生id
 */

+ (NSString *)getMessage;

/*
 * 签到
 * studentId：学生id
 * attendanceId:签到ID
 * deviceNumber:终端设备标识
 * studentNumber：学生学号
 * qrcodeNumber:二维码Id
 */

+ (NSString *)qrcodeSignIn;

/*
 * 版本更新
 *requestSource:设备类型
 */

+ (NSString *)requestSource;

/*
 * 上传练习时长与成绩
 * studentId：学生id
 * courseId:课程id
 * addScoreFlag:加分标示 00-时长 01-考试分数
 * examScore:本地模拟分数
 * time:本地练习时长
 */

+ (NSString *)studentCourseScore;

@end
