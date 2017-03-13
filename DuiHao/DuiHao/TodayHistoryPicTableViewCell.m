//
//  TodayHistoryPicTableViewCell.m
//  DuiHao
//
//  Created by wjn on 2016/12/30.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "TodayHistoryPicTableViewCell.h"

@interface TodayHistoryPicTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *picTitleL;
@property (weak, nonatomic) IBOutlet UIImageView *picIV;

@end

@implementation TodayHistoryPicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTodayHistoryPicModel:(TodayHistoryPicModel *)todayHistoryPicModel {
    _todayHistoryPicModel = todayHistoryPicModel;
    
    [self.picTitleL setText:todayHistoryPicModel.pic_title];
    [self.picIV sd_setImageWithURL:[NSURL URLWithString:todayHistoryPicModel.url]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
