//
//  SearchViewController.h
//  StudyAssisTant
//
//  Created by wjn on 15/8/20.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"

@protocol SearchViewControllerDelegate;

@interface SearchViewController : SAViewController<UISearchBarDelegate, LocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) id<SearchViewControllerDelegate>delegate;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) LocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *showLocation;

@property (strong, nonatomic) NSMutableArray *datasource;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@protocol SearchViewControllerDelegate <NSObject>

- (void)schoolAndNumber:(NSDictionary *)school;

@end