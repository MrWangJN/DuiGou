//
//  NewsViewController.m
//  StudyAssisTant
//
//  Created by wjn on 15/9/8.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "NewsViewController.h"

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:NO];
    
    [self.navigationItem setTitle:@"我的消息"];
    [self.view addSubview:self.tableView];
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:onceLogin.organizationCode, ORGANIZATIONCODE,
                                onceLogin.studentID, STUDENTID,
                                onceLogin.passWord, STUDENTPASSWORD, nil];
    [KVNProgress showWithStatus:@"正在加载中"];
    
    [SANetWorkingTask requestWithPost:[SAURLManager login] parmater:dictionary blockOrError:^(id result, NSError *error) {
        [KVNProgress dismiss];
        if ([result[@"flag"] isEqualToString:@"001"]) {
            for (NSDictionary *dic in result[@"message"]) {
                NewsModel *newsModel = [[NewsModel alloc] init];
                [newsModel setValuesForKeysWithDictionary:dic];
                [self.datasource addObject:newsModel];
            }
            if (!self.datasource.count) {
                [KVNProgress showErrorWithStatus:@"很遗憾的通知您\n暂时没有任何消息"];
                //                SCLAlertView *alert = [[SCLAlertView alloc] init];
                //                [alert addButton:@"确定" actionBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
                //                }];
                //                [alert showError:self title:@"很遗憾的通知您" subTitle:@"暂时没有任何消息" closeButtonTitle:nil duration:0.0f];
            }
            [self.tableView reloadData];
        } else {
            [KVNProgress showErrorWithStatus:@"很遗憾的通知您\n暂时没有任何消息"];
            //                SCLAlertView *alert = [[SCLAlertView alloc] init];
            //                [alert addButton:@"确定" actionBlock:^{
            [self.navigationController popViewControllerAnimated:YES];

        }

    }];
}

#pragma mark - private

- (NSMutableArray *)datasource {
    if (!_datasource) {
        self.datasource = [NSMutableArray arrayWithCapacity:0];
    }
    return _datasource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        self.tableView.height = self.tableView.height + 44;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        self.newsTableViewCell = [UINib nibWithNibName:@"NewsTableViewCell" bundle:nil];
        [_tableView registerNib:self.newsTableViewCell forCellReuseIdentifier:@"newsTableViewCell"];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsTableViewCell *cell = (NewsTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.width = tableView.width;
    return [cell getHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsTableViewCell"];
    if (self.datasource.count > indexPath.row) {
        [cell setNewsModel:self.datasource[self.datasource.count -  indexPath.row - 1]];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
