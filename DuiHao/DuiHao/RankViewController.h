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
#import "OpenPrivacyState.h"

@interface RankViewController : SAViewController<UITableViewDataSource, UITableViewDelegate, OpenPrivacyStateDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UINib *rankTableViewCell;
@property (strong, nonatomic) UINib *myRankTableViewCell;

@property (strong, nonatomic) NSString *studentID;
@property (strong, nonatomic) NSString *schoolNum;

- (instancetype)initWithCourse:(Course *)course;

@end
