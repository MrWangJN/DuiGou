//
//  ItemTitleTableViewCell.m
//  StudyAssisTant
//
//  Created by 王建男 on 15/3/10.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "ItemTitleTableViewCell.h"

@implementation ItemTitleTableViewCell

- (void)awakeFromNib {
	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (CGFloat)textHeight {
    self.height = self.titleLabel.bottom + self.section.height + 30;
    return self.height;
}

- (IBAction)answerButtonDidPress:(id)sender {
    if ([self.delegate respondsToSelector:@selector(answerPress)]) {
        [self.delegate answerPress];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
