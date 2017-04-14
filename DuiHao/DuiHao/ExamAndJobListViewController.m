//
//  ExamListViewController.m
//  DuiHao
//
//  Created by wjn on 2017/3/16.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "ExamAndJobListViewController.h"
#import "ExamAndJobTableViewCell.h"
#import "ExamAndJobStatusLayout.h"
#import "OnceLogin.h"
#import "ExamModel.h"
#import "ExamViewController.h"
#import "Course.h"
#import "LoginViewController.h"

@interface ExamAndJobListViewController ()<UITableViewDelegate, UITableViewDataSource, LoginViewControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation ExamAndJobListViewController

- (instancetype)initWithType:(WorkType )type
{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getData];
    [self.view addSubview:self.tableView];

    if (self.type == Exam) {
        // 无数据时显示的提示图片
        [self setHintImage:@"NoExam" whihHight:64];
    } else if (self.type == Exercise) {
        [self setHintImage:@"NoExercise" whihHight:64];
    } else {
        // 无数据时显示的提示图片
        [self setHintImage:@"NoHomeWork" whihHight:64];
    }
    
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
        [_tableView registerNib:[UINib nibWithNibName:@"ExamAndJobTableViewCell" bundle:nil] forCellReuseIdentifier:@"ExamAndJobTableViewCell"];
    }
    return _tableView;
}

- (void)getData {
    
    NSString *url;
    
    if (self.type == Exam) {
        [self.navigationItem setTitle:@"在线考试"];
        url = [SAURLManager getExamList];
    } else if (self.type == HomeWork) {
        [self.navigationItem setTitle:@"作业"];
        url = [SAURLManager getHomeWorkList];
    } else if (self.type == Exercise) {
        [self.navigationItem setTitle:@"课堂测练"];
        url = [SAURLManager getExerciseList];
    }
    
    [JKAlert alertWaitingText:@"正在获取数据"];
    
    self.backBtu.userInteractionEnabled = NO;
    [SANetWorkingTask requestWithPost:url parmater:@{STUDENTID: [OnceLogin getOnlyLogin].studentID} blockOrError:^(id result, NSError *error) {
        
       [JK_M dismissElast];
        
        if (error) {
            [JKAlert alertText:@"请求失败"];
            return ;
        }
         if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
             
             result = result[RESULT];
             result = result[LISTS];
             
             for (NSDictionary *dic in result) {
                 ExamJobListModel *model = [[ExamJobListModel alloc] initWithRawModel:dic];
                 ExamAndJobStatusLayout *layout = [[ExamAndJobStatusLayout alloc] initWithStatus:model];
                 [self.dataSource addObject:layout];
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

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExamAndJobStatusLayout *layout = self.dataSource[indexPath.section];
    return layout.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExamAndJobTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExamAndJobTableViewCell"];
    
    if (indexPath.section < self.dataSource.count) {
        ExamAndJobStatusLayout *layout = self.dataSource[indexPath.section];
        cell.examAndJobLayout = layout;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ExamAndJobStatusLayout *layout = self.dataSource[indexPath.section];
    Course *course = [[Course alloc] init];
    course.teachingId = layout.model.teachingId;
    course.teacherId = layout.model.teacherId;
    course.courseId = layout.model.courseId;
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    
    if (layout.model.isOpen.intValue == 0) {
        
        NSDictionary *dic = @{TEACHINGID : course.teachingId, STUDENTID : onceLogin.studentID, EXAMID: layout.model.modelId};
        
        [SANetWorkingTask requestWithPost:[SAURLManager isOpenExam] parmater:dic block:^(id result) {
            
            [JK_M dismissElast];
            
            if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
                ExamModel *examModel = [[ExamModel alloc] initWithDictionary:result];
                [KVNProgress dismiss];
                
                if (self.type == HomeWork) {
                    examModel.timeLength = @"120";
                }
                
                if (examModel.examId.length) {
                    SCLAlertView *alert = [[SCLAlertView alloc] init];
                    [alert addButton:@"确定" actionBlock:^(void) {
                        ExamViewController *examViewController = [[ExamViewController alloc] initWithCouse:course withExam:examModel];
                        [self.navigationController pushViewController:examViewController animated:YES];
                    }];
                    [alert addButton:@"取消" actionBlock:^(void) {
                    }];
                    
                    [alert showWarning:self title:@"警告" subTitle:[NSString stringWithFormat:@"本次时长为%@分钟\n请勿退出页面，否则系统会自动交卷，祝您取得好成绩！", examModel.timeLength] closeButtonTitle:nil duration:0.0f];
                } else {
                    [JKAlert alertText:@"暂未获取到试题"];
                }
            } else {
                [JKAlert alertText:result[ERRORMESSAGE]];
            }
        }];

        
    } else if (layout.model.isOpen.intValue == 1){
        // 结束
    }
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
