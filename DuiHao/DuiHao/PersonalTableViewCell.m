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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadPersonCell {
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    
    [self.imageHeaderView setImageWithURL:onceLogin.imageURL];
    [self.nameLabel setText:onceLogin.studentName];
    [self.schoolLabel setText:onceLogin.organizationName];
    
    if ([onceLogin.studentSex isEqualToString:@"男"]) {
        [self.genderImageView setImage:[UIImage imageNamed:@"Boy"]];
    } else {
        [self.genderImageView setImage:[UIImage imageNamed:@"Girl"]];
    }
    
    
}

@end
