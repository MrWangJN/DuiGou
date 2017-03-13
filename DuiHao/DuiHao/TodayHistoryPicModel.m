//
//  TodayHistoryPicModel.m
//  DuiHao
//
//  Created by wjn on 2016/12/30.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "TodayHistoryPicModel.h"

@implementation TodayHistoryPicModel

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
