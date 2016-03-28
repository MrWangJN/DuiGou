//
//  ImageHeadTableViewCell.m
//  StudyAssisTant
//
//  Created by wjn on 15/8/26.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "ImageHeadTableViewCell.h"

@implementation ImageHeadTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImageHeaderView:(NSString *)imageURL {
    [self.imageHeader setImageWithURL:imageURL];
}

@end
