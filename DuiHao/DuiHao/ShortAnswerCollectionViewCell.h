//
//  ShortAnswerCollectionViewCell.h
//  StudyAssisTant
//
//  Created by wjn on 15/9/29.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//
#import "SAKit.h"
#import "ItemModel.h"
#import "KVNProgress.h"
#import "OptionTableViewCell.h"
#import "ItemTitleTableViewCell.h"
#import "ShortAnswerTableViewCell.h"

@protocol ShortAnswerCollectionViewCellDelegate;


@interface ShortAnswerCollectionViewCell : UICollectionViewCell<UITableViewDataSource, UITableViewDelegate, ItemTitleTableViewCellDelegate, ShortAnswerTableViewDelegate>

@property (assign, nonatomic) id<ShortAnswerCollectionViewCellDelegate>delegate;

@property (assign, nonatomic) BOOL isExam;

@property (strong, nonatomic) ItemModel *itemModel;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datasource;
@property (strong, nonatomic) UINib *shortAnswerTableViewCell;
@property (strong, nonatomic) UINib *itemTitleTableViewCell;
@property (strong, nonatomic) UINib *optionTableViewCell;
@property (assign, nonatomic) NSInteger select;
@property (assign, nonatomic) NSInteger otherSelect;
@property (nonatomic, assign) NSInteger keyBoardHight;
@end

@protocol ShortAnswerCollectionViewCellDelegate <NSObject>

- (void)selectCorrectAnswer;
- (void)selectWrongAnswer;

@end