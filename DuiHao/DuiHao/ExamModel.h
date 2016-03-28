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
@property (copy, nonatomic) NSString *examLength;

@property (strong, nonatomic) NSArray *fillBlank;
@property (strong, nonatomic) NSArray *judgement;
@property (strong, nonatomic) NSArray *multiSelect;
@property (strong, nonatomic) NSArray *sel;
@property (strong, nonatomic) NSArray *shortAnswer;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
