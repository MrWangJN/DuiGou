//
//  Personal TableViewCell.m
//  DuiHao
//
//  Created by wjn on 16/4/11.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "PersonalTableViewCell.h"
#import "OnceLogin.h"

@implementation PersonalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)layoutSubviews {
//    self.HeaderImageView.constant = self.imageHeaderView.width;
    [super layoutSubviews];
    self.nameLabelX.constant = (self.width - self.nameLabelW.constant - 25) / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadPersonCell {
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    [self.imageHeaderView setImageWithURL:onceLogin.imageURL];
    [self.nameLabel setTitle:onceLogin.studentName withLayout:self.nameLabelW];
    [self.schoolLabel setText:onceLogin.organizationName];
    
    if ([onceLogin.studentSex isEqualToString:@"男"]) {
        [self.genderImageView setImage:[UIImage imageNamed:@"Boy"]];
    } else {
        [self.genderImageView setImage:[UIImage imageNamed:@"Girl"]];
    }
    
    
}

@end
