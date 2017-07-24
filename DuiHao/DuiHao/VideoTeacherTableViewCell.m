//
//  VideoTeacherTableViewCell.m
//  DuiHao
//
//  Created by wjn on 2017/7/18.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "VideoTeacherTableViewCell.h"

@implementation VideoTeacherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.ColorView.layer.cornerRadius = 2;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setChildVieoModel:(ChildVideoModel *)childVieoModel {
    _childVieoModel = childVieoModel;
    
    [self.teacherName setText:childVieoModel.teacherName];
    [self.videoCount setText:childVieoModel.video_num];
}

@end
