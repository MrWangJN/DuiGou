//
//  AttendanceTableViewCell.h
//  DuiHao
//
//  Created by wjn on 2017/4/6.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttendanceModel.h"

@interface AttendanceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *courseL;
@property (weak, nonatomic) IBOutlet UILabel *attendance_sectionsL;
@property (weak, nonatomic) IBOutlet UILabel *attendance_typeL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UIImageView *statesImageV;

@property (strong, nonatomic) AttendanceModel *attendanceModel;

@end
