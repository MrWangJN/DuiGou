//
//  SearchViewController.m
//  StudyAssisTant
//
//  Created by wjn on 15/8/20.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SearchViewController.h"

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
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:searchText, SCHOOLNAME, nil];
    
    [SANetWorkingTask requestWithPost:[SAURLManager querySchoolInfo] parmater:dic block:^(id result) {
    
        if ([result isKindOfClass:[NSArray class]]) {
            [self.datasource removeAllObjects];
            [self.datasource addObjectsFromArray:result];
            [self.tableView reloadData];
        }
        
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
    
    [cell.textLabel setText:[self.datasource[indexPath.row] objectForKey:SCHOOLNAME]];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(schoolAndNumber:)]) {
        [self.delegate schoolAndNumber:self.datasource[indexPath.row]];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - LocationManagerDelegate

- (void)city:(NSString *)cityStr {
    [self.showLocation setText:[NSString stringWithFormat:@"当前定位城市为%@", cityStr]];
    [SANetWorkingTask requestWithPost:[SAURLManager querySchoolInfo] parmater:[NSDictionary dictionaryWithObjectsAndKeys:cityStr, SCHOOLCITY, nil] block:^(id result) {
        
        if ([result isKindOfClass:[NSArray class]]) {
            [self.datasource removeAllObjects];
            [self.datasource addObjectsFromArray:result];
            [self.tableView reloadData];
        }
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
