//
//  SAHTMLHeightenLabel.m
//  SAFramework
//
//  Created by wjn on 15/10/3.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAHTMLHeightenLabel.h"

@implementation SAHTMLHeightenLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    
}

- (void)setTitle:(NSString *)title withSize:(CGFloat )textSize {

    self.backgroundColor = [UIColor redColor];
    [self setFont:[UIFont boldSystemFontOfSize:textSize]];
    self.componentsAndPlainText = [RCLabel extractTextStyle:@"aaaa"];
    //    计算图文混排之后的高度
    CGSize optimalSize = [self optimumSize];
    //    保持原来的位置和宽度，改变其高度
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, optimalSize.height);
}

@end
