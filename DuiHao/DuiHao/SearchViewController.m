//
//  SearchViewController.m
//  StudyAssisTant
//
//  Created by wjn on 15/8/20.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SearchViewController.h"
#import "OnceLogin.h"
#import "OrganizationModel.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  searchBar
     */
    
    self.searchBar.tintColor = [UIColor whiteColor];
    [self.searchBar setBackgroundImage:[UIImage new]];
    for (UIView* subview in [[self.searchBar.subviews lastObject] subviews]) {
        if ([subview isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField*)subview;
            [textField setBackgroundColor:MAINCOLOR];
            textField.textColor = [UIColor whiteColor];
        }
    }
    
    /**
     *  tableView
     */
    

    
    /**
     *  Location
     */
    [self.locationManager startUpdatingLocation];
}

#pragma mark - private

- (LocationManager *)locationManager {
    if (!_locationManager) {
        self.locationManager = [[LocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (NSMutableArray *)datasource {
    if (!_datasource) {
        self.datasource = [NSMutableArray arrayWithCapacity:0];
    }
    return _datasource;
}

- (IBAction)backButtonDidPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


#pragma mark - searchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (!searchText.length) {
         [self.tableView reloadData];
        return;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:searchText, ORGANIZATIONNAME, nil];
    
    [SANetWorkingTask requestWithPost:[SAURLManager querySchoolInfo] parmater:dic block:^(id result) {
    
        [self.datasource removeAllObjects];
        
        if ([result[RESULT_STATUS]  isEqual: RESULT_OK]) {
            
            result = result[RESULT];
            
            for (NSDictionary *dic in result[@"lists"]) {
                
                OrganizationModel *organizationModel = [[OrganizationModel alloc] initWithResult:dic];
                [self.datasource addObject:organizationModel];
            }
        } else {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showError:self title:@"错误" subTitle:result[ERRORMESSAGE] closeButtonTitle:@"确定" duration:0.0f];
            [self.searchBar resignFirstResponder];
        }
        [self.tableView reloadData];
    }];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"School"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"School"];
    }
    
    
    if (self.datasource.count > indexPath.row) {
        OrganizationModel *organizationModel = self.datasource[indexPath.row];
        [cell.textLabel setText:organizationModel.organizationName];
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if ([self.delegate respondsToSelector:@selector(schoolAndNumber:)]) {
//        [self.delegate schoolAndNumber:self.datasource[indexPath.row]];
//    }
    
    OrganizationModel *organizationModel = self.datasource[indexPath.row];
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    [SANetWorkingTask requestWithPost:[SAURLManager bindInformation] parmater:@{STUDENTID: onceLogin.studentID,INFOFLAG: ORGANIZATION, STUDENTINFO: organizationModel.organizationCode} block:^(id result) {
        
        onceLogin.organizationName = organizationModel.organizationName;
        [onceLogin writeToLocal];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        });
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - LocationManagerDelegate

- (void)city:(NSString *)cityStr {
    [self.showLocation setText:[NSString stringWithFormat:@"当前定位城市为%@", cityStr]];
    
    if (!cityStr.length) {
        [self.tableView reloadData];
        return;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:cityStr, CITYNAME, nil];
    
    [SANetWorkingTask requestWithPost:[SAURLManager querySchoolInfoForCity] parmater:dic block:^(id result) {
        
        [self.datasource removeAllObjects];
        
        if ([result[RESULT_STATUS]  isEqual: RESULT_OK]) {
            
            result = result[RESULT];
            
            for (NSDictionary *dic in result[@"lists"]) {
                
                OrganizationModel *organizationModel = [[OrganizationModel alloc] initWithResult:dic];
                [self.datasource addObject:organizationModel];
            }
        } else {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showError:self title:@"错误" subTitle:result[ERRORMESSAGE] closeButtonTitle:@"确定" duration:0.0f];
            [self.searchBar resignFirstResponder];
        }
        [self.tableView reloadData];
    }];
    
}

- (void)locationManagerWithError:(NSError *)error {
    [self.showLocation setText:@"定位失败"];
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
