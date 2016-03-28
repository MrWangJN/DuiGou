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
    return @"http://121.42.144.101/mteach/Mobile";
}

+ (NSString *)querySchoolInfo {
    return [NSString stringWithFormat:@"%@/querySchoolInfo", [self hostDomain]];
}

+ (NSString *)login {
    return [NSString stringWithFormat:@"%@/login", [self hostDomain]];
}

+ (NSString *)queryCourseInfo {
    return [NSString stringWithFormat:@"%@/queryCourseInfo", [self hostDomain]];
}

+ (NSString *)modifyStuSecret {
    return [NSString stringWithFormat:@"%@/modifyStuSecret", [self hostDomain]];
}

+ (NSString *)downloadQuestion {
    return [NSString stringWithFormat:@"%@/downloadQuestion", [self hostDomain]];
}

+ (NSString *)uploadPersonPic {
    return [NSString stringWithFormat:@"%@/uploadPersonPic", [self hostDomain]];
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
