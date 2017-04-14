//
//  ExamListModel.m
//  DuiHao
//
//  Created by wjn on 2017/3/21.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "ExamJobListModel.h"

@implementation ExamJobListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"exam"] || [key isEqualToString:@"homework"] || [key isEqualToString:@"exercise"]) {
        self.name = value;
    }
    
    if ([key isEqualToString:@"examId"] || [key isEqualToString:@"homeworkId"] || [key isEqualToString:@"exerciseId"]) {
        self.modelId = value;
    }
}

@end
