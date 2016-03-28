//
//  JudgeMentModelCollectionViewCell.h
//  StudyAssisTant
//
//  Created by 王建男 on 15/4/7.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"
#import "ItemModel.h"
#import "KVNProgress.h"
#import "OptionTableViewCell.h"
#import "ItemTitleTableViewCell.h"

@protocol JudgeMentModelCollectionViewCellDelegate;

@interface JudgeMentModelCollectionViewCell : UICollectionViewCell<UITableViewDataSource, UITableViewDelegate, ItemTitleTableViewCellDelegate>

@property (nonatomic, assign) id<JudgeMentModelCollectionViewCellDelegate>delegate;

@property (assign, nonatomic) BOOL isExam;

@property (strong, nonatomic) ItemModel *itemModel;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datasource;
@property (strong, nonatomic) UINib *optionTableViewCell;
@property (strong, nonatomic) UINib *itemTitleTableViewCell;
@property (assign, nonatomic) NSInteger select;
@property (assign, nonatomic) NSInteger otherSelect;

@end

@protocol JudgeMentModelCollectionViewCellDelegate <NSObject>

- (void)selectCorrectAnswer;
- (void)selectWrongAnswer;

@end