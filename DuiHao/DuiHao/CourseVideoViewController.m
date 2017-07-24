//
//  CourseVideoViewController.m
//  DuiHao
//
//  Created by wjn on 2017/4/1.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "CourseVideoViewController.h"
#import "ThemePPTView.h"
#import "PPTTableViewCell.h"
#import "CourseVideoModel.h"
#import "VideoPlayViewController.h"
#import "ZXVideo.h"

@interface CourseVideoViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) Course *course;

@end

@implementation CourseVideoViewController

- (instancetype)initWithCourse:(Course *)course
{
    self = [super init];
    if (self) {
        self.course = course;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"视频"];
    
    [self getData];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.height = self.view.height;
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
        [_tableView registerNib:[UINib nibWithNibName:@"PPTTableViewCell" bundle:nil] forCellReuseIdentifier:@"PPTTableViewCell"];
    }
    return _tableView;
}

- (void)getData {
    
    [SANetWorkingTask requestWithPost:[SAURLManager getCourseVideo] parmater:@{TEACHERID: self.course.teacherId, COURSEID: self.course.courseId} blockOrError:^(id result, NSError *error) {
        
        if (error) {
            
            return ;
        }
        
        if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
            result = result[RESULT];
            NSMutableSet *set = [NSMutableSet setWithCapacity:0];
            NSMutableArray *ppts = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *dic in result[LISTS]) {
                CourseVideoModel *cvModel = [[CourseVideoModel alloc] initWithRawModel:dic];
                [set addObject:cvModel.subject];
                [ppts addObject:cvModel];
            }

            for (NSString *subject in set) {
                
                NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithCapacity:0];
                NSMutableArray *themes = [NSMutableArray arrayWithCapacity:0];
                
                [mutableDic setObject:subject forKey:@"theme"];
                
                for (CourseVideoModel *cvModel in ppts) {
                    if ([cvModel.subject isEqualToString:subject]) {
                        [themes addObject:cvModel];
                    }
                }
                [mutableDic setObject:themes forKey:@"type"];
                [self.dataSource addObject:mutableDic];
            }

            [self.tableView reloadData];
        }

        if (!self.dataSource.count) {
            [JKAlert alertText:@"教师未上传视频"];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ThemePPTView *themeV = [[NSBundle mainBundle] loadNibNamed:@"ThemePPTView" owner:self options:nil][0];
    [themeV.themeL setText:self.dataSource[section][@"theme"]];
    [themeV.imageV setImage:[UIImage imageNamed:@"VideoIcon"]];
    return themeV;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 68;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PPTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PPTTableViewCell"];
    
    NSArray *array = self.dataSource[indexPath.section][@"type"];
    CourseVideoModel *cvModel = array[indexPath.row];
    cell.cvModel = cvModel;
    cell.downloadB.hidden = YES;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *array = self.dataSource[section][@"type"];
    return array.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *array = self.dataSource[indexPath.section][@"type"];
    CourseVideoModel *cvModel = array[indexPath.row];
    
    ZXVideo *video = [[ZXVideo alloc] init];
    video.playUrl = cvModel.downloadurl;
    video.title = cvModel.title;
    
    VideoPlayViewController *vc = [[VideoPlayViewController alloc] init];
    vc.video = video;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
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
