//
//  CouresTableViewCell.m
//  CourseList
//
//  Created by wjn on 2017/4/18.
//  Copyright © 2017年 Ningmengkeji. All rights reserved.
//

#import "CouresTableViewCell.h"

@implementation CouresTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btuSender:(id)sender {
    
    if (self.type == BEN) {
        
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"确认从课程表删除此课程" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [alert show];
        alert.rightBlock = ^() {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *docDir = [paths objectAtIndex:0];
            NSString *coursePath = [NSString stringWithFormat:@"%@/%@", docDir, @"course.json"];
            NSArray *array = [NSArray arrayWithContentsOfFile:coursePath];
            NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *dic in array) {
                if ([dic[@"weekDay"] isEqualToString:self.weekCourse.day]) {
                    
                    NSArray *courses = dic[@"data"];
                    NSMutableArray *courseArr = [NSMutableArray arrayWithCapacity:0];
                    for (NSDictionary *dicaa in courses) {
                        if (!([dicaa[@"lessons"] isEqualToString:self.weekCourse.lesson])) {
                            [courseArr addObject:dicaa];
                        }
                    }
                    [newArray addObject:@{@"weekDay": self.weekCourse.day, @"data": courseArr}];
                } else {
                    [newArray addObject:dic];
                }
            }
            [newArray writeToFile:coursePath atomically:YES];
            [self.delegate reload:self.weekCourse];
        };
        
    } else {
        
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"确认添加此课程至课程表" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [alert show];
        alert.rightBlock = ^() {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *docDir = [paths objectAtIndex:0];
            NSString *coursePath = [NSString stringWithFormat:@"%@/%@", docDir, @"course.json"];
            
            NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:coursePath];
            NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:0];
            
            if (!array.count) {
                [array addObject:@{@"weekDay": @"1", @"data": [NSArray array]}];
                [array addObject:@{@"weekDay": @"2", @"data": [NSArray array]}];
                [array addObject:@{@"weekDay": @"3", @"data": [NSArray array]}];
                [array addObject:@{@"weekDay": @"4", @"data": [NSArray array]}];
                [array addObject:@{@"weekDay": @"5", @"data": [NSArray array]}];
                [array addObject:@{@"weekDay": @"6", @"data": [NSArray array]}];
                [array addObject:@{@"weekDay": @"7", @"data": [NSArray array]}];
            }
            
            for (NSDictionary *dic in array) {
                if ([dic[@"weekDay"] isEqualToString:self.weekCourse.day]) {
                    
                    NSMutableArray *courses = [NSMutableArray arrayWithArray:dic[@"data"]];
                    for (NSDictionary *dicaa in courses) {
                        if (([dicaa[@"lessons"] isEqualToString:self.weekCourse.lesson] &&
                             [dicaa[@"courseCode"] isEqualToString:self.weekCourse.courseCode])) {
                            [JKAlert alertText:@"已成功添加该课程"];
                            return;
                        }
                    }
                    [courses addObject:[self.weekCourse toDictionary]];
                    [newArray addObject:@{@"weekDay": self.weekCourse.day, @"data": courses}];
                } else {
                    [newArray addObject:dic];
                }
            }
            [newArray writeToFile:coursePath atomically:YES];
            [self.delegate add:self.weekCourse];
        };
    }
}

- (void)setWeekCourse:(WeekCourse *)weekCourse {
    
    _weekCourse = weekCourse;
    
    [self.CourseTitleL setText:weekCourse.courseName];
    [self.addressL setText:[NSString stringWithFormat:@"教师:%@   上课地点:%@", weekCourse.teacherName, weekCourse.classRoom]];
    
    if (self.type == WANG) {
        [self.typeBtu setImage:[UIImage imageNamed:@"AddTeacherCourse"] forState:UIControlStateNormal];
    } else {
        [self.typeBtu setImage:[UIImage imageNamed:@"DeleteCourse"] forState:UIControlStateNormal];
    }
    
}

@end
