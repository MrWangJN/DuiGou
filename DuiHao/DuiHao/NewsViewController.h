//
//  NewsViewController.h
//  StudyAssisTant
//
//  Created by wjn on 15/9/8.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAViewController.h"
#import "NewsTableViewCell.h"
#import "OnceLogin.h"
#import "NewsModel.h"

@interface NewsViewController : SAViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datasource;
@property (strong, nonatomic) UINib *newsTableViewCell;

@end
