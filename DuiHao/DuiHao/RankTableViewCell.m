//
//  RankTableViewCell.m
//  StudyAssisTant
//
//  Created by wjn on 15/9/22.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "RankTableViewCell.h"

@implementation RankTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRankPersonalModel:(RankPersonalModel *)rankPersonalModel {
    [self.nameLabel setText:rankPersonalModel.studentName];
    [self.header setImageWithURL:rankPersonalModel.imageUrl withborderWidth:0];
    [self.rankLabel setText:rankPersonalModel.name];
    NSDictionary *fontDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil];
    
    CGSize size = [rankPersonalModel.name boundingRectWithSize:CGSizeMake(1000, self.rankLabel.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDic context:nil].size;
    self.rankLabel.left = self.width - 10 - size.width;
    self.rankLabel.width = size.width;
    self.rankImageView.right = self.rankLabel.left - 10;
    self.nameLabel.width = self.rankImageView.left - self.nameLabel.left - 10;
    
    
    if (rankPersonalModel.rankImageUrl) {
        [self.rankImageView sd_setImageWithURL:[NSURL URLWithString:rankPersonalModel.rankImageUrl]];
    }
}

@end
