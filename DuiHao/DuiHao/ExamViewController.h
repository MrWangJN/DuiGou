//
//  ExamViewController.h
//  StudyAssisTant
//
//  Created by 王建男 on 15/4/24.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"
#import "OnceLogin.h"
#import "TextCollectionViewCell.h"
#import "SelectCollectionViewCell.h"
#import "ItemModel.h"
#import "JudgeMentModelCollectionViewCell.h"
#import "FillBankOrderCollectionViewCell.h"
#import "ShortAnswerCollectionViewCell.h"
#import "MultiSelCollectionViewCell.h"
#import "TextModel.h"
#import "STAlertView.h"
#import "ExamModel.h"
#import "Course.h"
#import "ExamHeaderView.h"
#import "AllResult.h"
#import "AnswerViewController.h"
#import "SliderView.h"

typedef enum : NSUInteger {
    OnlineExam,
    ExamText
} ExamType;

@interface ExamViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, SelectCollectionViewCellDelegate, MultiSelCollectionViewCellDelegate, JudgeMentModelCollectionViewCellDelegate, FillBankOrderCollectionViewCellDelegate, ExamHeaderViewDelegate, ShortAnswerCollectionViewCellDelegate, SliderViewDelegate>

@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) int examTime;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UINib *textCollectionViewCellNib;
@property (nonatomic, strong) UINib *selectCollectionViewCellNib;
@property (nonatomic, strong) UINib *judgeMentModelCollectionViewCellNib;
@property (nonatomic, strong) UINib *fillBankOrderCollectionViewCellNib;
@property (nonatomic, strong) UINib *multiSelCollectionViewCellNib;
@property (nonatomic, strong) UINib *shortAnswerCollectionViewCellNib;

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) NSMutableArray *wrongDataSource;

@property (nonatomic, strong) SliderView *sliderView;
@property (nonatomic, strong) ExamHeaderView *examHeader;
@property (nonatomic, strong) ItemModel *itemModel;
@property (strong, nonatomic) ExamModel *examModel;
@property (strong, nonatomic) Course *course;
@property (strong, nonatomic) AllResult *allResult;

@property (assign, nonatomic) ExamType examType;

@property (nonatomic, strong) NSMutableSet *randomSet;
@property (nonatomic, assign) NSInteger index;


- (instancetype)initWithCouse:(Course *)couse withExam:(ExamModel *)examModel;
- (instancetype)initWithAllCouse:(AllResult *)allResult;

@end
