//
//  UpdateView.m
//  StudyAssisTant
//
//  Created by wjn on 15/9/4.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "UpdateView.h"

@implementation UpdateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    self.show = NO;
}

#pragma mark - private

- (IBAction)updateButtonDidPress:(id)sender {
    if ([self.delegate respondsToSelector:@selector(updateDatasource)]) {
        [self.delegate updateDatasource];
    }
}

- (IBAction)removeButtonDidPress:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(removeDatasource)]) {
        [self.delegate removeDatasource];
    }
    
}

@end
