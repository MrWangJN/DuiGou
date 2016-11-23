//
//  ExamModel.h
//  StudyAssisTant
//
//  Created by wjn on 15/10/3.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemModel.h"

@interface ExamModel : NSObject

@property (copy, nonatomic) NSString *examId;
@property (copy, nonatomic) NSString *timeLength;

@property (strong, nonatomic) NSArray *fillBlankQuestion;
@property (strong, nonatomic) NSArray *judgeQuestion;
@property (strong, nonatomic) NSArray *multiSelectQuestion;
@property (strong, nonatomic) NSArray *selectQuestion;
@property (strong, nonatomic) NSArray *shortQuestion;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
