//
//  MyRankTableViewCell.m
//  StudyAssisTant
//
//  Created by wjn on 15/9/22.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "MyRankTableViewCell.h"

@implementation MyRankTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRankModel:(RankModel *)rankModel {
    [self.rankLabel setText:rankModel.rank];
    [self.courseLabel setText:rankModel.name];
}

@end
