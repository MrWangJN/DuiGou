//
//  AddCourseListViewController.m
//  DuiHao
//
//  Created by wjn on 2017/5/5.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "AddCourseListViewController.h"
#import "AddTableViewCell.h"
#import "WeekView.h"
#import "FooterView.h"
#import "HeaderView.h"

@interface AddCourseListViewController ()<UITableViewDelegate, UITableViewDataSource, FooterViewDelegate, AddTableViewCellDelegate>

@property (strong, nonatomic) UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) FooterView *footreView;
@property (strong, nonatomic) HeaderView *headerView;
@property (strong, nonatomic) NSMutableArray *courses;

@end

@implementation AddCourseListViewController

- (instancetype)initWithCourses:(NSMutableArray *)array
{
    self = [super init];
    if (self) {
        self.courses = array;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"添加课程"];
    
    [self.view addSubview:self.tableview];
    UIBarButtonItem *finish = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Finish"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(finishAction:)];
    [self.navigationItem setRightBarButtonItem:finish];
}

- (void)finishAction:(id)sender {
    
    if (!self.headerView.courseT.text.length) {
        [JKAlert alertText:@"请填写课程名"];
        return;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    NSString *coursePath = [NSString stringWithFormat:@"%@/%@", docDir, @"course.json"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:coursePath]) {
        NSArray *array = [NSArray array];
        [array writeToFile:coursePath atomically:YES];
    }
    
    //        NSData *data = [NSData dataWithContentsOfFile:coursePath];
    //        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:coursePath];
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:0];
    
    if (!array.count) {
        [array addObject:@{@"weekDay": @"1", @"data": [NSArray array]}];
        [array addObject:@{@"weekDay": @"2", @"data": [NSArray array]}];
        [array addObject:@{@"weekDay": @"3", @"data": [NSArray array]}];
        [array addObject:@{@"weekDay": @"4", @"data": [NSArray array]}];
        [array addObject:@{@"weekDay": @"5", @"data": [NSArray array]}];
        [array addObject:@{@"weekDay": @"6", @"data": [NSArray array]}];
        [array addObject:@{@"weekDay": @"7", @"data": [NSArray array]}];
    }
    
    for (WeekCourse *weekCourse in self.dataSource) {
        
        weekCourse.courseName = self.headerView.courseT.text;
        weekCourse.teacherName = self.headerView.teacherT.text;
        
        if (!weekCourse.seWeek.length || !weekCourse.lesson.length) {
            [JKAlert alertText:@"信息不完善，无法添加该课程"];
            return;
        }
        
        for (NSDictionary *dic in array) {
            if ([dic[@"weekDay"] isEqualToString:weekCourse.day]) {
                
                NSMutableArray *courses = [NSMutableArray arrayWithArray:dic[@"data"]];
                for (NSDictionary *dicaa in courses) {
                    
                    if (([dicaa[@"lessons"] isEqualToString:weekCourse.lesson] &&
                         [dicaa[@"courseCode"] isEqualToString:weekCourse.courseName])) {
                        [JKAlert alertText:@"已存在该课程"];
                        continue;
                    }
                }
                [self.courses addObject:weekCourse];
                [courses addObject:[weekCourse toLocalDictionary]];
                [newArray addObject:@{@"weekDay": weekCourse.day, @"data": courses}];
                
            } else {
                [newArray addObject:dic];
            }
        }
    }
    [newArray writeToFile:coursePath atomically:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithObject:[[WeekCourse alloc] init]];
    }
    return _dataSource;
}

- (UITableView *)tableview {
    if (!_tableview) {
        self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        
        _tableview.tableFooterView = self.footreView;
        _tableview.tableHeaderView = self.headerView;
        
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableview registerNib:[UINib nibWithNibName:@"AddTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddTableViewCell"];
    }
    return _tableview;
}

- (FooterView *)footreView {
    if (!_footreView) {
        self.footreView = [[NSBundle mainBundle] loadNibNamed:@"FooterView" owner:self options:nil][0];
        _footreView.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
        _footreView.delegate = self;
    }
    return _footreView;
}

- (HeaderView *)headerView {
    if (!_headerView) {
        self.headerView = [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil][0];
        _headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 105);
    }
    return _headerView;
}

#pragma mark - UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableview endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddTableViewCell"];
    cell.delegate = self;
    cell.weekCourse = self.dataSource[indexPath.row];
    
    cell.shan.hidden = NO;
    
    if (self.dataSource.count == 1) {
        cell.shan.hidden = YES;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)add {
    [self.dataSource addObject:[[WeekCourse alloc] init]];
    [self.tableview reloadData];
}

- (void)deleteWeek:(WeekCourse *)weekCourse {
    [self.dataSource removeObject:weekCourse];
    [self.tableview reloadData];
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
