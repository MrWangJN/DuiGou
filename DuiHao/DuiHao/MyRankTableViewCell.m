//
//  MyRankTableViewCell.m
//  StudyAssisTant
//
//  Created by wjn on 15/9/22.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "MyRankTableViewCell.h"
#import "OnceLogin.h"

@implementation MyRankTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setRankModel:(RankModel *)rankModel withCourse:(NSString *)course {
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    
    [self.userHeaderImage sd_setImageWithURL:[NSURL URLWithString:onceLogin.imageURL] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    if (rankModel.rankImageUrl) {
        [self.rankImageView sd_setImageWithURL:[NSURL URLWithString:rankModel.rankImageUrl] placeholderImage:[UIImage imageNamed:@"Top"]];
    }
    [self.rankLabel setText:rankModel.name];
    [self.courseLabel setText:course];
}

@end
