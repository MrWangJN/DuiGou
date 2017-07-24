//
//  HeaderView.m
//  CourseList
//
//  Created by wjn on 2017/4/20.
//  Copyright © 2017年 Ningmengkeji. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.shadowOffset = CGSizeMake(1,1);
    self.bgView.layer.shadowOpacity = 0.3;
    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    
    self.courseT.delegate = self;
    self.teacherT.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

/*
 
 
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
