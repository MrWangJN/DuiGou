//
//  SAURLManager.m
//  SAFramework
//
//  Created by 王建男 on 15/3/7.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAURLManager.h"


@implementation SAURLManager

+ (NSString *)loginURL {
	return @"http://121.42.144.101/mteaching/Mobile/login/teacherName/teachername/curriculumName/curriculumname/studentNum/studentnum";
}

+ (NSString *)downloadURL {
	return @"http://121.42.144.101/mteaching/Mobile/downloadQuestion/teacherName/teachername/curriculumName/curriculumname/questionName/questionname";
}

+ (NSString *)getExamStade {
	return @"http://121.42.144.101/mteaching/Mobile/isOpenExam/teacherName/teachername/curriculumName/curriculumname";
}

+ (NSString *)upScore {
	return @"http://121.42.144.101/mteaching/Mobile/uploadScore/teacherName/teachername/curriculumName/curriculumname/studentNum/studentnum/score/SCORE/time/TIME";
}

+ (NSString *)downloadExamURL {
	return @"http://121.42.144.101/mteaching/Mobile/downloadExamQuestion/teacherName/teachername/curriculumName/curriculumname/questionName/questionname";
}

+ (NSString *)hostDomain {
    return @"http://121.42.144.101/Api";
}

+ (NSString *)local {
//    return @"http://192.168.1.104:8080/mteach/mteach/api.php";
    return @"http://60.205.211.116/Api";
}

+ (NSString *)innterface {
    
    BOOL test = YES;
    
    if (test) {
        return [self local];
    } else {
        return [self hostDomain];
    }
}

+ (NSString *)querySchoolInfo {
    return [NSString stringWithFormat:@"%@/School/getOrganizationForName", [self innterface]];
}

+ (NSString *)querySchoolInfoForCity {
    return [NSString stringWithFormat:@"%@/School/getOrganizationForCity", [self innterface]];
}

+ (NSString *)login {
    return [NSString stringWithFormat:@"%@/user/login", [self innterface]];
}

+ (NSString *)verify {
    return [NSString stringWithFormat:@"%@/user/verifyRegister", [self innterface]];
}

+ (NSString *)addCourse {
    return [NSString stringWithFormat:@"%@/course/addCourse", [self innterface]];
}

+ (NSString *)captcha {
    return [NSString stringWithFormat:@"%@/user/getCheckCode", [self innterface]];
}

+ (NSString *)verifyRegister {
    return [NSString stringWithFormat:@"%@/user/register", [self innterface]];
}

+ (NSString *)affirmPassWorld {
    return [NSString stringWithFormat:@"%@/user/registerOrReset", [self innterface]];
}

+ (NSString *)queryCourseInfo {
    return [NSString stringWithFormat:@"%@/Course/lists", [self innterface]];
}

+ (NSString *)modifyStuSecret {
    return [NSString stringWithFormat:@"%@/user/changePassword", [self innterface]];
}

+ (NSString *)downloadQuestion {
    return [NSString stringWithFormat:@"%@/course/question", [self innterface]];
}

+ (NSString *)uploadPersonPic {
    return [NSString stringWithFormat:@"%@/user/uploadPersonPic", [self innterface]];
}

+ (NSString *)bindInformation {
    return [NSString stringWithFormat:@"%@/user/bindInformation", [self innterface]];
}

+ (NSString *)changePrivacyState {
    return [NSString stringWithFormat:@"%@/user/changePrivacyState", [self innterface]];
}

+ (NSString *)myRanking {
    return [NSString stringWithFormat:@"%@/course/studentCourseTop", [self innterface]];
}

+ (NSString *)isOpenExam {
    return [NSString stringWithFormat:@"%@/Exam/getOpenExam", [self innterface]];
}

+ (NSString *)uploadScore {
    return [NSString stringWithFormat:@"%@/Exam/submitScoreData", [self innterface]];
}

+ (NSString *)getMessage {
    return [NSString stringWithFormat:@"%@/Message/messageList", [self innterface]];
}

+ (NSString *)qrcodeSignIn {
    return [NSString stringWithFormat:@"%@/SignIn/studentSignIn", [self innterface]];
}

+ (NSString *)requestSource {
    return [NSString stringWithFormat:@"%@/App/update", [self innterface]];
}

+ (NSString *)studentCourseScore {
    return [NSString stringWithFormat:@"%@/course/studentCourseScore", [self innterface]];
}

+ (NSString *)getTodayHistory {
    return @"http://v.juhe.cn/todayOnhistory/queryEvent.php";
}

+ (NSString *)getTodayHistoryDetail {
    return @"http://v.juhe.cn/todayOnhistory/queryDetail.php";
}

+ (NSString *)getExamList {
    return [NSString stringWithFormat:@"%@/exam/getExamList", [self innterface]];
}

+ (NSString *)getHomeWorkList {
    return [NSString stringWithFormat:@"%@/exam/getHomeWorkList", [self innterface]];
}

+ (NSString *)getExerciseList {
    return [NSString stringWithFormat:@"%@/exam/getExerciseList", [self innterface]];
}

+ (NSString *)getPPTList {
    return [NSString stringWithFormat:@"%@/CourseWare/getCourseWare", [self innterface]];
}

+ (NSString *)getCourseVideo {
    return [NSString stringWithFormat:@"%@/CourseVideo/getCourseVideo", [self innterface]];
}

+ (NSString *)getAttendance {
    return [NSString stringWithFormat:@"%@/Attendance/getAttendance", [self innterface]];
}

+ (NSString *)getCourseList {
    return [NSString stringWithFormat:@"%@/course/classtable", [self innterface]];
}

+ (NSString *)videoList {
    return [NSString stringWithFormat:@"%@/Video/videoList", [self innterface]];
}

+ (NSString *)activityList {
    return [NSString stringWithFormat:@"%@/Activity/activityList", [self innterface]];
}

+ (NSString *)joinActivity {
    return [NSString stringWithFormat:@"%@/Activity/joinActivity", [self innterface]];
}

@end
