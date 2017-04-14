//
//  CourseTableViewCell.m
//  StudyAssisTant
//
//  Created by wjn on 15/8/27.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "CourseTableViewCell.h"
#import "AllResult.h"
#define ARROW 100

@interface CourseTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation CourseTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.bgView.layer.shadowOffset = CGSizeMake(1,1);
    self.bgView.layer.shadowOpacity = 0.3;
    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    if (self.course.width > self.width - self.teachName.width - ARROW) {
//        self.course.width = self.width - self.teachName.width - ARROW;
//    }
//    self.teachName.left = self.course.right + 20;
    if ((self.course.width < self.width - self.teachName.width - ARROW)
        && (self.teachName.width > 42)) {
        self.teachName.width = self.width - ARROW - self.course.width;
    }
//    self.teachName.right = self.width - 40;
}

- (void)setCourseModel:(Course *)courseModel {
    
    _courseModel = courseModel;
    
    [self.course setTitleNoChange:courseModel.courseName];
    [self.teachName setTitle:courseModel.teacherName];
    [self.rankL setText:courseModel.scoreName];
    [self.rankImageV sd_setImageWithURL:[NSURL URLWithString:courseModel.scorePic]];
}

- (IBAction)updateQuestion:(id)sender {
    
//    self.allResult = [[AllResult alloc] initWithCourseName:self.course.courseName];
    
    NSDictionary *dic = @{TEACHERID : self.courseModel.teacherId, COURSEID : self.courseModel.courseId};
    [JKAlert alertWaitingText:@"正在更新"];
    
    [SANetWorkingTask requestWithPost:[SAURLManager downloadQuestion] parmater:dic block:^(id result) {
        
        [JK_M dismissElast];
        
        if (![result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
            return ;
        }
        [JKAlert alertText:@"完成更新"];
         AllResult *allResult = [[AllResult alloc] initWithDictionary:result];
        [allResult writeToLocal:self.courseModel.courseName];
    }];
}

@end
