//
//  Course.m
//  StudyAssisTant
//
//  Created by wjn on 15/8/27.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "Course.h"

@implementation Course

- (id)initWithDictionary:(NSDictionary *)dictionary children:(NSArray *)array {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
        self.children = [NSArray arrayWithArray:array];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
