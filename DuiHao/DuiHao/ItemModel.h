//
//  ItemModel.h
//  StudyAssisTant
//
//  Created by 王建男 on 15/3/10.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum : NSUInteger {
    Select = 0,
    Multil,
    JudgeMent,
    FillBank,
    ShortAnswer,
} ModelType;

@interface ItemModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *question;
@property (nonatomic, copy) NSString *answer;
@property (nonatomic, copy) NSString *answerA;
@property (nonatomic, copy) NSString *answerB;
@property (nonatomic, copy) NSString *answerC;
@property (nonatomic, copy) NSString *answerD;
@property (nonatomic, copy) NSString *answerE;
@property (nonatomic, copy) NSString *answerF;
@property (nonatomic, copy) NSString *answerG;
@property (nonatomic, copy) NSString *answerH;
@property (nonatomic, copy) NSString *answerI;
@property (nonatomic, copy) NSString *chapter;
@property (nonatomic, copy) NSString *courseAlias;
@property (nonatomic, copy) NSString *questionId;
@property (nonatomic, copy) NSString *section;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *teacherAliasName;
@property (nonatomic, copy) NSString *my_Answer;
@property (nonatomic, assign) NSInteger select;
@property (strong, nonatomic) NSMutableArray *answers;
@property (assign, nonatomic) ModelType type;

- (instancetype)initWithrawDictionary:(NSDictionary *)rawDictionary;
- (instancetype)initWithItemModel:(ItemModel *)itemModel;
- (NSDictionary *)getDistionary;

@end
