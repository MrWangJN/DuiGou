//
//  OptionTableViewCell.m
//  StudyAssisTant
//
//  Created by wjn on 15/9/9.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "OptionTableViewCell.h"

@implementation OptionTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (CGFloat)textHeight {
    
    self.height = self.option.bottom + 10;
//    self.icon.centerY = self.centerY;
    return self.height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
