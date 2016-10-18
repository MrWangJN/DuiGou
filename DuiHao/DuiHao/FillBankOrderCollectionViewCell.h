//
//  FillBankOrderCollectionViewCell.h
//  StudyAssisTant
//
//  Created by 王建男 on 15/4/8.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"
#import "ItemModel.h"
#import "KVNProgress.h"
#import "FillBankOrderTableViewCell.h"
#import "ItemTitleTableViewCell.h"
#import "OptionTableViewCell.h"
#import "MutiSelFooterView.h"

@protocol  FillBankOrderCollectionViewCellDelegate;

@interface FillBankOrderCollectionViewCell : UICollectionViewCell<UITableViewDelegate, UITableViewDataSource, ItemTitleTableViewCellDelegate, FillBankOrderTableViewCellDelegate, MutiSelFooterViewDelegate>

@property (nonatomic, strong) id<FillBankOrderCollectionViewCellDelegate>delegate;

@property (assign, nonatomic) BOOL isExam;

@property (strong, nonatomic) ItemModel *itemModel;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datasource;
@property (strong, nonatomic) UINib *fillBankOrderTableViewCell;
@property (strong, nonatomic) UINib *itemTitleTableViewCell;
@property (strong, nonatomic) UINib *optionTableViewCell;

@property (strong, nonatomic) NSMutableArray *answers;
@property (nonatomic, assign) NSInteger keyBoardHight;

@property (nonatomic, strong) MutiSelFooterView *footerView;

@end

@protocol FillBankOrderCollectionViewCellDelegate <NSObject>

- (void)selectCorrectAnswer;
- (void)selectWrongAnswer;
/// 点击了图片
- (void)textCell:(UIView *)imgView didClickImageAtImageUrl:(NSString *)imageurl;

@end
