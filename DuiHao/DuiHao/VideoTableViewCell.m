//
//  VideoTableViewCell.m
//  DuiHao
//
//  Created by wjn on 2017/7/18.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "VideoTableViewCell.h"

@implementation VideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backView.layer.cornerRadius = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setVideoModel:(VideoModel *)videoModel {
    _videoModel = videoModel;
    
    [self.courseName setText:videoModel.name];
    [self.teacherNumL setText:videoModel.teacher_count];
    [self.fileNumL setText:videoModel.video_count];
}

@end
