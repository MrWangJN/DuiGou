//
//  FooterView.m
//  CourseList
//
//  Created by wjn on 2017/4/20.
//  Copyright © 2017年 Ningmengkeji. All rights reserved.
//

#import "FooterView.h"

@implementation FooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)addSender:(id)sender {
    if ([self.delegate respondsToSelector:@selector(add)]) {
        [self.delegate add];
    }
}

@end
