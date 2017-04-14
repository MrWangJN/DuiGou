//
//  SAModel.m
//  SAFramework
//
//  Created by 王建男 on 15/3/7.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAModel.h"

@implementation SAModel

- (instancetype)initWithRawModel:(NSDictionary *)rawModel {
    
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:rawModel];
    }
    return self;
}

- (void)updateWithRawModel:(NSDictionary *)rawModel {
	
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
