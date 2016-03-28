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
            [self setValuesForKeysWithDictionary:dictionary];
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *dic in self.fillBlank) {
                
                ItemModel *itemModel = [[ItemModel alloc] initWithrawDictionary:dic];
                itemModel.type = FillBank;
                [array addObject:itemModel];
            }
            self.fillBlank = [[NSArray alloc] initWithArray:array];
            [array removeAllObjects];
            
            for (NSDictionary *dic in self.judgement) {
                
                ItemModel *itemModel = [[ItemModel alloc] initWithrawDictionary:dic];
                itemModel.type = JudgeMent;
                [array addObject:itemModel];
            }
            
            self.judgement = [[NSArray alloc] initWithArray:array];
            [array removeAllObjects];
            
            for (NSDictionary *dic in self.multiSelect) {
                
                ItemModel *itemModel = [[ItemModel alloc] initWithrawDictionary:dic];
                itemModel.type = Multil;
                [array addObject:itemModel];
            }
            
            self.multiSelect = [[NSArray alloc] initWithArray:array];
            [array removeAllObjects];
            
            for (NSDictionary *dic in self.sel) {
                
                ItemModel *itemModel = [[ItemModel alloc] initWithrawDictionary:dic];
                itemModel.type = Select;
                [array addObject:itemModel];
            }
            
            self.sel = [[NSArray alloc] initWithArray:array];
            [array removeAllObjects];
            
            for (NSDictionary *dic in self.shortAnswer) {
                
                ItemModel *itemModel = [[ItemModel alloc] initWithrawDictionary:dic];
                itemModel.type = ShortAnswer;
                [array addObject:itemModel];
            }
            
            self.shortAnswer = [NSArray arrayWithArray:array];
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
    [aCoder encodeObject:self.fillBlank forKey:@"fillBlank"];
    [aCoder encodeObject:self.judgement forKey:@"judgement"];
    [aCoder encodeObject:self.multiSelect forKey:@"multiSelect"];
    [aCoder encodeObject:self.sel forKey:@"sel"];
    [aCoder encodeObject:self.shortAnswer forKey:@"shortAnswer"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        self.fillBlank = [aDecoder decodeObjectForKey:@"fillBlank"];
        self.judgement = [aDecoder decodeObjectForKey:@"judgement"];
        self.multiSelect = [aDecoder decodeObjectForKey:@"multiSelect"];
        self.sel = [aDecoder decodeObjectForKey:@"sel"];
        self.shortAnswer = [aDecoder decodeObjectForKey:@"shortAnswer"];
    }
    return self;
    
}

- (NSArray *)sel {
    if (_sel.count&&[_sel[0] isKindOfClass:[ItemModel class]]) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (ItemModel *item in _sel) {
            
            ItemModel *itemModel = [[ItemModel alloc] initWithItemModel:item];
            itemModel.select = 0;
            itemModel.answers = nil;
            [array addObject:itemModel];
        }
        _sel = [NSArray arrayWithArray:array];
    }
    return _sel;
}

- (NSArray *)judgement {
    if (_judgement.count&&[_judgement[0] isKindOfClass:[ItemModel class]]) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (ItemModel *item in _judgement) {
            ItemModel *itemModel = [[ItemModel alloc] initWithItemModel:item];
            itemModel.select = 0;
            itemModel.answers = nil;
            [array addObject:itemModel];
        }
        _judgement = [NSArray arrayWithArray:array];
    }
    return _judgement;

}

- (NSArray *)multiSelect {
    if (_multiSelect.count&&[_multiSelect[0] isKindOfClass:[ItemModel class]]) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (ItemModel *item in _multiSelect) {
            ItemModel *itemModel = [[ItemModel alloc] initWithItemModel:item];
            itemModel.select = 0;
            itemModel.answers = nil;
            [array addObject:itemModel];
        }
        _multiSelect = [NSArray arrayWithArray:array];
    }
    return _multiSelect;

}

- (NSArray *)fillBlank {
    if (_fillBlank.count&&[_fillBlank[0] isKindOfClass:[ItemModel class]]) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (ItemModel *item in _fillBlank) {
            ItemModel *itemModel = [[ItemModel alloc] initWithItemModel:item];
            itemModel.select = 0;
            itemModel.answers = nil;
            [array addObject:itemModel];
        }
        _fillBlank = [NSArray arrayWithArray:array];
    }
    return _fillBlank;

}

- (NSArray *)shortAnswer {
    if (_shortAnswer.count&&[_shortAnswer[0] isKindOfClass:[ItemModel class]]) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (ItemModel *item in _shortAnswer) {
            ItemModel *itemModel = [[ItemModel alloc] initWithItemModel:item];
            itemModel.select = 0;
            itemModel.answers = nil;
            [array addObject:itemModel];
        }
        _shortAnswer = [NSArray arrayWithArray:array];
    }
    return _shortAnswer;

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
