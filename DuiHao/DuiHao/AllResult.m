//
//  AllResult.m
//  StudyAssisTant
//
//  Created by wjn on 15/9/7.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "AllResult.h"

@implementation AllResult

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        
        if (dictionary) {
            dictionary = dictionary[RESULT];
            [self setValuesForKeysWithDictionary:dictionary];
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *dic in self.fillBlankQuestion) {
                
                ItemModel *itemModel = [[ItemModel alloc] initWithrawDictionary:dic];
                itemModel.type = FillBank;
                [array addObject:itemModel];
            }
            self.fillBlankQuestion = [[NSArray alloc] initWithArray:array];
            [array removeAllObjects];
            
            for (NSDictionary *dic in self.judgeQuestion) {
                
                ItemModel *itemModel = [[ItemModel alloc] initWithrawDictionary:dic];
                itemModel.type = JudgeMent;
                [array addObject:itemModel];
            }
            
            self.judgeQuestion = [[NSArray alloc] initWithArray:array];
            [array removeAllObjects];
            
            for (NSDictionary *dic in self.multiSelectQuestion) {
                
                ItemModel *itemModel = [[ItemModel alloc] initWithrawDictionary:dic];
                itemModel.type = Multil;
                [array addObject:itemModel];
            }
            
            self.multiSelectQuestion = [[NSArray alloc] initWithArray:array];
            [array removeAllObjects];
            
            for (NSDictionary *dic in self.selectQuestion) {
                
                ItemModel *itemModel = [[ItemModel alloc] initWithrawDictionary:dic];
                itemModel.type = Select;
                [array addObject:itemModel];
            }
            
            self.selectQuestion = [[NSArray alloc] initWithArray:array];
            [array removeAllObjects];
            
            for (NSDictionary *dic in self.shortAnswerQuestion) {
                
                ItemModel *itemModel = [[ItemModel alloc] initWithrawDictionary:dic];
                itemModel.type = ShortAnswer;
                [array addObject:itemModel];
            }
            
            self.shortAnswerQuestion = [NSArray arrayWithArray:array];
        }
    }
    
    return self;
}

- (instancetype)initWithCourseName:(NSString *)courseName {
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *path = [paths firstObject];
        path = [NSString stringWithFormat:@"%@/%@", path, courseName];
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        
        if ([fileManager fileExistsAtPath:path]) {
            NSData *data = [NSData dataWithContentsOfFile:path];
            self = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        } else {
            return nil;
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.fillBlankQuestion forKey:@"fillBlank"];
    [aCoder encodeObject:self.judgeQuestion forKey:@"judgement"];
    [aCoder encodeObject:self.multiSelectQuestion forKey:@"multiSelect"];
    [aCoder encodeObject:self.selectQuestion forKey:@"sel"];
    [aCoder encodeObject:self.shortAnswerQuestion forKey:@"shortAnswer"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        self.fillBlankQuestion = [aDecoder decodeObjectForKey:@"fillBlank"];
        self.judgeQuestion = [aDecoder decodeObjectForKey:@"judgement"];
        self.multiSelectQuestion = [aDecoder decodeObjectForKey:@"multiSelect"];
        self.selectQuestion = [aDecoder decodeObjectForKey:@"sel"];
        self.shortAnswerQuestion = [aDecoder decodeObjectForKey:@"shortAnswer"];
    }
    return self;
    
}

- (NSArray *)selectQuestion {
    if (_selectQuestion.count&&[_selectQuestion[0] isKindOfClass:[ItemModel class]]) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (ItemModel *item in _selectQuestion) {
            
            ItemModel *itemModel = [[ItemModel alloc] initWithItemModel:item];
            itemModel.select = 0;
            itemModel.answers = nil;
            [array addObject:itemModel];
        }
        _selectQuestion = [NSArray arrayWithArray:array];
    }
    return _selectQuestion;
}

- (NSArray *)judgeQuestion {
    if (_judgeQuestion.count&&[_judgeQuestion[0] isKindOfClass:[ItemModel class]]) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (ItemModel *item in _judgeQuestion) {
            ItemModel *itemModel = [[ItemModel alloc] initWithItemModel:item];
            itemModel.select = 0;
            itemModel.answers = nil;
            [array addObject:itemModel];
        }
        _judgeQuestion = [NSArray arrayWithArray:array];
    }
    return _judgeQuestion;

}

- (NSArray *)multiSelectQuestion {
    if (_multiSelectQuestion.count&&[_multiSelectQuestion[0] isKindOfClass:[ItemModel class]]) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (ItemModel *item in _multiSelectQuestion) {
            ItemModel *itemModel = [[ItemModel alloc] initWithItemModel:item];
            itemModel.select = 0;
            itemModel.answers = nil;
            [array addObject:itemModel];
        }
        _multiSelectQuestion = [NSArray arrayWithArray:array];
    }
    return _multiSelectQuestion;

}

- (NSArray *)fillBlankQuestion {
    if (_fillBlankQuestion.count&&[_fillBlankQuestion[0] isKindOfClass:[ItemModel class]]) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (ItemModel *item in _fillBlankQuestion) {
            ItemModel *itemModel = [[ItemModel alloc] initWithItemModel:item];
            itemModel.select = 0;
            itemModel.answers = nil;
            [array addObject:itemModel];
        }
        _fillBlankQuestion = [NSArray arrayWithArray:array];
    }
    return _fillBlankQuestion;

}

- (NSArray *)shortAnswerQuestion {
    if (_shortAnswerQuestion.count&&[_shortAnswerQuestion[0] isKindOfClass:[ItemModel class]]) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (ItemModel *item in _shortAnswerQuestion) {
            ItemModel *itemModel = [[ItemModel alloc] initWithItemModel:item];
            itemModel.select = 0;
            itemModel.answers = nil;
            [array addObject:itemModel];
        }
        _shortAnswerQuestion = [NSArray arrayWithArray:array];
    }
    return _shortAnswerQuestion;

}

- (void)writeToLocal:(NSString *)courseName {
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    path = [NSString stringWithFormat:@"%@/%@", path, courseName];
    [data writeToFile:path atomically:YES];
    
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

@end
