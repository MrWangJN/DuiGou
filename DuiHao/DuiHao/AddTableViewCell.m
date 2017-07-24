//
//  AddTableViewCell.m
//  CourseList
//
//  Created by wjn on 2017/4/18.
//  Copyright © 2017年 Ningmengkeji. All rights reserved.
//

#import "AddTableViewCell.h"
#import "DLPickerView.h"

@implementation AddTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tF.delegate = self;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.bgView.layer.shadowOffset = CGSizeMake(1,1);
    self.bgView.layer.shadowOpacity = 0.3;
    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _weekCourse.classRoom = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)zhouS:(id)sender {
    [self.tF resignFirstResponder];
    WeekView *view = [WeekView showWeekView];
    //    view.parentVC = self;
    view.delegate = self;
    [view show];
}
- (IBAction)jieS:(id)sender {
    
    [self.tF resignFirstResponder];
    
    DLPickerView *pickerView = [[DLPickerView alloc] initWithDataSource:@[@[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"], @[@"第1节", @"第2节", @"第3节", @"第4节", @"第5节", @"第6节", @"第7节", @"第8节", @"第9节", @"第10节", @"第11节", @"第12节"], @[@"到第1节", @"到第2节", @"到第3节", @"到第4节", @"到第5节", @"到第6节", @"到第7节", @"到第8节", @"到第9节", @"到第10节", @"到第11节", @"到第12节"]]
                                                       withSelectedItem:NULL
                                
                                                      withSelectedBlock:^(id selectedItem) {
                                                          
                                                          [self.jie setTitle:[selectedItem componentsJoinedByString:@" "]  forState:UIControlStateNormal];
                                                          [self processingData:[selectedItem componentsJoinedByString:@" "]];
                                                      }
                                ];
    
    pickerView.shouldDismissWhenClickShadow = YES;
    
    [pickerView show];
}

- (IBAction)delegate:(id)sender {    
    if ([self.delegate respondsToSelector:@selector(deleteWeek:)]) {
        [self.delegate deleteWeek:self.weekCourse];
    }
}

- (void)choseFinish:(NSString *)weeks {
    _weekCourse.seWeek = weeks;
    
    NSArray *array = [weeks componentsSeparatedByString:@"-"];
    
    NSString *first = [array firstObject];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
    
    
    for (int i = 1; i < array.count; i++) {
        NSString *num = array[i];
        if ((first.integerValue == num.integerValue - 1)) {
            [arr removeObject:array[i]];
            first = array[i];
        } else {
            [arr insertObject:[NSString stringWithFormat:@"-%@周 ", array[i - 1]] atIndex:[arr indexOfObject:array[i]]];
            first = array[i];
        }
        if ((i + 1 == array.count)) {
            [arr insertObject:[NSString stringWithFormat:@"-%@周 ", array[i]] atIndex:arr.count];
        }
    }

    
    NSString *week = [NSString string];
    
    for (NSString *str in arr) {
        week = [week stringByAppendingString:str];
    }
    
    [self.zhou setTitle:week forState:UIControlStateNormal];
}

- (void)setWeekCourse:(WeekCourse *)weekCourse {
    _weekCourse = weekCourse;
}

- (void)processingData:(NSString *)string {
    
    NSArray *array = [string componentsSeparatedByString:@" "];
    
    NSString *week = [array firstObject];
 
    if ([week isEqualToString:@"周一"]) {
        _weekCourse.day = @"1";
    } else if([week isEqualToString:@"周二"]) {
        _weekCourse.day = @"2";
    } else if([week isEqualToString:@"周三"]) {
        _weekCourse.day = @"3";
    } else if([week isEqualToString:@"周四"]) {
        _weekCourse.day = @"4";
    } else if([week isEqualToString:@"周五"]) {
        _weekCourse.day = @"5";
    } else if([week isEqualToString:@"周六"]) {
        _weekCourse.day = @"6";
    } else {
        _weekCourse.day = @"7";
    }
    
    NSCharacterSet *setToRemove = [[ NSCharacterSet characterSetWithCharactersInString:@"0123456789"]invertedSet ];
   NSString *lesson = [[[array objectAtIndex:1] componentsSeparatedByCharactersInSet:setToRemove] componentsJoinedByString:@""];
    NSString *lessonsNum = [[[array lastObject] componentsSeparatedByCharactersInSet:setToRemove] componentsJoinedByString:@""];
    
    _weekCourse.lesson = lesson;
    _weekCourse.lessonsNum = [NSString stringWithFormat:@"%d", lessonsNum.intValue - lesson.intValue + 1];
//    if ((lessonsNum.intValue - lesson.intValue) <= 0) {
//        _weekCourse.lessonsNum = @"1";
//    } else {
//        _weekCourse.lessonsNum = [NSString stringWithFormat:@"%d", lessonsNum.intValue - lesson.intValue + 1];
//    }
    
}

@end
