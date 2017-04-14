//
//  MainViewController.m
//  StudyAssisTant
//
//  Created by wjn on 15/8/25.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "MainViewController.h"
#import "BindInformationViewController.h"
#import "OnceLogin.h"
#import "MineTableViewCell.h"
#import "MineControlTableViewCell.h"
#import "LoginViewController.h"
#import "CGPasswordViewController.h"
#import "ExitTableViewCell.h"
#import "QRCodeListViewController.h"

@interface MainViewController ()<CGPasswordViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *newsDataSource;
@property (strong, nonatomic) NSArray *cellTitles;
@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) UIBarButtonItem *newsItem;

@end

@implementation MainViewController


- (void)viewWillAppear:(BOOL)animated {
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0 / 255.0 green:128 / 255.0 blue:255 / 255.0 alpha:1]]
//                                                 forBarPosition:UIBarPositionAny
//                                                     barMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self.tableView reloadData];
    [self getNews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = false;
    [self.navigationItem setTitle:@"我的"];
//    self.cellTitles = @[@{@"title": @"我的消息", @"image":[UIImage imageNamed:@"Message"]}, @{@"title": @"我的设置", @"image":[UIImage imageNamed:@"Set"]}, @{@"title": @"意见反馈", @"image":[UIImage imageNamed:@"Support"]}, ];
//    @[@{TITLE : @"清除缓存", TITLEIMAGE : @"Rubbish", ARROWIMAGE : @"1"}, @{TITLE : @"密码修改", TITLEIMAGE : @"SecretCode", ARROWIMAGE : @"0"}, @{TITLE : @"公开排行榜", TITLEIMAGE : @"Exit", ARROWIMAGE : @"1"}];
    self.cellTitles = @[@[@{TITLE : @"考勤记录", TITLEIMAGE : @"Qrcode", ARROWIMAGE : @"0"}, @{TITLE : @"公开排行榜", TITLEIMAGE : @"Rank", ARROWIMAGE : @"1"}], @[@{TITLE : @"密码修改", TITLEIMAGE : @"ChangePassword", ARROWIMAGE : @"0"}, @{TITLE : @"清除缓存", TITLEIMAGE : @"Rubbish", ARROWIMAGE : @"1"}]];
    
    self.count = 0;
    [self.view addSubview:self.tableView];
    
    self.newsItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Message"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(newsBtuDidPress:)];
    [self.navigationItem setRightBarButtonItem:self.newsItem];
}


#pragma mark - private

- (void)newsBtuDidPress:(id)sender {
    
    if (self.newsDataSource.count) {
        NewsViewController *newsViewController = [[NewsViewController alloc] initWithNews:self.newsDataSource];
        [self.navigationController pushViewController:newsViewController animated:YES];
    } else {
        [JKAlert alertText:@"暂无消息"];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = TABLEBACKGROUND;
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"InformationTableViewCell" bundle:nil] forCellReuseIdentifier:@"InformationTableViewCell"];
        self.mineUITableViewCell = [UINib nibWithNibName:@"MineUITableViewCell" bundle:nil];
        [_tableView registerNib:self.mineUITableViewCell forCellReuseIdentifier:@"MineUITableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"MineTableViewCell" bundle:nil] forCellReuseIdentifier:@"MineTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"MineControlTableViewCell" bundle:nil] forCellReuseIdentifier:@"MineControlTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"ExitTableViewCell" bundle:nil] forCellReuseIdentifier:@"ExitTableViewCell"];

    }
    return _tableView;
}

- (NSMutableArray *)newsDataSource {
    if (!_newsDataSource) {
        self.newsDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _newsDataSource;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 130;
    }
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    
    if (indexPath.section == 0) {
        InformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InformationTableViewCell"];
        [cell reloadPersonCell];
        cell.separatorInset = UIEdgeInsetsMake(0, 600, 0, 0);
        
//        [cell setImageHeaderView:onceLogin.imageURL];
//        [cell.userLabel setText:onceLogin.sName];
        return cell;
    } else if (indexPath.section == self.cellTitles.count + 1) {
        ExitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExitTableViewCell"];
        return cell;
    } else {
        
        if (indexPath.section == self.cellTitles.count - 1) {
            if (indexPath.row == 0) {
                MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineTableViewCell"];
        
                NSDictionary *dic = [[self.cellTitles firstObject] firstObject];
                [cell setDic:dic];
                
                return cell;
            } else {
                MineControlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineControlTableViewCell"];
                return cell;
            }
        } else {
            if (indexPath.row == 0) {
                MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineTableViewCell"];
                
                NSDictionary *dic = [[self.cellTitles lastObject] firstObject];
                [cell setDic:dic];
                return cell;
            } else {
                MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineTableViewCell"];
                
                NSDictionary *dic = [[self.cellTitles lastObject] lastObject];
                [cell setDic:dic];
                return cell;
            }
        }

//        
//        MineUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineUITableViewCell"];
//        
//        NSDictionary *dic = self.cellTitles[indexPath.row - 1];
//        [cell.functionImage setImage:dic[@"image"]];
//        [cell.functionLabel setText:dic[@"title"]];
//        if (indexPath.row == 1) {
//            [cell.newsCount setNewsText:[NSString stringWithFormat:@"%ld", self.count]];
//            if (self.count == 0) {
//                cell.newsCount.hidden = YES;
//            } else {
//                cell.newsCount.hidden = NO;
//            }
//        }
//        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellTitles.count + 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0 || section == 3) {
        return 1;
    }
    
    NSArray *array = self.cellTitles[section - 1];
    return array.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
        if (onceLogin.studentID.length) {
            BindInformationViewController *bindInformationVC = [[BindInformationViewController alloc] init];
            
            [self.navigationController pushViewController:bindInformationVC animated:YES];
        } else {
            [KVNProgress showErrorWithStatus:@"信息错误 请重新登录"];
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [self presentViewController:loginVC animated:YES completion:nil];
        }
        return;
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            // 签到记录
            QRCodeListViewController *qrCodeVC = [[QRCodeListViewController alloc] init];
            [self.navigationController pushViewController:qrCodeVC animated:YES];
        }
        
        return;
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            CGPasswordViewController *cgpassword = [[CGPasswordViewController alloc] initWithNibName:@"CGPasswordViewController" bundle:nil];
            cgpassword.delegate = self;
            [self.navigationController pushViewController:cgpassword animated:YES];
        } else {
            [KVNProgress showProgress:0.0f status:@"正在清理缓存"];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *path = [paths lastObject];
            float allFile = [self folderSizeAtPath:path];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:path];
                for (NSString *p in files) {
                    NSError *error;
                    NSString *Path = [path stringByAppendingPathComponent:p];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:Path]) {
                        [[NSFileManager defaultManager] removeItemAtPath:Path error:&error];
                    }
                    // 回到主线程显示图片
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [KVNProgress updateProgress:(1.0 - [self folderSizeAtPath:path] / allFile) animated:YES];
                    });
                }
            });
            [KVNProgress showSuccessWithStatus:[NSString stringWithFormat:@"共清理%.1fM文件", allFile]];
        }
        return;
    } else {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [self presentViewController:loginViewController animated:YES completion:^{
            self.tabBarController.selectedIndex = 1;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        
        return;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getNews {
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                onceLogin.studentID, STUDENTID, nil];
    
    [SANetWorkingTask requestWithPost:[SAURLManager getMessage] parmater:dictionary blockOrError:^(id result, NSError *error) {
        [self.newsDataSource removeAllObjects];
        _count = 0;
        if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
            for (NSDictionary *dic in result[RESULT][@"lists"]) {
                NewsModel *newsModel = [[NewsModel alloc] init];
                [newsModel setValuesForKeysWithDictionary:dic];
                [self.newsDataSource addObject:newsModel];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *openTime = [defaults stringForKey:@"OpenTime"];
                
//                NSString *time = [newsModel.beginDateTime stringByReplacingOccurrencesOfString:@"-" withString:@""];
                
                NSDateFormatter *openFormatter= [[NSDateFormatter alloc] init];
                
                [openFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
                
                [openFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                NSDate *openDate = [openFormatter dateFromString:openTime];
                
                
                NSDateFormatter *beginFormatter= [[NSDateFormatter alloc] init];
                
//                [beginFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
                
                [beginFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                NSDate *beginDate = [beginFormatter dateFromString:newsModel.beginDateTime];
                
                if ([beginDate timeIntervalSinceDate:openDate] > 0) {
                     _count++;
                }
                [UIApplication sharedApplication].applicationIconBadgeNumber = _count;
                if (_count) {
                    [self.newsItem setImage:[[UIImage imageNamed:@"Message_new"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                } else {
                    [self.newsItem setImage:[[UIImage imageNamed:@"Message"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                }
                
            }
        }
    }];
}

- (void)getData {
    [self.tableView reloadData];
}

#pragma mark - filesize

- (long long) fileSizeAtPath:(NSString *) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (float) folderSizeAtPath:(NSString *) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

#pragma mark - CGPasswordViewControllerDelegate

- (void)showLoginViewController {
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    //    [loginViewController.schoolButton setTitle:onceLogin.schoolName forState:UIControlStateNormal];
    //    [loginViewController.schoolButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    loginViewController.studentId.text = onceLogin.studentID;
    loginViewController.schoolNumber = onceLogin.schoolNumber;
    [self presentViewController:loginViewController animated:NO completion:^{
    }];
    
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
