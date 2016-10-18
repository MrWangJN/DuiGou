//
//  RankViewController.m
//  StudyAssisTant
//
//  Created by wjn on 15/9/21.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "RankViewController.h"
#import "TitleMenuButton.h"

@interface RankViewController ()<WBPopMenuSingletonDelegate>

@property (nonatomic, assign) BOOL show;

@property (nonatomic, strong) NSMutableArray *titles;

@property (nonatomic, strong) NSMutableArray *courses;

@property (nonatomic, strong) TitleMenuButton *titleButton;

@property (nonatomic, strong) RankModel *rankModel;

@property (nonatomic, strong) Course *course;

@end

@implementation RankViewController

- (void)viewWillAppear:(BOOL)animated {
        
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    if (![onceLogin.privacyState isEqualToString:@"1"]) {
        if (!self.show) {
            
            OpenPrivacyState *openPrivacyState =  [[NSBundle mainBundle] loadNibNamed:@"OpenPrivacyState" owner:self options:nil][0];
            openPrivacyState.frame = self.view.bounds;
            openPrivacyState.delegate = self;
            [self.view addSubview:openPrivacyState];
        }
    } else {
        [self reloadDataView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    self.navigationItem.titleView = self.titleButton;
    // 无数据时显示的提示图片
    [self setHintImage:@"NoRank" whihHight:0];
    
}

- (void)titleButtonDidPress:(UIButton *)sender {
    
    [self rotateArrow:M_PI];
    
    NSMutableArray *obj = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [self titles].count; i++) {
        
        WBPopMenuModel * info = [WBPopMenuModel new];
        info.image = [self images][i];
        info.title = [self titles][i];
        [obj addObject:info];
    }
    
    [[WBPopMenuSingleton shareManager]showPopMenuSelecteWithFrame:self.view.width / 2
                                                             item:obj
                                                           action:^(NSInteger index) {
                                                               [self rotateArrow:0];
                                                               self.titleButton.title.text = [self.titles objectAtIndex:index];
                                                               [self sendRankNetWork:[self.courses objectAtIndex:index]];
                                                               self.course = [self.courses objectAtIndex:index];
                                                           } withDelegate:self];
}

- (void)rotateArrow:(float)degrees
{
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.titleButton.arrow.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
    } completion:NULL];
}



- (NSMutableArray *)titles {
    if (!_titles) {
        self.titles = [NSMutableArray arrayWithCapacity:0];
    }
    return _titles;
}

#pragma mark - WBPopMenuSingletonDelegate

- (void)dismiss {
    [self rotateArrow:0];
}

- (NSArray *) images {
    return @[@"right_menu_QR@3x",
             @"right_menu_addFri@3x",
             @"right_menu_multichat@3x",
             @"right_menu_sendFile@3x",
             @"right_menu_facetoface@3x",
             @"right_menu_payMoney@3x"];
}

- (NSMutableArray *)courses {
    if (!_courses) {
        self.courses = [NSMutableArray arrayWithCapacity:0];
    }
    return _courses;
}

- (TitleMenuButton *)titleButton {
    if (!_titleButton) {
        self.titleButton = [[TitleMenuButton alloc] initWithFrame:CGRectMake(0.0, 0.0, self.navigationController.navigationBar.bounds.size.width, self.navigationController.navigationBar.bounds.size.height)];
        _titleButton.title.text = @"题目";
        [_titleButton addTarget:self action:@selector(titleButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}

- (void)reloadDataView {
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    if (onceLogin.studentID.length) {
        if (![self.studentID isEqualToString:onceLogin.studentID] || ![self.schoolNum isEqualToString:onceLogin.schoolNumber]) {
            self.studentID = onceLogin.studentID;
            self.schoolNum = onceLogin.schoolNumber;
            [self getData];
        } else if (!self.rankModel.topList.count) {
            [self getData];
        }
    }
}

- (void)getData {
    
    [KVNProgress showWithStatus:@"正在努力加载课程"];
    
     OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    [SANetWorkingTask requestWithPost:[SAURLManager queryCourseInfo] parmater:@{ORGANIZATIONCODE: onceLogin.organizationCode, STUDENTID:onceLogin.studentID}block:^(id result) {
        
         [self.courses removeAllObjects];
         [self.titles removeAllObjects];
        
        if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
            NSArray *array = result[RESULT][@"lists"];
            for (NSDictionary *dic in array) {
                Course *course = [[Course alloc] init];
                [course setValuesForKeysWithDictionary:dic];
                [self.titles addObject:course.courseName];
                [self.courses addObject:course];
            }
        }
        
        if (!self.courses.count || !self.courses) {
            [KVNProgress showErrorWithStatus:@"暂未获取到任何课程信息"];
            [self hiddenHint];
        } else {
            [self noHiddenHint];
            [self sendRankNetWork:[self.courses firstObject]];
            self.course = [self.courses firstObject];
            self.titleButton.title.text =  [self.titles firstObject];
            [self.titleButton setNeedsLayout];
            [KVNProgress dismiss];
        }
        
        
    }];

    self.studentID = onceLogin.studentID;
    self.schoolNum = onceLogin.schoolNumber;
}


- (void)sendRankNetWork:(Course *)course {
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    
    NSDictionary *dictionary = @{COURSEID: course.courseId, STUDENTID:onceLogin.studentID};
    [SANetWorkingTask requestWithPost:[SAURLManager myRanking] parmater:dictionary block:^(id result) {
                if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
                    
                    self.rankModel = [[RankModel alloc] initWithDictionary:result[RESULT]];
                    [self noHiddenHint];
                    [self.tableView reloadData];
                } else {
                    [self hiddenHint];
                    [self.tableView reloadData];
                }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (RankModel *)rankModel {
    if (!_rankModel) {
        self.rankModel = [[RankModel alloc] init];
    }
    return _rankModel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = TABLEBACKGROUND;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        self.rankTableViewCell = [UINib nibWithNibName:@"RankTableViewCell" bundle:nil];
        [_tableView registerNib:self.rankTableViewCell forCellReuseIdentifier:@"RankTableViewCell"];
        self.myRankTableViewCell = [UINib nibWithNibName:@"MyRankTableViewCell" bundle:nil];
        [_tableView registerNib:self.myRankTableViewCell forCellReuseIdentifier:@"MyRankTableViewCell"];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 90;
    } else {
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        MyRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyRankTableViewCell"];
        if (self.rankModel.topList.count > indexPath.row) {
            [cell setRankModel:self.rankModel withCourse:self.titleButton.title.text];
        }
        return cell;
    } else {
        RankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RankTableViewCell"];
        if (self.rankModel.topList.count > indexPath.row) {
            [cell setRankPersonalModel:self.rankModel.topList[indexPath.row]];
        }
        return cell;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        return self.rankModel.topList.count;
    } else {
        return 1;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - OpenPrivacyStateDelegate

- (void)openHasPress {
    self.show = YES;
    [self reloadDataView];
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
    
    if (!self.titles.count) {
        [self getData];
    } else {
        [self sendRankNetWork:self.course];
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
