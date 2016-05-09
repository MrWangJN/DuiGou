//
//  MainViewController.m
//  StudyAssisTant
//
//  Created by wjn on 15/8/25.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "MainViewController.h"
#import "BindInformationViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController


- (void)viewWillAppear:(BOOL)animated {
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController.navigationBar setHidden:YES];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = false;
    [self.view addSubview:self.tableView];
}


#pragma mark - private

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        self.personalHeadTableViewCell = [UINib nibWithNibName:@"PersonalTableViewCell" bundle:nil];
        [_tableView registerNib:self.personalHeadTableViewCell forCellReuseIdentifier:@"PersonalTableViewCell"];
        self.mineUITableViewCell = [UINib nibWithNibName:@"MineUITableViewCell" bundle:nil];
        [_tableView registerNib:self.mineUITableViewCell forCellReuseIdentifier:@"MineUITableViewCell"];

    }
    return _tableView;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 260;
    }
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    
    if (indexPath.row == 0) {
        PersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalTableViewCell"];
        [cell reloadPersonCell];
//        [cell setImageHeaderView:onceLogin.imageURL];
//        [cell.userLabel setText:onceLogin.sName];
        return cell;
    } else {
        MineUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineUITableViewCell"];
        
        if (indexPath.row == 1) {
            
            [cell.functionImage setImage:[UIImage imageNamed:@"Message"]];
            [cell.functionLabel setText:@"我的消息"];
            
        } else {
            
            [cell.functionImage setImage:[UIImage imageNamed:@"Set"]];
            [cell.functionLabel setText:@"我的设置"];
            
        }
        
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        BindInformationViewController *bindInformationVC = [[BindInformationViewController alloc] init];
        
        [self.navigationController pushViewController:bindInformationVC animated:YES];
    }
    
    if (indexPath.row == 1) {
        NewsViewController *newsViewController = [[NewsViewController alloc] init];
        [self.navigationController pushViewController:newsViewController animated:YES];
    }
    
    if (indexPath.row == 2) {
        MineSetViewController *mineSetViewController = [[MineSetViewController alloc] init];
        [self.navigationController pushViewController:mineSetViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
