//
//  MessageTableViewCell.m
//  DuiHao
//
//  Created by wjn on 2017/3/13.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNewsModel:(NewsModel *)newsModel {
    [self.teacherNameL setText:newsModel.teacherName];
    [self.timeL setText:newsModel.beginDateTime];
    [self.titleL setText:newsModel.messageTitle];
    [self.contentL setText:newsModel.messageContent];
}

@end
