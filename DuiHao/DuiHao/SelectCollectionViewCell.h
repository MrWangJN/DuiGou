//
//  SelectCollectionViewCell.h
//  StudyAssisTant
//
//  Created by 王建男 on 15/3/20.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"
#import "ItemModel.h"
#import "KVNProgress.h"
#import "OptionTableViewCell.h"
#import "ItemTitleTableViewCell.h"
#import "MutiSelFooterView.h"

@protocol SelectCollectionViewCellDelegate;

@interface SelectCollectionViewCell : UICollectionViewCell<UITableViewDataSource, UITableViewDelegate, ItemTitleTableViewCellDelegate, OptionTableViewCellDelegate, MutiSelFooterViewDelegate
>

@property (assign, nonatomic) id<SelectCollectionViewCellDelegate>delegate;

@property (assign, nonatomic) BOOL isExam;

@property (strong, nonatomic) ItemModel *itemModel;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datasource;
@property (strong, nonatomic) UINib *optionTableViewCell;
@property (strong, nonatomic) UINib *itemTitleTableViewCell;
@property (assign, nonatomic) NSInteger select;
@property (assign, nonatomic) NSInteger otherSelect;

@property (nonatomic, strong) MutiSelFooterView *footerView;

@end

@protocol SelectCollectionViewCellDelegate <NSObject>

- (void)selectCorrectAnswer;
- (void)selectWrongAnswer;
/// 点击了图片
- (void)textCell:(UIView *)imgView didClickImageAtImageUrl:(NSString *)imageurl;

@end