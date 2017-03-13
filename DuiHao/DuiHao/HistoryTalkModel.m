//
//  HistoryTalkModel.m
//  DuiHao
//
//  Created by wjn on 2017/2/21.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "HistoryTalkModel.h"

@implementation HistoryTalkModel

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
