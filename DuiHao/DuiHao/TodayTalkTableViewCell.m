//
//  TodayTalkTableViewCell.m
//  DuiHao
//
//  Created by wjn on 2017/2/21.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "TodayTalkTableViewCell.h"

@implementation TodayTalkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTodayTalkStatusLayout:(TodayTalkStatusLayout *)todayTalkStatusLayout {
    if (!todayTalkStatusLayout) {
        return;
    }
    _todayTalkStatusLayout = todayTalkStatusLayout;
    
    self.height = todayTalkStatusLayout.height;
    
    [self.dateL setText:todayTalkStatusLayout.model.date];
    [self.monthL setText:todayTalkStatusLayout.model.month];
    [self.contentL setText:todayTalkStatusLayout.model.content];
    [self.autherL setText:todayTalkStatusLayout.model.auther];
    
}

@end
