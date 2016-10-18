//
//  ExerciseViewController.m
//  StudyAssisTant
//
//  Created by wjn on 15/9/4.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "ExerciseViewController.h"
#import "ContextMenuCell.h"

static NSString *const menuCellIdentifier = @"rotationCell";

@interface ExerciseViewController ()
<
YALContextMenuTableViewDelegate
>

@property (nonatomic, strong) YALContextMenuTableView* contextMenuTableView;

@property (nonatomic, strong) NSArray *menuTitles;
@property (nonatomic, strong) NSArray *menuIcons;

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
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
    
    [self initiateMenuOptions];
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
    
    NSDictionary *dic = @{TEACHERID : self.course.teacherId, COURSEID : self.course.courseId};
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
        self.datasource = [NSMutableArray arrayWithObjects:@"在线考试", @"全真模拟", @"我的收藏", @"单选题练习", @"多选题练习", @"判断题练习", @"填空题练习", @"简答题练习", nil];
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
    if ([tableView isKindOfClass:[YALContextMenuTableView class]]) {
        return 65;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([tableView isKindOfClass:[YALContextMenuTableView class]]) {
        ContextMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier forIndexPath:indexPath];
        
        if (cell) {
            cell.backgroundColor = [UIColor clearColor];
            cell.menuTitleLabel.text = [self.menuTitles objectAtIndex:indexPath.row];
            cell.menuImageView.image = [self.menuIcons objectAtIndex:indexPath.row];
        }
        
        return cell;
    }
    
    ExerciseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"exerciseTableViewCell"];
    if (self.datasource.count > indexPath.row) {
        cell.optionLabel.text = self.datasource[indexPath.row];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([tableView isKindOfClass:[YALContextMenuTableView class]]) {
        return self.menuTitles.count;
    }
    
    return self.datasource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isKindOfClass:[YALContextMenuTableView class]]) {
        YALContextMenuTableView *yalTB = (YALContextMenuTableView*)tableView;
        [yalTB dismisWithIndexPath:indexPath];
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CollectionViewType collectionViewType = SelectOrder;
    NSArray *dataSource;
    
    if (indexPath.row == OnlineExam) {
        
        OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
        
        NSDictionary *dic = @{TEACHERALIASNAME : self.course.teacherName, COURSEALIAS : self.course.courseName, ORGANIZATIONCODE : onceLogin.organizationCode, STUDENTID : onceLogin.studentID};
        [KVNProgress showWithStatus:@"正在查询考试是否开通"];
        
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
        
        if (self.allResult.selectQuestion.count < 80 || self.allResult.multiSelectQuestion.count < 10 || self.allResult.judgeQuestion.count <10) {
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
            dataSource = self.allResult.selectQuestion;
        }
        if (indexPath.row == MultiSelect) {
            collectionViewType = MultiSelect;
            dataSource = self.allResult.multiSelectQuestion;
        }
        if (indexPath.row == JudgeMentOrder) {
            collectionViewType = JudgeMentOrder;
            dataSource = self.allResult.judgeQuestion;
        }
        if (indexPath.row == FillBankOrder) {
            collectionViewType = FillBankOrder;
            dataSource = self.allResult.fillBlankQuestion;
        }
        if (indexPath.row == ShortAnswerOrder) {
            collectionViewType = ShortAnswerOrder;
            dataSource = self.allResult.shortAnswerQuestion;
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
   /// if (self.updateView.show) {
    ///    [UIView animateWithDuration:0.5 animations:^{
     ///       self.updateView.frame = CGRectMake(self.view.width - 138, -50, 128, 105);
    ///    }];
//        [self.updateView removeFromSuperview];
    ///    self.updateView.show = NO;
   /// } else {
//        [self.view addSubview:self.updateView];
    ///    [UIView animateWithDuration:0.5 animations:^{
    ///       self.updateView.frame = CGRectMake(self.view.width - 138, 52, 128, 105);
     ///   }];
     ///   self.updateView.show = YES;
  ///  }
    if (!self.contextMenuTableView) {
        self.contextMenuTableView = [[YALContextMenuTableView alloc]initWithTableViewDelegateDataSource:self];
        self.contextMenuTableView.animationDuration = 0.15;
        //optional - implement custom YALContextMenuTableView custom protocol
        self.contextMenuTableView.yalDelegate = self;
        //optional - implement menu items layout
        self.contextMenuTableView.menuItemsSide = Right;
        self.contextMenuTableView.menuItemsAppearanceDirection = FromTopToBottom;
        
        //register nib
        UINib *cellNib = [UINib nibWithNibName:@"ContextMenuCell" bundle:nil];
        [self.contextMenuTableView registerNib:cellNib forCellReuseIdentifier:menuCellIdentifier];
    }
    
    // it is better to use this method only for proper animation
    [self.contextMenuTableView showInView:self.navigationController.view withEdgeInsets:UIEdgeInsetsZero animated:YES];

}

#pragma mark - UpdateViewDelegate

- (void)updateDatasource {
   NSDictionary *dic = @{TEACHERID : self.course.teacherId, COURSEID : self.course.courseId};
        [KVNProgress showWithStatus:@"正在更新试题"];
        [SANetWorkingTask requestWithPost:[SAURLManager downloadQuestion] parmater:dic block:^(id result) {
            [KVNProgress dismiss];
            self.allResult = [[AllResult alloc] initWithDictionary:result];
            [self.allResult writeToLocal:self.course.courseName];
            [KVNProgress showSuccessWithStatus:@"更新成功"];
            
        }];
//    if (self.updateView.show) {
//        [UIView animateWithDuration:0.5 animations:^{
//            self.updateView.frame = CGRectMake(self.view.width - 138, -50, 128, 105);
//        }];
//        //        [self.updateView removeFromSuperview];
//        self.updateView.show = NO;
//    } else {
//        //        [self.view addSubview:self.updateView];
//        [UIView animateWithDuration:0.5 animations:^{
//            self.updateView.frame = CGRectMake(self.view.width - 138, 52, 128, 105);
//        }];
//        self.updateView.show = YES;
//    }

}

- (void)removeDatasource {
    
    SAKeyValueStore *store = [[SAKeyValueStore alloc] initDBWithName:@"test.db"];
    for (int i = 0; i < 5; i++) {
        NSString *tableName = [NSString stringWithFormat:@"coursetable%@_%d", self.course.courseId, i];
        [store clearTable:tableName];
    }
    [KVNProgress showSuccessWithStatus:@"已清除全部记录"];
    
//    if (self.updateView.show) {
//        [UIView animateWithDuration:0.5 animations:^{
//            self.updateView.frame = CGRectMake(self.view.width - 138, -50, 128, 105);
//        }];
//        //        [self.updateView removeFromSuperview];
//        self.updateView.show = NO;
//        
//        SAKeyValueStore *store = [[SAKeyValueStore alloc] initDBWithName:@"test.db"];
//        for (int i = 0; i < 5; i++) {
//            NSString *tableName = [NSString stringWithFormat:@"coursetable%@_%d", self.course.courseId, i];
//            [store clearTable:tableName];
//        }
//        [KVNProgress showSuccessWithStatus:@"已清除全部记录"];
//        
//    } else {
//        //        [self.view addSubview:self.updateView];
//        [UIView animateWithDuration:0.5 animations:^{
//            self.updateView.frame = CGRectMake(self.view.width - 138, 52, 128, 105);
//        }];
//        self.updateView.show = YES;
//    }
//
}


#pragma mark ---------------

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    //should be called after rotation animation completed
    [self.contextMenuTableView reloadData];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self.contextMenuTableView updateAlongsideRotation];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        //should be called after rotation animation completed
        [self.contextMenuTableView reloadData];
    }];
    [self.contextMenuTableView updateAlongsideRotation];
    
}

#pragma mark - Local methods

- (void)initiateMenuOptions {
    self.menuTitles = @[@"",
                        @"更新题库",
                        @"清除收藏",
                        ];
    
    self.menuIcons = @[[UIImage imageNamed:@"MainColorcancel"],
                       [UIImage imageNamed:@"MainColorupdate"],
                       [UIImage imageNamed:@"MainColorremove"],
                       ];
}


#pragma mark - YALContextMenuTableViewDelegate

- (void)contextMenuTableView:(YALContextMenuTableView *)contextMenuTableView didDismissWithIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 1:
            [self updateDatasource];
            break;
        case 2:
            [self removeDatasource];
            break;
        default:
            break;
    }
}

@end
