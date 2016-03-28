//
//  RankViewController.h
//  StudyAssisTant
//
//  Created by wjn on 15/9/21.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"
#import "RankTableViewCell.h"
#import "RankModel.h"
#import "OnceLogin.h"
#import "Course.h"
#import "RankImageHeaderTableViewCell.h"
#import "MyRankTableViewCell.h"
#import "RankCourseTableViewCell.h"

@interface RankViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITableView *courseTableView;
@property (strong, nonatomic) NSMutableArray *datasource;
@property (strong, nonatomic) NSMutableArray *courseDatasource;
@property (strong, nonatomic) UINib *rankTableViewCell;
@property (strong, nonatomic) UINib *rankImageHeaderTableViewCell;
@property (strong, nonatomic) UINib *myRankTableViewCell;
@property (strong, nonatomic) UINib *rankCourseTableViewCell;

@property (strong, nonatomic) NSString *studentID;
@property (strong, nonatomic) NSString *schoolNum;

@end
