//
//  AttendanceTableViewCell.m
//  DuiHao
//
//  Created by wjn on 2017/4/6.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "AttendanceTableViewCell.h"

@implementation AttendanceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAttendanceModel:(AttendanceModel *)attendanceModel {
    _attendanceModel = attendanceModel;
    
    [self.courseL setText:attendanceModel.courseName];
    [self.attendance_sectionsL setText:attendanceModel.attendance_sections];
    [self.attendance_sectionsL sizeToFit];
    
    if (attendanceModel.attendance_type.intValue == 1) {
        [self.attendance_typeL setText:@"上课"];
    } else {
        [self.attendance_typeL setText:@"下课"];
    }
    
    [self.timeL setText:attendanceModel.time];
    
    switch (attendanceModel.states.intValue) {
        case 0:
            [self.statesImageV setImage:[UIImage imageNamed:@"Attendance_Success"]];
            break;
        case 1:
            [self.statesImageV setImage:[UIImage imageNamed:@"Truant"]];
            break;
        case 2:
            [self.statesImageV setImage:[UIImage imageNamed:@"Be_late"]];
            break;
        case 3:
            [self.statesImageV setImage:[UIImage imageNamed:@"Leave_personal_affairs"]];
            break;
        case 4:
            [self.statesImageV setImage:[UIImage imageNamed:@"Sick_leave"]];
            break;
        default:
            [self.statesImageV setImage:[UIImage imageNamed:@"Attendance_Success"]];
            break;
    }
    
}

@end
