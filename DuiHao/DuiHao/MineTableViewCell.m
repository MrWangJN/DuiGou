//
//  MineTableViewCell.m
//  StudyAssisTant
//
//  Created by wjn on 15/8/31.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "MineTableViewCell.h"

@implementation MineTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDic:(NSDictionary *)dic {
    
    self.title.text = dic[TITLE];
    self.titleImage.image = [UIImage imageNamed:dic[TITLEIMAGE]];
    
    NSString *string = dic[ARROWIMAGE];
    self.arrowImage.hidden = string.intValue;
}

@end
