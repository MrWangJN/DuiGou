//
//  HintTableViewCell.m
//  DuiHao
//
//  Created by wjn on 2017/1/5.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "HintTableViewCell.h"
#import "YYKit.h"

@interface HintTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIButton *shareBtu;

@property (weak, nonatomic) IBOutlet YYLabel *contentL;

@end

@implementation HintTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.shareBtu.hidden = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
