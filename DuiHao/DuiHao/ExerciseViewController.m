//
//  ExerciseViewController.m
//  StudyAssisTant
//
//  Created by wjn on 15/9/4.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "ExerciseViewController.h"

@interface ExerciseViewController ()

@end

@implementation ExerciseViewController

- (instancetype)initWithCourse:(Course *)course {
    self = [super init];
    if (self) {
        self.course = course;
    }
    return self;
}



- (void)viewWillAppear:(BOOL)animated {
//    [self getExercise];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBarController.tabBar setHidden:YES];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:self.course.courseName];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Update"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonDidPress)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    [self.view addSubview:self.tableView];
    [self getExercise];
}

- (void)viewDidLayoutSubviews {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (UpdateView *)updateView {
    if (!_updateView) {
        self.updateView = [[NSBundle mainBundle] loadNibNamed:@"UpdateView" owner:self options:nil][0];
        _updateView.frame = self.updateView.frame = CGRectMake(self.view.width - 138, -50, 128, 105);
        _updateView.delegate = self;
        [self.view addSubview:_updateView];
    }
    return _updateView;
}

- (void)getExercise {
    
    self.allResult = [[AllResult alloc] initWithCourseName:self.course.courseName];
    
    NSDictionary *dic = @{TEACHERALIASNAME : self.course.teacherAliasName, COURSEALIAS : self.course.courseAlias};
    if (!self.allResult) {
        [KVNProgress showWithStatus:@"正在获取试题"];
        [SANetWorkingTask requestWithPost:[SAURLManager downloadQuestion] parmater:dic block:^(id result) {
            [KVNProgress dismiss];
            self.allResult = [[AllResult alloc] initWithDictionary:result];
            [self.allResult writeToLocal:self.course.courseName];
        }];
    }
    if ([SAReachabilityManager sharedReachabilityManager].currentReachabilityStatus == ReachableViaWiFi) {
        [SANetWorkingTask requestWithPost:[SAURLManager downloadQuestion] parmater:dic block:^(id result) {
            [KVNProgress dismiss];
            self.allResult = [[AllResult alloc] initWithDictionary:result];
            [self.allResult writeToLocal:self.course.courseName];
        }];
    }
}

- (NSMutableArray *)datasource {
    if (!_datasource) {
        self.datasource = [NSMutableArray arrayWithObjects:@"在线考试", @"全真模拟", @"我的收藏", @"单选题顺序练习", @"单选题随机练习", @"多选题顺序练习", @"多选题随机练习", @"判断题顺序练习", @"判断题随机练习", @"填空题顺序练习", @"填空题随机练习", @"简答题顺序练习", @"简答题随机练习", nil];
    }
    return _datasource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        self.tableView.height += 44;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        self.exerciseTableViewCell = [UINib nibWithNibName:@"ExerciseTableViewCell" bundle:nil];
        [_tableView registerNib:self.exerciseTableViewCell forCellReuseIdentifier:@"exerciseTableViewCell"];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ExerciseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"exerciseTableViewCell"];
    if (self.datasource.count > indexPath.row) {
        cell.optionLabel.text = self.datasource[indexPath.row];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CollectionViewType collectionViewType = SelectOrder;
    NSArray *dataSource;
    
    if (indexPath.row == OnlineExam) {
        
        OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
        
        NSDictionary *dic = @{TEACHERALIASNAME : self.course.teacherAliasName, COURSEALIAS : self.course.courseAlias, SCHOOLNUMBER : onceLogin.schoolNumber, STUDENTID : onceLogin.studentID};
        [KVNProgress showWithStatus:@"正在查询考试是否开通"];
        NSMutableArray *datasource = [NSMutableArray arrayWithCapacity:0];
        
        [SANetWorkingTask requestWithPost:[SAURLManager isOpenExam] parmater:dic block:^(id result) {
            
            [KVNProgress dismiss];
            if ([result[@"flag"] isEqualToString:@"002"]) {
                [KVNProgress showErrorWithStatus:@"您已经提交过本次试题"];
                
            }
            if ([result[@"flag"] isEqualToString:@"004"]) {
                [KVNProgress showErrorWithStatus:@"暂未开通本次考试"];
                
            }
            if ([result[@"flag"] isEqualToString:@"001"]) {
                ExamModel *examModel = [[ExamModel alloc] initWithDictionary:result];
                
                if (examModel.examId.length) {
                    ExamViewController *examViewController = [[ExamViewController alloc] initWithCouse:self.course withExam:examModel];
                    SCLAlertView *alert = [[SCLAlertView alloc] init];
                    [alert addButton:@"确定" actionBlock:^(void) {
                        [self.navigationController pushViewController:examViewController animated:YES];
                    }];
                    [alert addButton:@"取消" actionBlock:^(void) {
                    }];
                    [alert showWarning:self title:@"警告" subTitle:@"考试过程中请勿退出本程序，考试即将开始，祝君取得好成绩" closeButtonTitle:nil duration:0.0f];
                } else {
                    [KVNProgress showErrorWithStatus:@"暂未获取到考试题"];
                }
            }
        }];
    } else if (indexPath.row == ExamText) {
        
        ExamViewController *examViewController = [[ExamViewController alloc] initWithAllCouse:self.allResult];
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        
        if (self.allResult.sel.count < 80 || self.allResult.multiSelect.count < 10 || self.allResult.judgement.count <10) {
            [KVNProgress showErrorWithStatus:@"习题数量未达到\n全真模拟要求"];
            return;
        }

        
        [alert addButton:@"确定" actionBlock:^(void) {
            [self.navigationController pushViewController:examViewController animated:YES];
        }];
        [alert addButton:@"取消" actionBlock:^(void) {
        }];
        [alert showWarning:self title:@"警告" subTitle:@"是否开启本次考试" closeButtonTitle:nil duration:0.0f];

        
        
    } else if (indexPath.row == Collect) {
        
        CollectViewController *collectViewController = [[CollectViewController alloc] initWithCourse:self.course];
        [self.navigationController pushViewController:collectViewController animated:YES];
        
    } else {
    
        if (indexPath.row == SelectOrder) {
            collectionViewType = SelectOrder;
            dataSource = self.allResult.sel;
        }
        if (indexPath.row == SelectRandom) {
            collectionViewType = SelectRandom;
            dataSource = self.allResult.sel;
        }
        if (indexPath.row == MultiSelect) {
            collectionViewType = MultiSelect;
            dataSource = self.allResult.multiSelect;
        }
        if (indexPath.row == MultiSelectRandom) {
            collectionViewType = MultiSelectRandom;
            dataSource = self.allResult.multiSelect;
        }
        if (indexPath.row == JudgeMentOrder) {
            collectionViewType = JudgeMentOrder;
            dataSource = self.allResult.judgement;
        }
        if (indexPath.row == JudgeMentRandom) {
            collectionViewType = JudgeMentRandom;
            dataSource = self.allResult.judgement;
        }
        if (indexPath.row == FillBankOrder) {
            collectionViewType = FillBankOrder;
            dataSource = self.allResult.fillBlank;
        }
        if (indexPath.row == FillBankRandom) {
            collectionViewType = FillBankRandom;
            dataSource = self.allResult.fillBlank;
        }
        if (indexPath.row == ShortAnswerOrder) {
            collectionViewType = ShortAnswerOrder;
            dataSource = self.allResult.shortAnswer;
        }
        if (indexPath.row == ShortAnswerRandom) {
            collectionViewType = ShortAnswerRandom;
            dataSource = self.allResult.shortAnswer;
        }
        
        if (dataSource.count) {
            TextViewController *textViewController = [[TextViewController alloc] initWithType:collectionViewType withDatasource:dataSource];
            [self.navigationController pushViewController:textViewController animated:YES];
            return;
        }
        
        [KVNProgress showErrorWithStatus:@"暂时没有本类练习题"];
    }
}

#pragma mark - rightButton

- (void)rightButtonDidPress {
//    [self.navigationController popViewControllerAnimated:YES];
    if (self.updateView.show) {
        [UIView animateWithDuration:0.5 animations:^{
            self.updateView.frame = CGRectMake(self.view.width - 138, -50, 128, 105);
        }];
//        [self.updateView removeFromSuperview];
        self.updateView.show = NO;
    } else {
//        [self.view addSubview:self.updateView];
        [UIView animateWithDuration:0.5 animations:^{
           self.updateView.frame = CGRectMake(self.view.width - 138, 52, 128, 105);
        }];
        self.updateView.show = YES;
    }
}

#pragma mark - UpdateViewDelegate

- (void)updateDatasource {
    NSDictionary *dic = @{TEACHERALIASNAME : self.course.teacherAliasName, COURSEALIAS : self.course.courseAlias};
        [KVNProgress showWithStatus:@"正在更新试题"];
        [SANetWorkingTask requestWithPost:[SAURLManager downloadQuestion] parmater:dic block:^(id result) {
            [KVNProgress dismiss];
            self.allResult = [[AllResult alloc] initWithDictionary:result];
            [self.allResult writeToLocal:self.course.courseName];
            [KVNProgress showSuccessWithStatus:@"更新成功"];
        }];
    if (self.updateView.show) {
        [UIView animateWithDuration:0.5 animations:^{
            self.updateView.frame = CGRectMake(self.view.width - 138, -50, 128, 105);
        }];
        //        [self.updateView removeFromSuperview];
        self.updateView.show = NO;
    } else {
        //        [self.view addSubview:self.updateView];
        [UIView animateWithDuration:0.5 animations:^{
            self.updateView.frame = CGRectMake(self.view.width - 138, 52, 128, 105);
        }];
        self.updateView.show = YES;
    }

}

- (void)removeDatasource {
    if (self.updateView.show) {
        [UIView animateWithDuration:0.5 animations:^{
            self.updateView.frame = CGRectMake(self.view.width - 138, -50, 128, 105);
        }];
        //        [self.updateView removeFromSuperview];
        self.updateView.show = NO;
        
        SAKeyValueStore *store = [[SAKeyValueStore alloc] initDBWithName:@"test.db"];
        for (int i = 0; i < 5; i++) {
            NSString *tableName = [NSString stringWithFormat:@"%@_%d", self.course.courseAlias, i];
            [store clearTable:tableName];
        }
        [KVNProgress showSuccessWithStatus:@"已清除全部记录"];
        
    } else {
        //        [self.view addSubview:self.updateView];
        [UIView animateWithDuration:0.5 animations:^{
            self.updateView.frame = CGRectMake(self.view.width - 138, 52, 128, 105);
        }];
        self.updateView.show = YES;
    }

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
