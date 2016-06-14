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
//    return @"http://192.168.1.109:8080/mteach/mteach/api.php";
    return @"http://192.168.23.1:8080/mteach/mteach/api.php";
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
    return [NSString stringWithFormat:@"%@/user/register", [self innterface]];
}

+ (NSString *)queryCourseInfo {
    return [NSString stringWithFormat:@"%@/Course/lists", [self innterface]];
}

+ (NSString *)modifyStuSecret {
    return [NSString stringWithFormat:@"%@/Course/lists", [self innterface]];
}

+ (NSString *)downloadQuestion {
    return [NSString stringWithFormat:@"%@/downloadQuestion", [self innterface]];
}

+ (NSString *)uploadPersonPic {
    return [NSString stringWithFormat:@"%@/user/uploadPersonPic", [self innterface]];
}

+ (NSString *)bindInformation {
    return [NSString stringWithFormat:@"%@/user/bindInformation", [self innterface]];
}

+ (NSString *)myRanking {
    return [NSString stringWithFormat:@"%@/myRanking", [self innterface]];
}

+ (NSString *)isOpenExam {
    return [NSString stringWithFormat:@"%@/isOpenExam", [self innterface]];
}

+ (NSString *)uploadScore {
    return [NSString stringWithFormat:@"%@/uploadScore", [self innterface]];
}

@end
