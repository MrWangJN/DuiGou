//
//  AllResult.h
//  StudyAssisTant
//
//  Created by wjn on 15/9/7.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemModel.h"
#import "SAKit.h"

@interface AllResult : NSObject<NSCoding>

@property (strong, nonatomic) NSArray *fillBlankQuestion;
@property (strong, nonatomic) NSArray *judgeQuestion;
@property (strong, nonatomic) NSArray *multiSelectQuestion;
@property (strong, nonatomic) NSArray *selectQuestion;
@property (strong, nonatomic) NSArray *shortAnswerQuestion;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithCourseName:(NSString *)courseName;

- (void)writeToLocal:(NSString *)courseName;

@end
