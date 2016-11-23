//
//  BindInformationViewController.m
//  DuiHao
//
//  Created by wjn on 16/4/20.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "BindInformationViewController.h"
#import "OnceLogin.h"
#import "BindHeaderImageTableViewCell.h"
#import "BindOtherTableViewCell.h"
#import "KVNProgress.h"
#import "ChangeInformationViewController.h"
#import "ChangeImageViewController.h"
#import "SearchViewController.h"
#import "ChangePhoneViewController.h"

#define TITLE @"title"
#define CONTENT @"content"

@interface BindInformationViewController ()<UITableViewDelegate, UITableViewDataSource, LCActionSheetDelegate>

@end

@implementation BindInformationViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationItem setTitle:@"个人信息"];
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)heaherDatasource {

    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    self.heaherDatasource = @[@{TITLE : @"头像", CONTENT : onceLogin.imageURL}];
    return _heaherDatasource;
}

- (NSArray *)personDatasource {
  
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    self.personDatasource = @[@{TITLE : @"姓名", CONTENT : onceLogin.studentName}, @{TITLE : @"性别", CONTENT : onceLogin.studentSex}, @{TITLE : @"手机号", CONTENT : onceLogin.studentPhoneNum}];
    return _personDatasource;
}

- (NSArray *)schoolDatasource {

    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    self.schoolDatasource = @[@{TITLE : @"学校", CONTENT : onceLogin.organizationName}, @{TITLE : @"学号", CONTENT : onceLogin.studentNumber}];
    return _schoolDatasource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = TABLEBACKGROUND;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UINib *bindHeaderImageNib = [UINib nibWithNibName:@"BindHeaderImageTableViewCell" bundle:nil];
        UINib *bindOtherNib = [UINib nibWithNibName:@"BindOtherTableViewCell" bundle:nil];
        
        [self.tableView registerNib:bindHeaderImageNib forCellReuseIdentifier:@"BindHeaderImageTableViewCell"];
        [self.tableView registerNib:bindOtherNib forCellReuseIdentifier:@"BindOtherTableViewCell"];
        
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return CGFLOAT_MIN;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 90;
    } else if (indexPath.section == 1) {
        return 50;
    } else {
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        BindHeaderImageTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"BindHeaderImageTableViewCell"];
        [cell.headerImageVIew setImageWithURL:[self.heaherDatasource firstObject][CONTENT] withborderWidth:0];
        return cell;
    } else {
       BindOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BindOtherTableViewCell"];
        if (indexPath.section == 1) {
            
            [cell setTitle:self.personDatasource[indexPath.row][TITLE] withContent:self.personDatasource[indexPath.row][CONTENT]];

        } else {
            
            [cell setTitle:self.schoolDatasource[indexPath.row][TITLE] withContent:self.schoolDatasource[indexPath.row][CONTENT]];
        }
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.heaherDatasource.count;
    } else if (section == 1) {
        return self.personDatasource.count;
    } else {
        return self.schoolDatasource.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    
    if (indexPath.section == 0) {
        
        ChangeImageViewController *changeImageVC = [[ChangeImageViewController alloc] initWithUrl:onceLogin.imageURL];
                
        [self.navigationController pushViewController:changeImageVC animated:YES];
        
    } else {
        
        ChangeInformationType type;
        NSString *title;
        NSString *content;
        UIKeyboardType keyboardType;
        
        if (indexPath.section == 1) {
            switch (indexPath.row) {
                case 0:
                type = StudentName;
                title = @"姓名";
                
                if (onceLogin.studentName.length) {
                    content = onceLogin.studentName;
                }
                
                keyboardType = UIKeyboardTypeDefault;
                
                break;
                
                case 1:
                type = StudentSex;
                keyboardType = UIKeyboardTypeNumberPad;
                    
                [self changeGender];
                
                break;
                
                case 2:
                type = StudentPhoneNum;
                break;
                
                default:
                break;
            }
        } else {
            switch (indexPath.row) {
                case 0:
                type = OrganizationName;
                title = @"学校";
                
                keyboardType = UIKeyboardTypeDefault;
                
                break;
                
                case 1:
                type = StudentNumber;
                title = @"学号";
                
                if (onceLogin.studentNumber.length) {
                    content = onceLogin.studentNumber;
                }
                
                keyboardType = UIKeyboardTypeNumberPad;
                
                break;
                
                default:
                break;
            }
        }
        
        if (type != OrganizationName && type != StudentSex && type != StudentPhoneNum) {
            
            ChangeInformationViewController *changeInformationVC = [[ChangeInformationViewController alloc] initWithType:type withTitle:title whitContent:content withKeyboardType:keyboardType];
            [self.navigationController pushViewController:changeInformationVC animated:YES];
            
        } else if (type == OrganizationName) {
            
            SearchViewController *searchViewController = [[SearchViewController alloc] init];
            [self.navigationController pushViewController:searchViewController animated:YES];
        } else if (type == StudentPhoneNum) {
            ChangePhoneViewController *changePhoneVC = [[ChangePhoneViewController alloc] init];
            [self.navigationController pushViewController:changePhoneVC animated:YES];
        }
    }
    
}

#pragma mark - changeGender

- (void)changeGender {
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil buttonTitles:@[@"男", @"女"] redButtonIndex:-1 delegate:self];
    [sheet show];
}

- (void)actionSheet:(LCActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 2) {
        return;
    }
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    
    NSString *gender = nil;
    
    switch (buttonIndex) {
        case 0: //男
            onceLogin.studentSex = @"男";
            gender = @"男";
            break;
        case 1: //女
            onceLogin.studentSex = @"女";
            gender = @"女";
            break;
    }
    // 刷新性别单行cell
    [KVNProgress showWithStatus:@"正在绑定性别"];
    [SANetWorkingTask requestWithPost:[SAURLManager bindInformation] parmater:@{STUDENTID: onceLogin.studentID,INFOFLAG: GENDER, STUDENTINFO: gender} block:^(id result) {
        [KVNProgress dismiss];
        if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            [onceLogin writeToLocal];
        } else {
            [KVNProgress showErrorWithStatus:@"绑定失败"];
        }
    }];
}

@end
