//
//  OrganizationModel.m
//  DuiHao
//
//  Created by wjn on 16/5/30.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "OrganizationModel.h"

@implementation OrganizationModel

- (instancetype)initWithResult:(NSDictionary *)result
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:result];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

@end
