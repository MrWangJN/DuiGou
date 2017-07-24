//
//  ChildVideoModel.m
//  DuiHao
//
//  Created by wjn on 2017/7/18.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "ChildVideoModel.h"

@implementation ChildVideoModel

- (id)initWithDic:(NSDictionary *)dic children:(NSArray *)array {
    self = [super init];
    if (self) {
//        self.children = [NSArray arrayWithArray:array];
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (id)dataObjectWithDic:(NSDictionary *)dic children:(NSArray *)children
{
    return [[self alloc] initWithDic:dic children:children];
}

- (void)addChild:(id)child
{
    NSMutableArray *children = [self.children mutableCopy];
    [children insertObject:child atIndex:0];
    self.children = [children copy];
}

- (void)removeChild:(id)child
{
    NSMutableArray *children = [self.children mutableCopy];
    [children removeObject:child];
    self.children = [children copy];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
