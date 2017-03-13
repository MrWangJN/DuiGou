//
//  TodayHistoryViewController.m
//  DuiHao
//
//  Created by wjn on 2016/12/30.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "TodayHistoryViewController.h"
#import "TitleView.h"
#import "TodayHistoryPicModel.h"
#import "TodayHistoryPicTableViewCell.h"

@interface TodayHistoryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datasource;
@property (strong, nonatomic) TitleView *titleView;
@property (strong, nonatomic) UINib *todayHistoryPicTableViewCell;

@end

@implementation TodayHistoryViewController

- (instancetype)initWithTodayHistoryModel:(TodayHistoryModel *)todayHistory {
    self = [super init];
    if (self) {
        [self getDatasource:todayHistory.e_id];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationItem setTitle:@"历史上的今天"];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

#pragma mark - private

- (void)getDatasource:(NSString *)e_id {
    [SANetWorkingTask requestWithPost:[SAURLManager getTodayHistoryDetail] parmater:@{@"key": @"e70fb3049d48a00ed3b9b1b7f8447d9d", @"e_id": e_id} block:^(id result) {
       
        if ([result[@"reason"] isEqualToString:@"success"]) {
            
            NSDictionary *data = [result[@"result"] firstObject];
            
            [self.titleView setDetail:[NSString stringWithFormat:@"%@\n\n%@", data[@"title"], data[@"content"]]];
             self.tableView.tableHeaderView = self.titleView;
            
            for (NSDictionary *dic in data[@"picUrl"]) {
                TodayHistoryPicModel *model = [[TodayHistoryPicModel alloc] initWithDictionary:dic];
                [self.datasource addObject:model];
            }
    
            [self.tableView reloadData];
        }
    }];
}

- (NSMutableArray *)datasource {
    if (!_datasource) {
        self.datasource = [NSMutableArray arrayWithCapacity:0];
    }
    return _datasource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableHeaderView = self.titleView;
        UIImageView *footerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"End"]];
        footerImageView.contentMode = UIViewContentModeScaleAspectFit;
        footerImageView.frame = CGRectMake(0, 0, WIDTH, 20);
        _tableView.tableFooterView = footerImageView;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        self.todayHistoryPicTableViewCell = [UINib nibWithNibName:@"TodayHistoryPicTableViewCell" bundle:nil];
        [_tableView registerNib:self.todayHistoryPicTableViewCell forCellReuseIdentifier:@"todayHistoryPicTableViewCell"];
    }
    return _tableView;
}

- (TitleView *)titleView {
    if (!_titleView) {
        self.titleView = [[NSBundle mainBundle] loadNibNamed:@"TitleView" owner:self options:nil][0];
        self.titleView.frame = CGRectMake(0, 0, WIDTH, 0);
    }
    return _titleView;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TodayHistoryPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todayHistoryPicTableViewCell"];
    if (indexPath.row < self.datasource.count) {
        cell.todayHistoryPicModel = self.datasource[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 265;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
