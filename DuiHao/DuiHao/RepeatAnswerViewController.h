//
//  RepeatAnswerViewController.h
//  StudyAssisTant
//
//  Created by 王建男 on 15/4/23.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"
#import "SelectCollectionViewCell.h"
#import "JudgeMentModelCollectionViewCell.h"
#import "FillBankOrderCollectionViewCell.h"
#import "ShortAnswerCollectionViewCell.h"
#import "MultiSelCollectionViewCell.h"
#import "TextViewFooter.h"
#import "ItemModel.h"
#import "TextModel.h"

@interface RepeatAnswerViewController : SAViewController<UICollectionViewDelegate, UICollectionViewDataSource, TextViewFooterDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) TextViewFooter *footer;

@property (nonatomic, strong) UINib *textCollectionViewCellNib;
@property (nonatomic, strong) UINib *selectCollectionViewCellNib;
@property (nonatomic, strong) UINib *judgeMentModelCollectionViewCellNib;
@property (nonatomic, strong) UINib *fillBankOrderCollectionViewCellNib;
@property (nonatomic, strong) UINib *multiSelCollectionViewCellNib;
@property (nonatomic, strong) UINib *shortAnswerCollectionViewCellNib;

@property (nonatomic, strong) ItemModel *itemModel;

@property (nonatomic, assign) NSInteger index;

- (instancetype)initWithDatasource:(NSArray *)datasource index:(NSInteger)index;

@end
