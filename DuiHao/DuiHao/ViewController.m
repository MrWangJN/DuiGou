//
//  ViewController.m
//  StudyAssisTant
//
//  Created by 王建男 on 15/3/8.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,assign) BOOL isLoading;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController.navigationBar setHidden:NO];
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    if (onceLogin.studentID.length) {
        if (![self.studentID isEqualToString:onceLogin.studentID] || ![self.schoolNum isEqualToString:onceLogin.organizationCode]) {
            self.studentID = onceLogin.studentID;
            self.schoolNum = onceLogin.organizationCode;
            [self getCourse:onceLogin];
        } else if (!self.datasource.count || onceLogin.addCourseState) {
            [self getCourse:onceLogin];
            
            onceLogin.addCourseState = false;
            [onceLogin writeToLocal];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    // 无数据时显示的提示图片
    [self setHintImage:@"NoCourse" whihHight:110];
    
    UIBarButtonItem *scanItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Scan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(scanDidPress:)];
    [self.navigationItem setRightBarButtonItem:scanItem];
    
    UIBarButtonItem *addCourseItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"AddCourse"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(addCourseDidPress:)];
    [self.navigationItem setLeftBarButtonItem:addCourseItem];
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    if (!onceLogin.studentID.length) {
        
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginViewController animated:YES completion:^{
        }];
    } else {
        
        if (onceLogin.asdState) {
            ADSViewController *asdViewController = [[ADSViewController alloc] init];
            [self.navigationController pushViewController:asdViewController animated:NO];
        }
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:onceLogin.studentPhoneNum, STUDENTPHONENUM, [onceLogin.studentPassword md5ForString], STUDENTPASSWORD, nil];
        
        [SANetWorkingTask requestWithPost:[SAURLManager login] parmater:dictionary block:^(id result) {
            
            if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
                
                result = result[RESULT];
                OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
                onceLogin.studentID = result[STUDENTID];
                onceLogin.imageURL = result[IMAGEURL];
                onceLogin.studentSex = result[STUDENTSEX];
                onceLogin.studentName = result[STUDENTNAME];
                onceLogin.privacyState = result[PRIVACYSTATE];
                onceLogin.studentNumber = result[STUDENTNUMBER];
                onceLogin.organizationName = result[ORGANIZATIONNAME];
                onceLogin.organizationCode = result[ORGANIZATIONCODE];
                onceLogin.sessionId = result[SESSIONID];
                
                [onceLogin writeToLocal];

            } else {
                
                [KVNProgress showErrorWithStatus:@"登陆信息已过期"];
                
                LoginViewController *loginViewController = [[LoginViewController alloc] init];
                [self presentViewController:loginViewController animated:YES completion:^{
                    
                }];
            }
        }];
        [self getCourse:onceLogin];
    }
    
    if ([SAReachabilityManager sharedReachabilityManager].currentReachabilityStatus == ReachableViaWWAN) {
        [KVNProgress showErrorWithStatus:@"您正处于非WIFI状态下"];
    }
	
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews {
//    self.tableView.height = self.view.height + self.tabBarController.tabBar.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

- (void)getCourse:(OnceLogin *)onceLogin {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    path = [NSString stringWithFormat:@"%@/%@", path, @"Course"];
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    if (dic) {
        
        [self.datasource removeAllObjects];
        
        NSArray *array = dic[RESULT][@"lists"];
        for (NSDictionary *dic in array) {
            Course *course = [[Course alloc] init];
            [course setValuesForKeysWithDictionary:dic];
            [self.datasource addObject:course];
        }
        [self.tableView reloadData];
    } else {
        [KVNProgress showWithStatus:@"正在努力加载课程"];
    }

    [SANetWorkingTask requestWithPost:[SAURLManager queryCourseInfo] parmater:@{ORGANIZATIONCODE: onceLogin.organizationCode, STUDENTID:onceLogin.studentID}block:^(id result) {
        
        if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
            
            [self.datasource removeAllObjects];
            
            NSDictionary *resDic =  result;
            [resDic writeToFile:path atomically:YES];
            
            NSArray *array = result[RESULT][@"lists"];
            for (NSDictionary *dic in array) {
                Course *course = [[Course alloc] init];
                [course setValuesForKeysWithDictionary:dic];
                [self.datasource addObject:course];
            }
        }
        
        if (!self.datasource.count || !self.datasource) {
            [self hiddenHint];
            [KVNProgress dismiss];
        } else {
            [self.tableView reloadData];
            [self noHiddenHint];
            [KVNProgress dismiss];
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
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        self.courseTableViewCell = [UINib nibWithNibName:@"CourseTableViewCell" bundle:nil];
        [_tableView registerNib:self.courseTableViewCell forCellReuseIdentifier:@"courseTableViewCell"];
        
        __weak typeof(self) weakSelf =self;
        [_tableView addPullToRefreshActionHandler:^{
            typeof(self) strongSelf = weakSelf;
            [strongSelf insertRowAtTop];
            
        } ProgressImagesGifName:@"farmtruck@2x.gif" LoadingImagesGifName:@"nevertoolate@2x.gif" ProgressScrollThreshold:70 LoadingImageFrameRate:30];
        
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

- (void)insertRowAtTop {
    __weak typeof(self) weakSelf = self;
    self.isLoading =YES;
    int64_t delayInSeconds = 2.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        typeof(self) strongSelf = weakSelf;
//        [strongSelf.tableView beginUpdates];
//        [strongSelf.pData insertObject:[NSDate date] atIndex:0];
//        [strongSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
//        [strongSelf.tableView endUpdates];
        OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
        
        
        [SANetWorkingTask requestWithPost:[SAURLManager queryCourseInfo] parmater:@{ORGANIZATIONCODE: onceLogin.organizationCode, STUDENTID:onceLogin.studentID}blockOrError:^(id result, NSError *error) {
            
            if (error) {
                [strongSelf.tableView stopPullToRefreshAnimation];
                strongSelf.isLoading =  NO;
                return ;
            }
            if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
                [self.datasource removeAllObjects];
                NSArray *array = result[RESULT][@"lists"];
                for (NSDictionary *dic in array) {
                    Course *course = [[Course alloc] init];
                    [course setValuesForKeysWithDictionary:dic];
                    [self.datasource addObject:course];
                }
            }
            
            if (!self.datasource.count || !self.datasource) {
                [self hiddenHint];
                [KVNProgress dismiss];
            } else {
                [self.tableView reloadData];
                [self noHiddenHint];
                [KVNProgress dismiss];
            }
            [strongSelf.tableView stopPullToRefreshAnimation];
            strongSelf.isLoading = NO;
        }];
    });
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
    
    
    CourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseTableViewCell"];
    if (self.datasource.count > indexPath.row) {
        [cell setCourseModel:self.datasource[indexPath.row]];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.datasource.count) {
        return;
    }
    ExerciseViewController *exerciseViewController = [[ExerciseViewController alloc] initWithCourse:self.datasource[indexPath.row]];
    
    [self.navigationController pushViewController:exerciseViewController animated:YES];
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
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    [self getCourse:onceLogin];
}

@end
