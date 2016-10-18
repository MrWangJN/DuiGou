//
//  OptionModel.m
//  DuiHao
//
//  Created by wjn on 16/7/27.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "OptionModel.h"

@implementation OptionModel

- (instancetype)initWithrawDictionary:(NSDictionary *)dictionary {
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

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.option forKey:@"option"];
    [aCoder encodeObject:self.optionImage forKey:@"optionImage"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        
        self.option = [aDecoder decodeObjectForKey:@"option"];
        self.optionImage = [aDecoder decodeObjectForKey:@"optionImage"];
        
    }
    return self;
    
}


- (NSDictionary *)getDistionary {
    
    return @{@"option": self.option, @"optionImage": self.optionImage};
    
}

@end
