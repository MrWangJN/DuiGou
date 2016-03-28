//
//  AnswerCollectionViewCell.m
//  StudyAssisTant
//
//  Created by 王建男 on 15/4/23.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "AnswerCollectionViewCell.h"

@implementation AnswerCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(ItemModel *)item {

    if ([item.answer isEqualToString:item.my_Answer]) {
        [self.answerImageView setImage:[UIImage imageNamed:@"Corrcet"]];
    } else {
        [self.answerImageView setImage:[UIImage imageNamed:@"Wrong"]];
    }
    if (item.answers.count) {
        NSMutableString *string = [NSMutableString string];
        for (NSIndexPath *indexPath in item.answers) {
            
            if (indexPath.row == 1) {
                [string appendString:@"/A"];
            } else if (indexPath.row == 2) {
                [string appendString:@"/B"];
            } else if (indexPath.row == 3 ) {
                [string appendString:@"/C"];
            } else if (indexPath.row == 4 ) {
                [string appendString:@"/D"];
            } else if (indexPath.row == 5 ) {
                [string appendString:@"/E"];
            } else if (indexPath.row == 6 ) {
                [string appendString:@"/F"];
            } else if (indexPath.row == 7 ) {
                [string appendString:@"/G"];
            } else if (indexPath.row == 8 ) {
                [string appendString:@"/H"];
            } else if (indexPath.row == 9 ) {
                [string appendString:@"/I"];
            }
        }
        if (string.length) {
            NSRange range = {0, 1};
            [string deleteCharactersInRange:range];
        }
        
        if ([string isEqualToString:item.answer]) {
            [self.answerImageView setImage:[UIImage imageNamed:@"Corrcet"]];
        } else {
            [self.answerImageView setImage:[UIImage imageNamed:@"Wrong"]];
        }
        
    }
}

@end
