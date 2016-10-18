//
//  MultiSelCollectionViewCell.h
//  StudyAssisTant
//
//  Created by wjn on 15/9/20.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"
#import "ItemModel.h"
#import "KVNProgress.h"
#import "OptionTableViewCell.h"
#import "ItemTitleTableViewCell.h"
#import "MutiSelFooterView.h"

@class MutiSelFooterView;

@protocol MultiSelCollectionViewCellDelegate;

@interface MultiSelCollectionViewCell : UICollectionViewCell<UITableViewDataSource, UITableViewDelegate, ItemTitleTableViewCellDelegate, OptionTableViewCellDelegate, MutiSelFooterViewDelegate>

@property (assign, nonatomic) BOOL isExam;

@property (strong, nonatomic) NSMutableArray *answers;

@property (strong, nonatomic) ItemModel *itemModel;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datasource;
@property (strong, nonatomic) UINib *optionTableViewCell;
@property (strong, nonatomic) UINib *itemTitleTableViewCell;

@property (assign, nonatomic) id<MultiSelCollectionViewCellDelegate>delegate;

@property (nonatomic, strong) MutiSelFooterView *footerView;

@end

@protocol MultiSelCollectionViewCellDelegate <NSObject>

- (void)selectCorrectAnswer;
- (void)selectWrongAnswer;
/// 点击了图片
- (void)textCell:(UIView *)imgView didClickImageAtImageUrl:(NSString *)imageurl;

@end