//
//  ExamListViewController.h
//  DuiHao
//
//  Created by wjn on 2017/3/16.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "SAKit.h"

typedef enum : NSUInteger {
    Exam,
    HomeWork,
    Exercise
} WorkType;

@interface ExamAndJobListViewController : SAViewController

@property (assign, nonatomic) WorkType type;

- (instancetype)initWithType:(WorkType )type;

@end
