//
//  ShortAnswerTableViewCell.m
//  StudyAssisTant
//
//  Created by wjn on 15/10/6.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "ShortAnswerTableViewCell.h"

@implementation ShortAnswerTableViewCell

- (void)awakeFromNib {
    // Initialization code
//    self.textField;
    [super awakeFromNib];
    self.textField.layer.borderColor = [[UIColor colorWithWhite:0.4 alpha:0.8]CGColor];
    self.textField.layer.borderWidth = 1.0;
    self.textField.layer.cornerRadius = 8.0f;
    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeyDone;
}

- (void)setArray:(NSArray *)array {
    _array = (NSMutableArray *)array;
    self.textField.text = array[1];
}

- (void)setString:(NSString *)string {
    _string = string;
    self.textField.text = string;
}

- (void)clear {
//    self.textField.text = @"作答区";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(textFieldDidSelect)]) {
        [self.delegate textFieldDidSelect];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSString *str = textView.text;
    [_array removeObjectAtIndex:1];
    [_array insertObject:str atIndex:1];
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        NSString *str = textView.text;
        [_array removeObjectAtIndex:1];
        [_array insertObject:str atIndex:1];
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
