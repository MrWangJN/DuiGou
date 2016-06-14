//
//  CourseTableViewCell.m
//  StudyAssisTant
//
//  Created by wjn on 15/8/27.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "CourseTableViewCell.h"
#define ARROW 130

@implementation CourseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.course.width > self.width - self.teachName.width - ARROW) {
        self.course.width = self.width - self.teachName.width - ARROW;
    }
    self.teachName.left = self.course.right + 20;
}

- (void)setCourseModel:(Course *)courseModel {
    
    [self.course setTitle:courseModel.courseName];
    [self.teachName setTitle:courseModel.teacherName];
}

@end
