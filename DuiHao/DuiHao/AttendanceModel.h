//
//  AttendanceModel.h
//  DuiHao
//
//  Created by wjn on 2017/4/6.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "SAModel.h"

@interface AttendanceModel : SAModel

@property (copy, nonatomic) NSString *attendance_sections;
@property (copy, nonatomic) NSNumber *attendance_type;
@property (copy, nonatomic) NSString *courseName;
@property (copy, nonatomic) NSString *stateInfo;
@property (copy, nonatomic) NSNumber *states;
@property (copy, nonatomic) NSString *time;

@end
