//
//  AnswerViewController.h
//  StudyAssisTant
//
//  Created by 王建男 on 15/4/23.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"
#import "AnswerCollectionViewCell.h"
#import "RepeatAnswerViewController.h"
#import "ItemModel.h"
#import "AnswerHeaderView.h"
#import "OnceLogin.h"

@interface AnswerViewController : SAViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *markLabel;

@property (nonatomic, strong) UINib *answerCollectionViewCellNib;

@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) AnswerHeaderView *answerView;

- (instancetype)initWithDatasuorce:(NSArray *)datasuorce;

@end
