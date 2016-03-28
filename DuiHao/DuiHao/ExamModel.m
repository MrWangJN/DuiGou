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
        
        NSDictionary *exam = dictionary[@"exam"];
        
        self.examId = exam[@"examid"];
        self.examLength = exam[@"examlength"];
        
        NSDictionary *examAnswer = dictionary[@"examanswer"];
        [self setValuesForKeysWithDictionary:examAnswer];
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dic in self.fillBlank) {
            
            ItemModel *itemModel = [[ItemModel alloc] initWithrawDictionary:dic];
            itemModel.type = FillBank;
            [array addObject:itemModel];
        }
        self.fillBlank = [NSArray arrayWithArray:array];
        [array removeAllObjects];
        
        for (NSDictionary *dic in self.judgement) {
            
            ItemModel *itemModel = [[ItemModel alloc] initWithrawDictionary:dic];
            itemModel.type = JudgeMent;
            [array addObject:itemModel];
        }
        
        self.judgement = [NSArray arrayWithArray:array];
        [array removeAllObjects];
        
        for (NSDictionary *dic in self.multiSelect) {
            
            ItemModel *itemModel = [[ItemModel alloc] initWithrawDictionary:dic];
            itemModel.type = Multil;
            [array addObject:itemModel];
        }
        
        self.multiSelect = [NSArray arrayWithArray:array];
        [array removeAllObjects];
        
        for (NSDictionary *dic in self.sel) {
            
            ItemModel *itemModel = [[ItemModel alloc] initWithrawDictionary:dic];
            itemModel.type = Select;
            [array addObject:itemModel];
        }
        
        self.sel = [NSArray arrayWithArray:array];
        [array removeAllObjects];
        
        for (NSDictionary *dic in self.shortAnswer) {
            
            ItemModel *itemModel = [[ItemModel alloc] initWithrawDictionary:dic];
            itemModel.type = ShortAnswer;
            [array addObject:itemModel];
        }
        
        self.shortAnswer = [NSArray arrayWithArray:array];
    }
    
    return self;
}


@end
