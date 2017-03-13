//
//  BannerModel.m
//  DuiHao
//
//  Created by wjn on 2017/2/20.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "BannerModel.h"

@implementation BannerModel

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
