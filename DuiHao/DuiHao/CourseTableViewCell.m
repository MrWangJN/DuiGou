//
//  CourseTableViewCell.m
//  StudyAssisTant
//
//  Created by wjn on 15/8/27.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "CourseTableViewCell.h"
#define ARROW 100

@implementation CourseTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
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
        && (self.teachName.width > 21)) {
        self.teachName.width = self.width - ARROW - self.course.width;
    }
    self.teachName.right = self.width - 40;
}

- (void)setCourseModel:(Course *)courseModel {
    
    [self.hintLabel setText:courseModel.courseName];
    [self.course setTitleNoChange:courseModel.courseName];
    [self.teachName setTitle:courseModel.teacherName];
}

@end
