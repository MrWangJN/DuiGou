//
//  CourseManagerViewController.m
//  CourseList
//
//  Created by wjn on 2017/4/18.
//  Copyright © 2017年 Ningmengkeji. All rights reserved.
//

#import "CourseManagerViewController.h"
#import "CouresTableViewCell.h"
#import "PopoverView.h"
#import "AddCourseListViewController.h"
#import "CourseFromView.h"
#import "OnceLogin.h"

//NSUserDefaults 中的Key常量
#define CURRENTYEAR   @"CURRENTYEAR"
#define CURRENTTERM   @"CURRENTTERM"
#define USERNAME      @"USERNAME"
#define CURRENTWEEK   @"CURRENTWEEK"

@interface CourseManagerViewController ()<UITableViewDelegate, UITableViewDataSource, CouresTableViewCellDelegate>

@property (strong, nonatomic) UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *teacherCources;
@property (strong, nonatomic) CourseFromView *courseFromView;

@end

@implementation CourseManagerViewController

- (instancetype)initWithDataSource:(NSMutableArray *)dataSource
{
    self = [super init];
    if (self) {
        self.dataSource = dataSource;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"课程表管理"];
    [self.view addSubview:self.tableview];
    [self loadLoacalData:@"1"];
    
    UIBarButtonItem *addCourse = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"AddCourse"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(addCourseEditAction:)];
    [self.navigationItem setRightBarButtonItem:addCourse];
    
}

- (void)addCourseEditAction:(id)sender {
    AddCourseListViewController *addVC = [[AddCourseListViewController alloc] initWithCourses:self.dataSource];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (CourseFromView *)courseFromView {
    if (!_courseFromView) {
        self.courseFromView = [[NSBundle mainBundle] loadNibNamed:@"CourseFromView" owner:self options:nil][0];
        _courseFromView.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
        [_courseFromView.titleL setText:@"在线添加"];
        _courseFromView.statusL.hidden = NO;
        [_courseFromView.statusL setText:@"加载中.."];
    }
    return _courseFromView;
}

//- (NSArray<PopoverAction *> *)QQActions {
//    // 发起多人聊天 action
//    PopoverAction *multichatAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"right_menu_multichat"] title:@"添加课程" handler:^(PopoverAction *action) {
//#pragma mark - 该Block不会导致内存泄露, Block内代码无需刻意去设置弱引用.
//        AddCourseListViewController *addVC = [[AddCourseListViewController alloc] init];
//        [self.navigationController pushViewController:addVC animated:YES];
//    }];
//    // 加好友 action
//    PopoverAction *addFriAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"right_menu_addFri"] title:@"更改背景" handler:^(PopoverAction *action) {
//    }];
//    return @[multichatAction, addFriAction];
//}

- (NSMutableArray *)teacherCources {
    if (!_teacherCources) {
        self.teacherCources = [NSMutableArray arrayWithCapacity:0];
    }
    return _teacherCources;
}

- (UITableView *)tableview {
    if (!_tableview) {
        self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        
        [_tableview registerNib:[UINib nibWithNibName:@"CouresTableViewCell" bundle:nil] forCellReuseIdentifier:@"CouresTableViewCell"];
    }
    return _tableview;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
 
    if (section == 0) {
        CourseFromView *headerView = [[NSBundle mainBundle] loadNibNamed:@"CourseFromView" owner:self options:nil][0];
        headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
        [headerView.titleL setText:@"课程表"];
        [headerView.titleL setTextColor:[UIColor colorWithRed:237 / 255.0 green:96 / 255.0 blue:96 / 255.0 alpha:1]];
        return headerView;
    } else {
        return self.courseFromView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60;
    } else {
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CouresTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouresTableViewCell"];
    cell.delegate = self;
    if (indexPath.section == 0) {
        cell.type = BEN;
        cell.weekCourse = self.dataSource[indexPath.row];
    } else {
        cell.type = WANG;
        cell.weekCourse = self.teacherCources[indexPath.row];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataSource.count;
    } else {
        return self.teacherCources.count;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - CouresTableViewCellDelegate

- (void)reload:(WeekCourse *)weekCourse {
    [self.dataSource removeObject:weekCourse];
    [self.tableview reloadData];
}

- (void)add:(WeekCourse *)weekCourse {
    [self.dataSource addObject:weekCourse];
    [self.tableview reloadData];
}

#pragma mark - 网络请求

//加载本地的模拟数据
- (void)loadLoacalData:(NSString *)week
{
//    NSString *coursePath = [[NSBundle mainBundle] pathForResource:@"courses" ofType:@"json"];
    //        flag = NO;
    //    }else {
    //        coursePath = [[NSBundle mainBundle] pathForResource:@"courses-1" ofType:@"json"];
    //        flag = YES;
    //    }
//    NSData *data = [NSData dataWithContentsOfFile:coursePath];
    //    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    //    NSString *status = [dict objectForKey:@"status"];
    //    if (![@"200" isEqualToString:status]) {
    //        NSLog(@"没有数据");
    //        return;
    //    }
    
//    if (!data) {
//        if (self.headerView) {
//            [self.headerView.statusL setText:@"暂无"];
//        }
//        return;
//    }

    
    
//    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//    
//    if (array && array.count) {
//        [self handleWeek:array week:week];
//    }
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    
    [SANetWorkingTask requestWithPost:[SAURLManager getCourseList] parmater:@{STUDENTID: onceLogin.studentID} blockOrError:^(id result, NSError *error) {
        
        if (error) {
            return ;
        }
        
        if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
            
            self.courseFromView.statusL.hidden = YES;
            
            NSArray *array = result[RESULT];
            [self handleWeek:array week:nil];
            
        } else {
            [self.courseFromView.statusL setText:@"暂无"];
        }
    }];
}

- (void)handleWeek:(NSArray *)array week:(NSString *)week
{
    
    NSMutableArray *allCourses =[NSMutableArray array];
    NSMutableArray *ownCourses =[NSMutableArray array];
    if (array != nil && array.count > 0) {
        for (int i = 0; i < array.count; i++) {
            NSDictionary *dayDict = array[i];
            NSString *weekDay = [dayDict objectForKey:@"weekDay"];
            NSString *weekNum;
            weekNum = weekDay;
            NSMutableDictionary *course = [NSMutableDictionary dictionaryWithDictionary:dayDict];
            [course setObject:weekNum forKey:@"weekDay"];
            WeekCourse *weekCourse = [[WeekCourse alloc] initWithPropertiesDictionary:course];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *year = [userDefaults objectForKey:CURRENTYEAR];
            NSString *term = [userDefaults objectForKey:CURRENTTERM];
            NSString *stuId = [userDefaults objectForKey:USERNAME];
            NSString *yearRange = [NSString stringWithFormat:@"%@%@",year,term];
            weekCourse.studentId = stuId;
            weekCourse.term = yearRange;
            weekCourse.weeks = weekNum;
            
            [ownCourses addObject:weekCourse];
            [allCourses addObject:weekCourse];
        }
    }
    
    [self.teacherCources addObjectsFromArray:allCourses];
    [self.tableview reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationTop];
//    //对数据解析
//    [self handleData:allCourses];
//    self.courses = ownCourses;
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
