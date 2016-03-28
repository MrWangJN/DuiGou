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
        if (![self.studentID isEqualToString:onceLogin.studentID] || ![self.schoolNum isEqualToString:onceLogin.schoolNumber]) {
            self.studentID = onceLogin.studentID;
            self.schoolNum = onceLogin.schoolNumber;
            [self getCourse:onceLogin];
        } else if (!self.datasource.count) {
            [self getCourse:onceLogin];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    if (!onceLogin.studentID.length) {
        
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginViewController animated:YES completion:^{
        }];
    } else {
        
        if (onceLogin.asdState) {
            ADSViewController *asdViewController = [[ADSViewController alloc] init];
            [self.navigationController pushViewController:asdViewController animated:NO];
        } else {
            
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:onceLogin.schoolNumber, SCHOOLNUMBER,
                                        onceLogin.studentID, STUDENTID,
                                        onceLogin.passWord, STUDENTPASSWORD, nil];
            
            [SANetWorkingTask requestWithPost:[SAURLManager login] parmater:dictionary block:^(id result) {
                
                if ([result[@"flag"] isEqualToString:@"001"]) {
                    
                    onceLogin.imageURL = result[@"imageurl"];
                    onceLogin.sName = result[@"sname"];
                    onceLogin.version = result[@"version"];
                    onceLogin.message = result[@"message"];
                    
                    NSDictionary *dic = result[@"ads"];
                    onceLogin.adsImageURL = dic[@"imageName"];
                    NSString *str = dic[@"state"];
                    onceLogin.asdState = str.integerValue;
                    
                    [onceLogin writeToLocal];
                } else {
                    
                    [KVNProgress showErrorWithStatus:@"登陆信息已过期"];
                    
                    LoginViewController *loginViewController = [[LoginViewController alloc] init];
                    [self presentViewController:loginViewController animated:YES completion:^{
                        
                    }];
                }
            }];
            self.studentID = onceLogin.studentID;
            self.schoolNum = onceLogin.schoolNumber;
//            [self getCourse:onceLogin];
        }
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

- (void)getCourse:(OnceLogin *)onceLogin {
    
    [KVNProgress showWithStatus:@"正在努力加载中"];
    [SANetWorkingTask requestWithPost:[SAURLManager queryCourseInfo] parmater:@{SCHOOLNUMBER: onceLogin.schoolNumber, STUDENTID:onceLogin.studentID}block:^(id result) {
        result = (NSDictionary *)result;
        [self.datasource removeAllObjects];
        
        if (result[@"flag"]) {
            NSArray *array = result[@"course"];
            for (NSDictionary *dic in array) {
                Course *course = [[Course alloc] init];
                [course setValuesForKeysWithDictionary:dic];
                [self.datasource addObject:course];
            }
        }
        if (!self.datasource.count) {
//            SCLAlertView *alert = [[SCLAlertView alloc] init];
//            [alert showError:self title:@"错误" subTitle:@"暂时没有课程" closeButtonTitle:@"确定" duration:0.0f];
            [KVNProgress showErrorWithStatus:@"暂未获取到任何课程信息"];
        }

        [self.tableView reloadData];
        [KVNProgress dismiss];
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
        [SANetWorkingTask requestWithPost:[SAURLManager queryCourseInfo] parmater:@{SCHOOLNUMBER: onceLogin.schoolNumber, STUDENTID:onceLogin.studentID}blockOrError:^(id result, NSError *error) {
            if (error) {
                [strongSelf.tableView stopPullToRefreshAnimation];
                strongSelf.isLoading =  NO;
                return ;
            }
            result = (NSDictionary *)result;
            [self.datasource removeAllObjects];
            
            if (result[@"flag"]) {
                NSArray *array = result[@"course"];
                for (NSDictionary *dic in array) {
                    Course *course = [[Course alloc] init];
                    [course setValuesForKeysWithDictionary:dic];
                    [self.datasource addObject:course];
                }
            }
            if (!self.datasource.count) {
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                [alert showError:self title:@"错误" subTitle:@"暂时没有课程" closeButtonTitle:@"确定" duration:0.0f];
            }
            
            [self.tableView reloadData];
            //Stop PullToRefresh Activity Animation
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
    ExerciseViewController *exerciseViewController = [[ExerciseViewController alloc] initWithCourse:self.datasource[indexPath.row]];
    
    [self.navigationController pushViewController:exerciseViewController animated:YES];
}

@end
