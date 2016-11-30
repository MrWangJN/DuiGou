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

@interface MainViewController ()

@property (strong, nonatomic) NSMutableArray *newsDataSource;
@property (strong, nonatomic) NSArray *cellTitles;
@property (assign, nonatomic) NSInteger count;

@end

@implementation MainViewController


- (void)viewWillAppear:(BOOL)animated {
    
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self.tableView reloadData];
    [self getNews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = false;
    self.cellTitles = @[@{@"title": @"我的消息", @"image":[UIImage imageNamed:@"Message"]}, @{@"title": @"我的设置", @"image":[UIImage imageNamed:@"Set"]}, @{@"title": @"意见反馈", @"image":[UIImage imageNamed:@"Support"]}];
    self.count = 0;
    [self.view addSubview:self.tableView];
}


#pragma mark - private

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        self.personalHeadTableViewCell = [UINib nibWithNibName:@"PersonalTableViewCell" bundle:nil];
        [_tableView registerNib:self.personalHeadTableViewCell forCellReuseIdentifier:@"PersonalTableViewCell"];
        self.mineUITableViewCell = [UINib nibWithNibName:@"MineUITableViewCell" bundle:nil];
        [_tableView registerNib:self.mineUITableViewCell forCellReuseIdentifier:@"MineUITableViewCell"];

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
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 240;
    }
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    
    if (indexPath.row == 0) {
        PersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalTableViewCell"];
        [cell reloadPersonCell];
//        [cell setImageHeaderView:onceLogin.imageURL];
//        [cell.userLabel setText:onceLogin.sName];
        return cell;
    } else {
        MineUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineUITableViewCell"];
        
        NSDictionary *dic = self.cellTitles[indexPath.row - 1];
        [cell.functionImage setImage:dic[@"image"]];
        [cell.functionLabel setText:dic[@"title"]];
        if (indexPath.row == 1) {
            [cell.newsCount setNewsText:[NSString stringWithFormat:@"%ld", self.count]];
            if (self.count == 0) {
                cell.newsCount.hidden = YES;
            } else {
                cell.newsCount.hidden = NO;
            }
        }
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        BindInformationViewController *bindInformationVC = [[BindInformationViewController alloc] init];
        
        [self.navigationController pushViewController:bindInformationVC animated:YES];
        return;
    } else if (indexPath.row == 1) {
        if (self.newsDataSource.count) {
            NewsViewController *newsViewController = [[NewsViewController alloc] initWithNews:self.newsDataSource];
            [self.navigationController pushViewController:newsViewController animated:YES];
        } else {
            [KVNProgress showErrorWithStatus:@"暂无消息"];
        }
        
        return;
    } else if (indexPath.row == 2) {
        MineSetViewController *mineSetViewController = [[MineSetViewController alloc] init];
        [self.navigationController pushViewController:mineSetViewController animated:YES];
        return;
    } else {
        
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
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
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
