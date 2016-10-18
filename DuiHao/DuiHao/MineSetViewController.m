//
//  MineSetViewController.m
//  StudyAssisTant
//
//  Created by wjn on 15/8/28.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "MineSetViewController.h"

@interface MineSetViewController ()

@end

@implementation MineSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationItem setTitle:@"我的设置"];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)datasource {
    if (!_datasource) {
        self.datasource = @[@{TITLE : @"版本检查", TITLEIMAGE : @"Rubbish", ARROWIMAGE : @"1"}, @{TITLE : @"清除缓存", TITLEIMAGE : @"Rubbish", ARROWIMAGE : @"1"}, @{TITLE : @"密码修改", TITLEIMAGE : @"SecretCode", ARROWIMAGE : @"0"}, @{TITLE : @"公开排行榜", TITLEIMAGE : @"Exit", ARROWIMAGE : @"1"}];
    }
    return _datasource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = TABLEBACKGROUND;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        self.mineTableViewCell = [UINib nibWithNibName:@"MineTableViewCell" bundle:nil];
        self.mineControlTableViewCell = [UINib nibWithNibName:@"MineControlTableViewCell" bundle:nil];
        self.exitTableViewCell = [UINib nibWithNibName:@"ExitTableViewCell" bundle:nil];
        
        [_tableView registerNib:self.mineTableViewCell forCellReuseIdentifier:@"MineTableViewCell"];
        [_tableView registerNib:self.mineControlTableViewCell forCellReuseIdentifier:@"MineControlTableViewCell"];
        [_tableView registerNib:self.exitTableViewCell forCellReuseIdentifier:@"ExitTableViewCell"];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == self.datasource.count - 1) {
            
            MineControlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineControlTableViewCell"];
            return cell;
            
        } else {
            MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineTableViewCell"];
            if (self.datasource.count > indexPath.row) {
                [cell setDic:self.datasource[indexPath.row]];
            }
            return cell;
        }
        
    } else {
        ExitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExitTableViewCell"];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.datasource.count;
    } else {
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 1) {
        
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [self presentViewController:loginViewController animated:YES completion:^{
            self.tabBarController.selectedIndex = 1;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        
        return;
    }

    
    if (indexPath.row == Rubbish) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *path = [paths lastObject];
        
        float allFile = [self folderSizeAtPath:path];
        
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:path];
        for (NSString *p in files) {
            NSError *error;
            NSString *Path = [path stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:Path]) {
                [[NSFileManager defaultManager] removeItemAtPath:Path error:&error];
            }
            [KVNProgress updateProgress:(1.0 - [self folderSizeAtPath:path] / allFile) animated:YES];
        }
        [KVNProgress showSuccessWithStatus:[NSString stringWithFormat:@"清理完成，共清理%.1fM文件", allFile]];
    }
    
    if (indexPath.row == SecretCode) {
        CGPasswordViewController *cgpassword = [[CGPasswordViewController alloc] initWithNibName:@"CGPasswordViewController" bundle:nil];
        cgpassword.delegate = self;
        [self.navigationController pushViewController:cgpassword animated:YES];
    }
    
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
