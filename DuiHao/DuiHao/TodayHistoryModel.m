//
//  TodayHistoryModel.m
//  DuiHao
//
//  Created by wjn on 2016/12/29.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "TodayHistoryModel.h"

@implementation TodayHistoryModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

// 纠错方法
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
