//
//  FillBankOrderTableViewCell.m
//  StudyAssisTant
//
//  Created by wjn on 15/9/29.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "FillBankOrderTableViewCell.h"

@implementation FillBankOrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.inPutText.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)settextWith:(NSInteger)index withArray:(NSMutableArray *)array{
    self.answers = array;
    self.index = index;
    if (!self.answers[index - 1]) {
        self.inPutText.text = @"";
    } else {
        self.inPutText.text = self.answers[index - 1];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(textFieldDidSelect:)]) {
        [self.delegate textFieldDidSelect:self.index];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.answers[self.index - 1] = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.inPutText resignFirstResponder];
    return YES;
}

@end
