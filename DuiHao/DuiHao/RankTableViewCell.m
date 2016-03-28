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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRankModel:(RankModel *)rankModel {
    
    [self.nameLabel setText:rankModel.name];
    [self.header setImageWithURL:rankModel.imageurl withborderWidth:1];
    [self.rankLabel setText:rankModel.rank];
    
}

@end
