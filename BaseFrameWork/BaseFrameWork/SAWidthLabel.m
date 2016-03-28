//
//  SAWidthLabel.m
//  SAFramework
//
//  Created by wjn on 15/8/27.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAWidthLabel.h"

@implementation SAWidthLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setTitle:(NSString *)title {
    
    self.text = title;
    self.numberOfLines = 0;
    
    NSDictionary *fontDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17],NSFontAttributeName, nil];
    
    CGSize size = [title boundingRectWithSize:CGSizeMake(1000, [UIScreen mainScreen].bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDic context:nil].size;
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, self.frame.size.height)];
}

@end
