//
//  BindOtherTableViewCell.m
//  DuiHao
//
//  Created by wjn on 16/4/20.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "BindOtherTableViewCell.h"

@implementation BindOtherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title withContent:(NSString *)content {
    [self.titleLabel setText:title];
    [self.contentLabel setText:content];
}

@end
