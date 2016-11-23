//
//  NewsTableViewCell.m
//  StudyAssisTant
//
//  Created by wjn on 15/9/8.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "NewsTableViewCell.h"

@implementation NewsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat)getHeight {
    
    self.becomeTime.top = self.news.bottom;
    self.endTime.top = self.news.bottom ;
    
    self.height = self.becomeTime.bottom + 5;
    return self.height;
}

- (void)setNewsModel:(NewsModel *)newsModel {
    
    [self.nameIcon setText:newsModel.courseName];
    [self.name setText:newsModel.teacherName];
    [self.courseName setText:newsModel.courseName];
    [self.news setTitle:[NSString stringWithFormat:@"%@:%@", newsModel.messageTitle, newsModel.messageContent] withSize:14];
    [self.becomeTime setText:newsModel.beginDateTime];
    [self.endTime setText:newsModel.endDateTime];
}

@end
