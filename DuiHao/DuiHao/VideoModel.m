//
//  VideoModel.m
//  DuiHao
//
//  Created by wjn on 2017/7/18.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel

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
