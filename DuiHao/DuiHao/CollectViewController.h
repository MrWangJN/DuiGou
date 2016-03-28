//
//  CollectViewController.h
//  StudyAssisTant
//
//  Created by wjn on 15/10/7.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"
#import "ExerciseTableViewCell.h"
#import "Course.h"
#import "TextViewController.h"

@interface CollectViewController : SAViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datasource;
@property (strong, nonatomic) UINib *exerciseTableViewCell;
@property (strong, nonatomic) Course *course;

- (instancetype)initWithCourse:(Course *)course;

@end
