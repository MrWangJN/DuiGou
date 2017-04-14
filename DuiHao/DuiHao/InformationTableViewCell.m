//
//  InformationTableViewCell.m
//  DuiHao
//
//  Created by wjn on 2017/3/30.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "InformationTableViewCell.h"
#import "OnceLogin.h"

@implementation InformationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
