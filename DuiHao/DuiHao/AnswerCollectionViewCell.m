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
    [super awakeFromNib];
}

- (void)setModel:(ItemModel *)item {

    if (item.type == Multil) {
        if (!item.answers.count) {
            [self.answerImageView setImage:[UIImage imageNamed:@"NoAnswer"]];
        } else {
            NSMutableString *string = [NSMutableString string];
            for (NSIndexPath *indexPath in item.answers) {
                [string appendFormat:@"%@", [NSString stringWithFormat:@",%c", (char)(indexPath.row + '@')]];
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
        return;
    }
    
    if (item.type == (Select | JudgeMent)) {
        if (!item.my_Answer.length) {
            [self.answerImageView setImage:[UIImage imageNamed:@"NoAnswer"]];
            return;
        } else {
            if ([item.answer isEqualToString:item.my_Answer]) {
                [self.answerImageView setImage:[UIImage imageNamed:@"Corrcet"]];
            } else {
                [self.answerImageView setImage:[UIImage imageNamed:@"Wrong"]];
            }
        }
        return;
    }
    
//    if (!item.my_Answer.length) {
//        [self.answerImageView setImage:[UIImage imageNamed:@"NoAnswer"]];
//        return;
//    }
//    
//    
//    if ([item.answer isEqualToString:item.my_Answer]) {
//        [self.answerImageView setImage:[UIImage imageNamed:@"Corrcet"]];
//    } else {
//        [self.answerImageView setImage:[UIImage imageNamed:@"Wrong"]];
//    }
//    if (item.answers.count) {
//        NSMutableString *string = [NSMutableString string];
//        for (NSIndexPath *indexPath in item.answers) {
//          [string appendFormat:@"%@", [NSString stringWithFormat:@",%c", (char)(indexPath.row + '@')]];
//        }
//        if (string.length) {
//            NSRange range = {0, 1};
//            [string deleteCharactersInRange:range];
//        }
//        
//        if ([string isEqualToString:item.answer]) {
//            [self.answerImageView setImage:[UIImage imageNamed:@"Corrcet"]];
//        } else {
//            [self.answerImageView setImage:[UIImage imageNamed:@"Wrong"]];
//        }
//        
//    }
}

@end
