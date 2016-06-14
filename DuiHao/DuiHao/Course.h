//
//  Course.h
//  StudyAssisTant
//
//  Created by wjn on 15/8/27.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Course : NSObject

@property (copy, nonatomic) NSString *courseId;
@property (copy, nonatomic) NSString *courseName;
@property (copy, nonatomic) NSString *teacherId;
@property (copy, nonatomic) NSString *teacherName;

@end
