//
//  AnswerCollectionViewCell.h
//  StudyAssisTant
//
//  Created by 王建男 on 15/4/23.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemModel.h"
#import "TextModel.h"

@interface AnswerCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *answerImageView;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;

@property (nonatomic, strong) ItemModel *model;

@end
