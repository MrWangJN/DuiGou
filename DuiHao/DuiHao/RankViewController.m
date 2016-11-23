//
//  RankViewController.m
//  StudyAssisTant
//
//  Created by wjn on 15/9/21.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "RankViewController.h"
#import "TitleMenuButton.h"
#import "BindInformationViewController.h"
#import "WEBVIewController.h"

@interface RankViewController ()<WBPopMenuSingletonDelegate>

@property (nonatomic, strong) NSMutableArray *titles;

@property (nonatomic, strong) NSMutableArray *courses;

@property (nonatomic, strong) TitleMenuButton *titleButton;

@property (nonatomic, strong) RankModel *rankModel;

@property (nonatomic, strong) Course *course;

@property (nonatomic, strong) OpenPrivacyState *openPrivacyState;

@property (nonatomic,assign) BOOL isLoading;

@end

@implementation RankViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [self.tabBarController.tabBar setHidden:NO];
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    if (![onceLogin.privacyState isEqualToString:@"1"]) {
        [self.view bringSubviewToFront:self.openPrivacyState];
        self.titleButton.userInteractionEnabled = NO;
    } else {
        self.titleButton.userInteractionEnabled = YES;
        [self reloadDataView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.view addSubview:self.openPrivacyState];
    [self.view addSubview:self.tableView];
    self.navigationItem.titleView = self.titleButton;
    // 无数据时显示的提示图片
    [self setHintImage:@"NoRank" whihHight:0];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
    self.tableView.height -= self.tabBarController.tabBar.height;
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
                                                               
                                                               if (index == 10000) {
                                                                   [self getData];
                                                                   return ;
                                                               }
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
        _titleButton.title.text = @"暂无课程";
        [_titleButton addTarget:self action:@selector(titleButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}

- (OpenPrivacyState *)openPrivacyState {
    if (!_openPrivacyState) {
        self.openPrivacyState =  [[NSBundle mainBundle] loadNibNamed:@"OpenPrivacyState" owner:self options:nil][0];
        _openPrivacyState.frame = self.view.bounds;
        _openPrivacyState.delegate = self;
       
    }
    return _openPrivacyState;
}

- (void)reloadDataView {
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    [self.view bringSubviewToFront:self.tableView];
    if (onceLogin.studentID.length && onceLogin.organizationCode.length) {
        if (![self.studentID isEqualToString:onceLogin.studentID]) {
            self.studentID = onceLogin.studentID;
            self.schoolNum = onceLogin.organizationCode;
            [self getData];
        } else if (!self.rankModel.topList.count) {
            [self getData];
        }
    }
}

- (void)getData {
    
    [KVNProgress showWithStatus:@"正在努力加载"];
    
     OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    [SANetWorkingTask requestWithPost:[SAURLManager queryCourseInfo] parmater:@{ORGANIZATIONCODE: onceLogin.organizationCode, STUDENTID:onceLogin.studentID}blockOrError:^(id result, NSError *error) {
        
        if (error) {
            [self hiddenHint];
            return ;
        }
        
         [self.courses removeAllObjects];
         [self.titles removeAllObjects];
        
        [KVNProgress dismiss];
        
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
        }
    }];

    self.studentID = onceLogin.studentID;
    self.schoolNum = onceLogin.organizationCode;
}


- (void)sendRankNetWork:(Course *)course {
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    
    NSDictionary *dictionary = @{COURSEID: course.courseId, STUDENTID:onceLogin.studentID, TEACHINGID: course.teachingId};
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
        
        __weak typeof(self) weakSelf =self;
        [_tableView addPullToRefreshActionHandler:^{
            typeof(self) strongSelf = weakSelf;
            [strongSelf insertRowAtTop];
            
        } ProgressImagesGifName:@"loadinggreen.gif" LoadingImagesGifName:@"loadinggreen.gif" ProgressScrollThreshold:70 LoadingImageFrameRate:30];
        
        // If you did not change scrollview inset, you don't need code below.
        if(IS_IOS7)
            [self.tableView addTopInsetInPortrait:0 TopInsetInLandscape:52];
        else if(IS_IOS8)
        {
            CGFloat landscapeTopInset = 32.0;
            if(IS_IPHONE6PLUS)
                landscapeTopInset = 44.0;
            [self.tableView addTopInsetInPortrait:0 TopInsetInLandscape:landscapeTopInset];
        }

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
    
    NSString *stuId;
    NSString *name;
    NSString *rankTitle;
    if (indexPath.section == 0) {
        if (!self.rankModel.flag.integerValue) {
            return;
        }
        
        stuId = [OnceLogin getOnlyLogin].studentID;
        name = [OnceLogin getOnlyLogin].studentName;
        rankTitle = self.rankModel.name;
        
    } else {
        RankPersonalModel *rankPer = self.rankModel.topList[indexPath.row];
        if (!rankPer.flag.integerValue) {
            return;
        }
        stuId = rankPer.studentId;
        name = rankPer.studentName;
        rankTitle = rankPer.name;
    }
    
    if (stuId) {
        WEBViewController *webVC = [[WEBViewController alloc] initWithURL:[NSString stringWithFormat:@"%@/Course/courseTopInfo?studentId=%@&courseId=%@&teachingId=%@", @"http://www.duigou.tech/mlearning/Api", stuId, self.course.courseId, self.course.teachingId] withName:[NSString stringWithFormat:@"%@:%@", rankTitle, name]];
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

#pragma mark - OpenPrivacyStateDelegate

- (void)openHasPress {
    [self reloadDataView];
    self.titleButton.userInteractionEnabled = YES;
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

- (void)insertRowAtTop {
    
    if (!self.course) {
        
        [self getData];
        
        [self.tableView stopPullToRefreshAnimation];
        self.isLoading = NO;
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    self.isLoading =YES;
    int64_t delayInSeconds = 2.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        typeof(self) strongSelf = weakSelf;
        
        OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
        
        NSDictionary *dictionary = @{COURSEID: self.course.courseId, STUDENTID:onceLogin.studentID, TEACHINGID: self.course.teachingId};
        [SANetWorkingTask requestWithPost:[SAURLManager myRanking] parmater:dictionary blockOrError:^(id result, NSError *error) {
            
            if (error) {
                [strongSelf.tableView stopPullToRefreshAnimation];
                strongSelf.isLoading =  NO;
                return ;
            }
            
            if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
                
                self.rankModel = [[RankModel alloc] initWithDictionary:result[RESULT]];
                [self noHiddenHint];
                [self.tableView reloadData];
            } else {
                [self hiddenHint];
                [self.tableView reloadData];
            }

            [strongSelf.tableView stopPullToRefreshAnimation];
            strongSelf.isLoading = NO;
        }];

    });
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
