//
//  TextViewController.h
//  StudyAssisTant
//
//  Created by 王建男 on 15/3/20.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"
#import "OnceLogin.h"
#import "TextCollectionViewCell.h"
#import "SelectCollectionViewCell.h"
#import "ItemModel.h"
#import "TextViewFooter.h"
#import "JudgeMentModelCollectionViewCell.h"
#import "FillBankOrderCollectionViewCell.h"
#import "ShortAnswerCollectionViewCell.h"
#import "MultiSelCollectionViewCell.h"
#import "TextModel.h"
#import "STAlertView.h"

typedef enum : NSUInteger {
    Collect = 2,
    SelectOrder,
    MultiSelect,
    JudgeMentOrder,
    FillBankOrder,
    ShortAnswerOrder,
    SelectRandom,
    MultiSelectRandom,
    JudgeMentRandom,
    FillBankRandom,
    ShortAnswerRandom
} CollectionViewType;

@interface TextViewController : SAViewController<UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, SelectCollectionViewCellDelegate, MultiSelCollectionViewCellDelegate, TextViewFooterDelegate, JudgeMentModelCollectionViewCellDelegate, FillBankOrderCollectionViewCellDelegate, ShortAnswerCollectionViewCellDelegate>

typedef void(^TextBlock)(NSArray *array);

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIBarButtonItem *rightItem;

@property (nonatomic, strong) UINib *textCollectionViewCellNib;
@property (nonatomic, strong) UINib *selectCollectionViewCellNib;
@property (nonatomic, strong) UINib *judgeMentModelCollectionViewCellNib;
@property (nonatomic, strong) UINib *fillBankOrderCollectionViewCellNib;
@property (nonatomic, strong) UINib *multiSelCollectionViewCellNib;
@property (nonatomic, strong) UINib *shortAnswerCollectionViewCellNib;

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, assign) CollectionViewType collectionViewType;

@property (nonatomic, strong) TextViewFooter *footer;
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) ItemModel *itemModel;
@property (nonatomic, strong) TextModel *judgeMentModel;

@property (nonatomic, strong) NSMutableSet *randomSet;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) int examTime;

@property (nonatomic, copy) TextBlock block;

- (instancetype)initWithType:(CollectionViewType )collectionViewType withDatasource:(NSArray *)datasource;
- (instancetype)initWithType:(CollectionViewType )collectionViewType withDatasource:(NSArray *)datasource withCollect:(BOOL) collectState;
- (instancetype)initWithType:(CollectionViewType )collectionViewType WithTime:(int )examTime;
- (void)pushAnswerViewController:(TextBlock)block;

@end
