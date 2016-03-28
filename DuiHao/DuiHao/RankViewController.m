//
//  RankViewController.m
//  StudyAssisTant
//
//  Created by wjn on 15/9/21.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "RankViewController.h"

@interface RankViewController ()

@property (nonatomic, assign) BOOL show;

@end

@implementation RankViewController

- (void)viewWillAppear:(BOOL)animated {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"Rank"]) {
        
        if (!self.show) {
            UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
            view.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:view];
            
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert addButton:@"确定" actionBlock:^{
                [defaults setBool:YES forKey:@"Rank"];
                [defaults synchronize];
                [self reloadDataView];
                [view removeFromSuperview];
            }];
            [alert showWarning:self title:@"是否允许继续" subTitle:@"排行榜需要使用您的公开信息" closeButtonTitle:nil duration:0.0f];
            self.show = YES;
        }
    } else {
        
        [self reloadDataView];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.courseTableView];
    [self.view addSubview:self.tableView];
}

- (void)reloadDataView {
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    if (onceLogin.studentID.length) {
        if (![self.studentID isEqualToString:onceLogin.studentID] || ![self.schoolNum isEqualToString:onceLogin.schoolNumber]) {
            self.studentID = onceLogin.studentID;
            self.schoolNum = onceLogin.schoolNumber;
            [self getData];
        } else if (!self.datasource.count || !self.courseDatasource.count) {
            [self getData];
        }
    }
    [self.tableView reloadData];
    [self.courseTableView reloadData];
}

- (void)getData {
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    [KVNProgress showWithStatus:@"正在加载中"];
    [SANetWorkingTask requestWithPost:[SAURLManager queryCourseInfo] parmater:@{SCHOOLNUMBER: onceLogin.schoolNumber, STUDENTID:onceLogin.studentID}block:^(id result) {
    
        [KVNProgress dismiss];
        
        result = (NSDictionary *)result;
        [self.courseDatasource removeAllObjects];
        [self.courseDatasource addObject:onceLogin];
        
        if ([result[@"flag"] isEqualToString:@"000"]) {
            [self.courseTableView reloadData];
            return ;
        }
        
        if (result[@"flag"]) {
            NSArray *array = result[@"course"];
            for (NSDictionary *dic in array) {
                Course *course = [[Course alloc] init];
                [course setValuesForKeysWithDictionary:dic];
                [self.courseDatasource addObject:course];
            }
        }
        Course *course = self.courseDatasource[1];
        
        NSDictionary *dictionary = @{TEACHERALIASNAME: course.teacherAliasName, COURSEALIAS:course.courseAlias, STUDENTID:onceLogin.studentID, SCHOOLNUMBER:onceLogin.schoolNumber};
        [SANetWorkingTask requestWithPost:[SAURLManager myRanking] parmater:dictionary block:^(id result) {
            if ([result[@"flag"] isEqualToString:@"001"]) {
                RankModel *rankModel = [[RankModel alloc] init];
                [rankModel setValuesForKeysWithDictionary:result[@"userRank"]];
                [self.datasource removeAllObjects];
                [self.datasource addObject:rankModel];
                for (NSDictionary *dic in result[@"value"]) {
                    RankModel *rankModel = [[RankModel alloc] init];
                    [rankModel setValuesForKeysWithDictionary:dic];
                    [self.datasource addObject:rankModel];
                }
                [self.tableView reloadData];
            }
        }];
        
        [self.courseTableView reloadData];
    }];
    self.studentID = onceLogin.studentID;
    self.schoolNum = onceLogin.schoolNumber;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)datasource {
    if (!_datasource) {
        self.datasource = [NSMutableArray arrayWithCapacity:0];
    }
    return _datasource;
}

- (NSMutableArray *)courseDatasource {
    if (!_courseDatasource) {
        self.courseDatasource = [NSMutableArray arrayWithCapacity:0];
    }
    return _courseDatasource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.width / 3, 64, self.view.width - self.view.width / 3, self.courseTableView.height - 64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        self.rankTableViewCell = [UINib nibWithNibName:@"RankTableViewCell" bundle:nil];
        [_tableView registerNib:self.rankTableViewCell forCellReuseIdentifier:@"RankTableViewCell"];
        self.myRankTableViewCell = [UINib nibWithNibName:@"MyRankTableViewCell" bundle:nil];
        [_tableView registerNib:self.myRankTableViewCell forCellReuseIdentifier:@"MyRankTableViewCell"];
    }
    return _tableView;
}

- (UITableView *)courseTableView {
    if (!_courseTableView) {
        self.courseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width / 3, self.view.height - self.tabBarController.tabBar.height) style:UITableViewStyleGrouped];
        _courseTableView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.8];
        _courseTableView.delegate = self;
        _courseTableView.dataSource = self;
        _courseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        [_courseTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CourseTableViewCell"];
        self.rankImageHeaderTableViewCell = [UINib nibWithNibName:@"RankImageHeaderTableViewCell" bundle:nil];
        [_courseTableView registerNib:self.rankImageHeaderTableViewCell forCellReuseIdentifier:@"RankImageHeaderTableViewCell"];
        self.rankCourseTableViewCell = [UINib nibWithNibName:@"RankCourseTableViewCell" bundle:nil];
        [_courseTableView registerNib:self.rankCourseTableViewCell forCellReuseIdentifier:@"RankCourseTableViewCell"];
        
    }
    return _courseTableView;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.courseTableView) {
        if (indexPath.row == 0) {
            return 140;
        }
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView) {
        if (indexPath.row == 0) {
            MyRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyRankTableViewCell"];
            if (self.datasource.count > indexPath.row) {
               [cell setRankModel:self.datasource[indexPath.row]];
            }
            return cell;
        } else {
            RankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RankTableViewCell"];
            if (self.datasource.count > indexPath.row) {
                [cell setRankModel:self.datasource[indexPath.row]];
            }
            return cell;
        }
    } else {
        if (indexPath.row == 0) {
            RankImageHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RankImageHeaderTableViewCell"];
            if (self.courseDatasource.count > indexPath.row) {
                OnceLogin *onceLogin = self.courseDatasource[indexPath.row];
                [cell.imageHeader setImageWithURL:onceLogin.imageURL withborderWidth:2 withColor:[UIColor whiteColor]];
                [cell.nameLabel setText:onceLogin.sName];
            }
            return cell;
        } else {
            RankCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RankCourseTableViewCell"];
            
            if (self.courseDatasource.count > indexPath.row) {
                Course *course = self.courseDatasource[indexPath.row];
                cell.textLabel.lineBreakMode = NSLineBreakByClipping;
                [cell.courseLabel setText:course.courseName];
            }
            return cell;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.datasource.count;
    } else {
        return self.courseDatasource.count;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.courseTableView) {
        if (indexPath.row > 0) {
            Course *course = self.courseDatasource[indexPath.row];
            OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
            NSDictionary *dictionary = @{TEACHERALIASNAME: course.teacherAliasName, COURSEALIAS:course.courseAlias, STUDENTID:onceLogin.studentID, SCHOOLNUMBER:onceLogin.schoolNumber};
            [SANetWorkingTask requestWithPost:[SAURLManager myRanking] parmater:dictionary block:^(id result) {
                
                [self.datasource removeAllObjects];
                if ([result[@"flag"] isEqualToString:@"001"]) {
                    RankModel *rankModel = [[RankModel alloc] init];
                    [rankModel setValuesForKeysWithDictionary:result[@"userRank"]];
                    rankModel.name = course.courseName;
                    [self.datasource addObject:rankModel];
                    
                    for (NSDictionary *dic in result[@"value"]) {
                        RankModel *rankModel = [[RankModel alloc] init];
                        [rankModel setValuesForKeysWithDictionary:dic];
                        [self.datasource addObject:rankModel];
                    }
                }
                if (!self.datasource.count) {
                    [KVNProgress showErrorWithStatus:@"无等级\n等级君很快就会出现的"];
                }
                [self.tableView reloadData];
            }];

        }
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
