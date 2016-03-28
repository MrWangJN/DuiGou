//
//  JudgeMentModel.m
//  StudyAssisTant
//
//  Created by 王建男 on 15/4/7.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "TextModel.h"

@implementation TextModel

- (instancetype)initWithrawDictionary:(NSDictionary *)rawDictionary {
	self = [super init];
	if (self) {
		[self setValuesForKeysWithDictionary:rawDictionary];
	}
	return self;
}

//纠错方法
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
	if ([key isEqual:@""]) {
		
	}
}

- (id)valueForUndefinedKey:(NSString *)key
{
	return nil;
}

@end
