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
    return @"http://121.42.144.101/m/api.php/user";
}

+ (NSString *)local {
    return @"http://192.168.1.109:8080/mteach/mteach/api.php";
}

+ (NSString *)querySchoolInfo {
    return [NSString stringWithFormat:@"%@/querySchoolInfo", [self hostDomain]];
}

+ (NSString *)login {
    return [NSString stringWithFormat:@"%@/user/login", [self local]];
}

+ (NSString *)verify {
    return [NSString stringWithFormat:@"%@/user/verifyRegister", [self local]];
}

+ (NSString *)captcha {
    return [NSString stringWithFormat:@"%@/user/getCheckCode", [self local]];
}

+ (NSString *)verifyRegister {
    return [NSString stringWithFormat:@"%@/user/register", [self local]];
}

+ (NSString *)affirmPassWorld {
    return [NSString stringWithFormat:@"%@/user/register", [self local]];
}

+ (NSString *)queryCourseInfo {
    return [NSString stringWithFormat:@"%@/Course/lists", [self local]];
}

+ (NSString *)modifyStuSecret {
    return [NSString stringWithFormat:@"%@/Course/lists", [self local]];
}

+ (NSString *)downloadQuestion {
    return [NSString stringWithFormat:@"%@/downloadQuestion", [self hostDomain]];
}

+ (NSString *)uploadPersonPic {
    return [NSString stringWithFormat:@"%@/user/uploadPersonPic", [self local]];
}

+ (NSString *)myRanking {
    return [NSString stringWithFormat:@"%@/myRanking", [self hostDomain]];
}

+ (NSString *)isOpenExam {
    return [NSString stringWithFormat:@"%@/isOpenExam", [self hostDomain]];
}

+ (NSString *)uploadScore {
    return [NSString stringWithFormat:@"%@/uploadScore", [self hostDomain]];
}

@end
