//
//  ViewController.m
//  StudyAssisTant
//
//  Created by 王建男 on 15/3/8.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "ViewController.h"
#import "BindInformationViewController.h"
#import "CircleScrollView.h"
#import "DragTableViewCell.h"
#import "TodayHistoryLayout.h"
#import "TodayHistoryViewController.h"
#import "TodayTalkTableViewCell.h"
#import "BannerModel.h"
#import "HistoryTalkModel.h"
#import "TodayTalkStatusLayout.h"
#import "NewsModel.h"
#import "MessageTableViewCell.h"

@interface ViewController ()<CircleScrollViewDelegate, TodayHistoryTableViewCellDelegate, DragTableViewCellDelegate>

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) CircleScrollView *circleSrollView;
@property (nonatomic, strong) TodayHistoryLayout *todayHistoryLayout;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController.navigationBar setHidden:NO];
    
//    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
//    
//    if (![self.studentID isEqualToString:onceLogin.studentID] || ![self.schoolNum isEqualToString:onceLogin.organizationCode]) {
//        self.studentID = onceLogin.studentID;
//        self.schoolNum = onceLogin.organizationCode;
////        [self getCourse:onceLogin];
//    } else if (!self.datasource.count || onceLogin.addCourseState) {
////        [self getCourse:onceLogin];
//        
//        onceLogin.addCourseState = false;
//        [onceLogin writeToLocal];
//    }
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0 / 255.0 green:128 / 255.0 blue:255 / 255.0 alpha:1]]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    UIBarButtonItem *scanItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Scan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(scanDidPress:)];
    [self.navigationItem setRightBarButtonItem:scanItem];
    
    UIBarButtonItem *addCourseItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"AddCourse"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(addCourseDidPress:)];
    [self.navigationItem setLeftBarButtonItem:addCourseItem];
    
    
//    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
//    if (!onceLogin.studentPhoneNum.length) {
//        
//        LoginViewController *loginViewController = [[LoginViewController alloc] init];
//        
//        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginViewController animated:YES completion:^{
//        }];
//    } else {
//        
//        if (onceLogin.asdState) {
//            ADSViewController *asdViewController = [[ADSViewController alloc] init];
//            [self.navigationController pushViewController:asdViewController animated:NO];
//        }
//        
////        [self getCourse:onceLogin];
//    }
    
//    if ([SAReachabilityManager sharedReachabilityManager].currentReachabilityStatus == ReachableViaWWAN) {
//        [KVNProgress showErrorWithStatus:@"您正处于非WIFI状态下"];
//        
//    }
	
    [self.view addSubview:self.tableView];
    //[self checkVersion];
    [self getTodayHistoryDate];
    [self getHomePageData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
    self.tableView.height -= self.tabBarController.tabBar.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 版本检查

- (void)checkVersion {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *strVer = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    
    [SANetWorkingTask requestWithPost:[SAURLManager requestSource] parmater:@{@"requestSource": @"iOS"} blockOrError:^(id result, NSError *error) {
        
        if (error) {
            return ;
        }
        
        if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
            
            if ([result[RESULT][@"showFlag"] isEqualToString:@"0"]) {
                return;
            }
            
            if (![result[RESULT][@"versionName"] isEqualToString:strVer]) {
              
                if ([result[RESULT][@"updateFlag"] isEqualToString:@"0"]) {
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"有新版本可用" message:result[RESULT][@"appDescription"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    // Create the actions.
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        
                        [alertController dismissViewControllerAnimated:YES completion:nil];
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://%@", result[RESULT][@"updateUrl"]]]];
                    }];
                    
                    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    }];
                    
                    // Add the actions.
                    [alertController addAction:cancelAction];
                    [alertController addAction:otherAction];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                } else {
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"有新版本可用" message:result[RESULT][@"appDescription"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    // Create the actions.
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                         [alertController dismissViewControllerAnimated:YES completion:nil];
                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://%@", result[RESULT] [@"updateUrl"]]]];
                    }];
                    
                    // Add the actions.
                    [alertController addAction:cancelAction];

                    [self presentViewController:alertController animated:YES completion:nil];
                } 
            }
        }
    }];
}

#pragma mark - private

- (void)scanDidPress:(UIButton *)sender {
    QRCodeViewController *qrCode = [[QRCodeViewController alloc] init];
    [self presentViewController:qrCode animated:YES completion:^{
    }];
}

- (void)addCourseDidPress:(UIButton *)sender {
    AddCourseViewController *addCourseViewController = [[AddCourseViewController alloc] init];
    [self.navigationController pushViewController:addCourseViewController animated:YES];
}

//- (void)getCourse:(OnceLogin *)onceLogin {
//    
//    if (!onceLogin.studentNumber.length) {
//        return;
//    }
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//    NSString *path = [paths firstObject];
//    path = [NSString stringWithFormat:@"%@/%@", path, @"Course"];
//    
//    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
//    
//    if (onceLogin.studentID.length && onceLogin.organizationCode.length) {
//        if (dic) {
//            
//            [self.datasource removeAllObjects];
//            
//            NSArray *array = dic[RESULT][@"lists"];
//            for (NSDictionary *dic in array) {
//                Course *course = [[Course alloc] init];
//                [course setValuesForKeysWithDictionary:dic];
//                [self.datasource addObject:course];
//            }
//            [self.tableView reloadData];
//        } else {
//            [KVNProgress showWithStatus:@"正在努力加载课程"];
//        }
//    } else {
//        [KVNProgress showWithStatus:@"正在努力加载课程"];
//    }
//
//    [SANetWorkingTask requestWithPost:[SAURLManager queryCourseInfo] parmater:@{ORGANIZATIONCODE: onceLogin.organizationCode, STUDENTID:onceLogin.studentID}blockOrError:^(id result, NSError *error) {
//        
//        if (error) {
//            if (!self.datasource.count || !self.datasource) {
//                [self hiddenHint];
//            } else {
//                [self.tableView reloadData];
//                [self noHiddenHint];
//            }
//            return ;
//        }
//        
//        if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
//            
//            [self.datasource removeAllObjects];
//            [UMessage removeAllTags:^(id responseObject, NSInteger remain, NSError *error) {
//            }];
//            
//            NSDictionary *resDic =  result;
//            [resDic writeToFile:path atomically:YES];
//            
//            NSArray *array = result[RESULT][@"lists"];
//            for (NSDictionary *dic in array) {
//                Course *course = [[Course alloc] init];
//                [course setValuesForKeysWithDictionary:dic];
//                [self.datasource addObject:course];
//                [UMessage addTag:[NSString stringWithFormat:@"c%@%@", course.courseId,course.teachingId]
//                        response:^(id responseObject, NSInteger remain, NSError *error) {
//                            //add your codes
//                        }];
//            }
//            [UMessage addTag:[NSString stringWithFormat:@"o%@", onceLogin.organizationCode]
//                    response:^(id responseObject, NSInteger remain, NSError *error) {
//                        //add your codes
//                    }];
//        } else if ([result[RESULT_STATUS] isEqualToString:RESULT_LOGIN]) {
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
//            return;
//        }
//        
//        if (!self.datasource.count || !self.datasource) {
//            [self.tableView reloadData];
//            [self hiddenHint];
//            [KVNProgress dismiss];
//        } else {
//            [self.tableView reloadData];
//            [self noHiddenHint];
//            [KVNProgress dismiss];
//        }
//    }];
//}

- (void)getHomePageData {
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    
    if (!onceLogin.studentPhoneNum.length || !onceLogin.studentPassword.length) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:^{
        }];
        return;
    }
    
    [SANetWorkingTask requestWithPost:[SAURLManager login] parmater:@{STUDENTPHONENUM: onceLogin.studentPhoneNum, STUDENTPASSWORD:[onceLogin.studentPassword md5ForString]} blockOrError:^(id result, NSError *error) {
        
        if (error) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [self presentViewController:loginVC animated:YES completion:^{
            }];
            return ;
        }
        
        if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
            
            result = result[RESULT];
            
            NSDictionary *user = result[USER];
            
            OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
            onceLogin.studentID = user[STUDENTID];
            onceLogin.imageURL = user[IMAGEURL];
            onceLogin.studentSex = user[STUDENTSEX];
            onceLogin.studentName = user[STUDENTNAME];
            onceLogin.privacyState = user[PRIVACYSTATE];
            onceLogin.studentNumber = user[STUDENTNUMBER];
            onceLogin.organizationName = user[ORGANIZATIONNAME];
            onceLogin.organizationCode = user[ORGANIZATIONCODE];
            onceLogin.sessionId = user[SESSIONID];
            
            [onceLogin writeToLocal];
            
            NSMutableArray *bannerArr = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *dic in result[BANNER]) {
                BannerModel *bannerModel = [[BannerModel alloc] initWithDictionary:dic];
                [bannerArr addObject:bannerModel.content];
            }
            if (bannerArr.count) {
             [self.circleSrollView images:bannerArr];
            }
            
            NewsModel *message = [[NewsModel alloc] initWithDictionary:result[MESSAGE]];
            message.teacherName = @"wangjiannan";
            message.beginDateTime = @"2017-12-12";
            message.messageContent = @"这是一个非常长的小心";
            message.messageTitle = @"新消息";
            
            if (message.messageContent && message.messageContent.length) {
                [self.datasource addObject:message];
            }
            
            HistoryTalkModel *historyTalkModel = [[HistoryTalkModel alloc] initWithDictionary:result[SAYING]];
            historyTalkModel.month = [self getNowTime];
            
            if (historyTalkModel.content) {
                
                NSArray *dataArr = [[self getNowTime] componentsSeparatedByString:@"/"];
                historyTalkModel.month = [[dataArr firstObject] stringByAppendingString:@"月"];
                historyTalkModel.date = [dataArr lastObject];
                TodayTalkStatusLayout *todayTalkStatusLayout = [[TodayTalkStatusLayout alloc] initWithStatus:historyTalkModel];
                [self.datasource addObject:todayTalkStatusLayout];
            }
            [self.tableView reloadData];
            
        } else {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [self presentViewController:loginVC animated:YES completion:^{
            }];
        }
    }];

    
}

- (NSMutableArray *)datasource {
    if (!_datasource) {
        self.datasource = [NSMutableArray arrayWithCapacity:0];
    }
    return _datasource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = TABLEBACKGROUND;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableHeaderView = self.circleSrollView;
        
//        self.courseTableViewCell = [UINib nibWithNibName:@"CourseTableViewCell" bundle:nil];
//        [_tableView registerNib:self.courseTableViewCell forCellReuseIdentifier:@"courseTableViewCell"];
        self.dragTableViewCell = [UINib nibWithNibName:@"DragTableViewCell" bundle:nil];
        [_tableView registerNib:self.dragTableViewCell forCellReuseIdentifier:@"dragTableViewCell"];
        
        self.todayHistoryTableViewCell = [UINib nibWithNibName:@"TodayHistoryTableViewCell" bundle:nil];
        [_tableView registerNib:self.todayHistoryTableViewCell forCellReuseIdentifier:@"todayHistoryTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"TodayTalkTableViewCell" bundle:nil] forCellReuseIdentifier:@"todayTalkTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"messageTableViewCell"];
        
//        __weak typeof(self) weakSelf =self;
//        [_tableView addPullToRefreshActionHandler:^{
//            typeof(self) strongSelf = weakSelf;
//            [strongSelf insertRowAtTop];
//            
//        } ProgressImagesGifName:@"farmtruck@2x.gif" LoadingImagesGifName:@"jgr@2x.gif" ProgressScrollThreshold:70 LoadingImageFrameRate:30];
//        
//        // If you did not change scrollview inset, you don't need code below.
//        if(IS_IOS7)
//            [self.tableView addTopInsetInPortrait:0 TopInsetInLandscape:52];
//        else if(IS_IOS8)
//        {
//            CGFloat landscapeTopInset = 32.0;
//            if(IS_IPHONE6PLUS)
//                landscapeTopInset = 44.0;
//            [self.tableView addTopInsetInPortrait:0 TopInsetInLandscape:landscapeTopInset];
//        }

    }
    return _tableView;
}

- (CircleScrollView *)circleSrollView {
    if (!_circleSrollView) {
        CGSize sSize = [UIScreen mainScreen].bounds.size;
        self.circleSrollView = [[CircleScrollView alloc] initWithFrame:CGRectMake(0, 0, sSize.width, sSize.width * 280 / 750.0)];
        _circleSrollView.delegate = self;
        [_circleSrollView images:@[[UIImage imageNamed:@"Banner"]]];      // 占位图
    }
    return _circleSrollView;
}

- (NSString *)getNowTime {
    
    NSDate *senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"M/d"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
//    NSArray *chunks = [locationString componentsSeparatedByString:@"/"];
//    NSString *timeStr = [NSString string];
//    for (NSString *str in chunks) {
//        if (timeStr.length) {
//            timeStr = [timeStr stringByAppendingString:[NSString stringWithFormat:@"/%d", [str intValue]]];
//        } else {
//            timeStr = [timeStr stringByAppendingString:[NSString stringWithFormat:@"%d", [str intValue]]];
//        }
//        
//    }
    return locationString;
}

- (void)getTodayHistoryDate {
    
    [SANetWorkingTask request:[SAURLManager getTodayHistory] parmater:@{@"key": @"e70fb3049d48a00ed3b9b1b7f8447d9d", @"date": [self getNowTime]} block:^(NSDictionary *result) {
        
        if ([result[@"reason"] isEqualToString:@"success"]) {
            
            NSMutableArray *historys = [NSMutableArray arrayWithCapacity:0];
            
            for (NSDictionary *dic in result[@"result"]) {
                TodayHistoryModel *model = [[TodayHistoryModel alloc] initWithDictionary:dic];
                [historys addObject:model];
            }
            self.todayHistoryLayout = [[TodayHistoryLayout alloc] initWithStatus:historys];
            [self.tableView reloadData];
        }
    }];
}

//- (void)insertRowAtTop {
//    __weak typeof(self) weakSelf = self;
//    self.isLoading =YES;
//    int64_t delayInSeconds = 2.2;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        typeof(self) strongSelf = weakSelf;
////        [strongSelf.tableView beginUpdates];
////        [strongSelf.pData insertObject:[NSDate date] atIndex:0];
////        [strongSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
////        [strongSelf.tableView endUpdates];
//        OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
//        
//        
//        [SANetWorkingTask requestWithPost:[SAURLManager queryCourseInfo] parmater:@{ORGANIZATIONCODE: onceLogin.organizationCode, STUDENTID:onceLogin.studentID}blockOrError:^(id result, NSError *error) {
//            
//            if (error) {
//                [strongSelf.tableView stopPullToRefreshAnimation];
//                strongSelf.isLoading = NO;
//                return ;
//            }
//            if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
//                [self.datasource removeAllObjects];
//                NSArray *array = result[RESULT][@"lists"];
//                for (NSDictionary *dic in array) {
//                    Course *course = [[Course alloc] init];
//                    [course setValuesForKeysWithDictionary:dic];
//                    [self.datasource addObject:course];
//                }
//            }
//            
//            if (!self.datasource.count || !self.datasource) {
//                [self hiddenHint];
//                [KVNProgress dismiss];
//            } else {
//                [self.tableView reloadData];
//                [self noHiddenHint];
//                [KVNProgress dismiss];
//            }
//            [strongSelf.tableView stopPullToRefreshAnimation];
//            strongSelf.isLoading = NO;
//        }];
//    });
//}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    } else {
         return 8;
    }  
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return WIDTH / 2;
    } else if (indexPath.section == self.datasource.count + 1){
        return self.todayHistoryLayout ? self.todayHistoryLayout.height : 100;
    } else {
        
        if ([self.datasource[indexPath.section - 1] isKindOfClass:[TodayTalkStatusLayout class]]) {
            
            TodayTalkStatusLayout *todayHsitoryLayout = self.datasource[indexPath.section - 1];
            return todayHsitoryLayout.height;
            
        } else if ([self.datasource[indexPath.section - 1] isKindOfClass:[NewsModel class]]) {
            return 120;
        } else {
            return 340;
        }
    }
} 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DragTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dragTableViewCell"];
        cell.delegate = self;
        return cell;
    } else if (indexPath.section == self.datasource.count + 1){
        TodayHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todayHistoryTableViewCell"];
        cell.delegate = self;
        if (self.todayHistoryLayout) {
            [cell setTodayHistoryLayout:self.todayHistoryLayout];
        }
        return cell;
    } else if ([self.datasource[indexPath.section - 1] isKindOfClass:[NewsModel class]]) {
        
        MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageTableViewCell"];
        cell.newsModel = self.datasource[indexPath.section - 1];
        return cell;
        
    } else {
        TodayTalkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todayTalkTableViewCell"];
        [cell setTodayTalkStatusLayout:self.datasource[indexPath.section - 1]];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datasource.count + 2;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (!self.datasource.count) {
//        return;
//    }
//    ExerciseViewController *exerciseViewController = [[ExerciseViewController alloc] initWithCourse:self.datasource[indexPath.row]];
//    
//    [self.navigationController pushViewController:exerciseViewController animated:YES];
//}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 2) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - TodayHistoryCellDelegate

- (void)didClickTodayHistory:(TodayHistoryModel *)todayHistory {
    
    TodayHistoryViewController *todayHistoryViewController = [[TodayHistoryViewController alloc] initWithTodayHistoryModel:todayHistory];
    [self.navigationController pushViewController:todayHistoryViewController animated:YES];
}

//#pragma mark - 重载父类方法
//
//- (void)hiddenHint {
//    [super hiddenHint];
//    self.tableView.hidden = YES;
//}
//
//- (void)noHiddenHint {
//    [super noHiddenHint];
//    self.tableView.hidden = NO;
//}
//
//- (void)backBtuDidPress {
//    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
////    [self getCourse:onceLogin];
//}

#pragma mark - CircleScrollViewDelegate

-(void)didClickImageAtIndex:(NSInteger)index scrollView:(CircleScrollView *)scrollView {
    
}

#pragma mark - DragTableViewCellDelegate

- (void)dragTableViewCellDidSelect:(NSInteger)index {
    switch (index) {
        case 0:
        {
            ExerciseViewController *exerciseViewController = [[ExerciseViewController alloc] init];
            [self.navigationController pushViewController:exerciseViewController animated:YES];
            break;
        }
        case 1:
        {
            
        }
        default:
            break;
    }
}

@end
