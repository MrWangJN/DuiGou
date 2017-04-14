//
//  ExerciseViewController.h
//  StudyAssisTant
//
//  Created by wjn on 15/9/4.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"
#import "ExerciseTableViewCell.h"
#import "Course.h"
#import "AllResult.h"
#import "ExamModel.h"
#import "TextViewController.h"
#import "ExamViewController.h"
#import "CollectViewController.h"

@interface ExerciseViewController : SAViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *datasource;
@property (strong, nonatomic) UINib *exerciseTableViewCell;
@property (strong, nonatomic) Course *course;
@property (strong, nonatomic) AllResult *allResult;

@end
