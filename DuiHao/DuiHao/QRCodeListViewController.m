//
//  QRCodeListViewController.m
//  DuiHao
//
//  Created by wjn on 2017/3/28.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "QRCodeListViewController.h"
#import "OnceLogin.h"
#import "AttendanceModel.h"
#import "AttendanceTableViewCell.h"

@interface QRCodeListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation QRCodeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.[self.navigationItem setTitle:@"课件"];
    
    [self getData];
    [self.view addSubview:self.tableView];
    
    [self setHintImage:@"NoSign" whihHight:64];
    
    [self.navigationItem setTitle:@"考勤记录"];
}

#pragma mark - private

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        //        self.tableView.height += 44;
        _tableView.backgroundColor = TABLEBACKGROUND;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"AttendanceTableViewCell" bundle:nil] forCellReuseIdentifier:@"AttendanceTableViewCell"];
    }
    return _tableView;
}

- (void)getData {
//    SAKeyValueStore *store = [[SAKeyValueStore alloc] initDBWithName:@"test.db"];
//    [store createTableWithName:@"qrcode"];
//    
//    //    NSDictionary *queryUser = [store getObjectById:@"2" fromTable:tableName];
//    self.dataSource =(NSMutableArray *) [store getAllItemsFromTable:@"qrcode"];
//    
//    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
//    for (SAKeyValueItem *dic in self.dataSource) {
//        [arr addObject:dic.itemObject];
//    }
//    self.dataSource = [NSMutableArray arrayWithArray:arr];
    
    [JKAlert alertWaitingText:@"正在加载"];
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    if ([onceLogin.studentID isEqualToString:@"未绑定"]) {
        [JKAlert alertText:@"请完善个人信息"];
        [self.navigationController popViewControllerAnimated:YES];
        return ;
    }
    
    [SANetWorkingTask requestWithPost:[SAURLManager getAttendance] parmater:@{STUDENTID: onceLogin.studentID} blockOrError:^(id result, NSError *error) {
       
        [JK_M dismissElast];
        
        if (error) {
            if (!self.dataSource.count || !self.dataSource) {
                [self hiddenHint];
            } else {
                [self.tableView reloadData];
                [self noHiddenHint];
            }
            return ;
        }
        
        if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
            result = result[RESULT];
            result = result[LISTS];
            for (NSDictionary *dic in result) {
                AttendanceModel *attendanceModel = [[AttendanceModel alloc] initWithRawModel:dic];
                [self.dataSource addObject:attendanceModel];
            }
            [self.tableView reloadData];
        }
        
        if (!self.dataSource.count || !self.dataSource) {
            [self hiddenHint];
        } else {
            [self noHiddenHint];
        }
        self.backBtu.userInteractionEnabled = YES;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AttendanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttendanceTableViewCell"];
   
    
    cell.attendanceModel = self.dataSource[indexPath.section];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 重载父类方法

- (void)hiddenHint {
    [super hiddenHint];
    self.tableView.hidden = YES;
}

- (void)noHiddenHint {
    [super noHiddenHint];
    self.tableView.hidden = NO;
}

- (void)backBtuDidPress {
    [self getData];
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
