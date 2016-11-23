//
//  ExamModel.m
//  StudyAssisTant
//
//  Created by wjn on 15/10/3.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "ExamModel.h"

@implementation ExamModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        
        NSDictionary *exam = dictionary[@"data"];
        
//        self.examId = exam[@"examId"];
//        self.examLength = exam[@"timeLength"];
        
        [self setValuesForKeysWithDictionary:exam];
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dic in self.fillBlankQuestion) {
            
            ItemModel *itemModel = [[ItemModel alloc] initWithrawDictionary:dic];
            itemModel.type = FillBank;
            [array addObject:itemModel];
        }
        self.fillBlankQuestion = [NSArray arrayWithArray:array];
        [array removeAllObjects];
        
        for (NSDictionary *dic in self.judgeQuestion) {
            
            ItemModel *itemModel = [[ItemModel alloc] initWithrawDictionary:dic];
            itemModel.type = JudgeMent;
            [array addObject:itemModel];
        }
        
        self.judgeQuestion = [NSArray arrayWithArray:array];
        [array removeAllObjects];
        
        for (NSDictionary *dic in self.multiSelectQuestion) {
            
            ItemModel *itemModel = [[ItemModel alloc] initWithrawDictionary:dic];
            itemModel.type = Multil;
            [array addObject:itemModel];
        }
        
        self.multiSelectQuestion = [NSArray arrayWithArray:array];
        [array removeAllObjects];
        
        for (NSDictionary *dic in self.selectQuestion) {
            
            ItemModel *itemModel = [[ItemModel alloc] initWithrawDictionary:dic];
            itemModel.type = Select;
            [array addObject:itemModel];
        }
        
        self.selectQuestion = [NSArray arrayWithArray:array];
        [array removeAllObjects];
        
        for (NSDictionary *dic in self.shortQuestion) {
            
            ItemModel *itemModel = [[ItemModel alloc] initWithrawDictionary:dic];
            itemModel.type = ShortAnswer;
            [array addObject:itemModel];
        }
        
        self.shortQuestion = [NSArray arrayWithArray:array];
    }
    
    return self;
}


@end
