//
//  SAViewController.m
//  SAFramework
//
//  Created by wjn on 15/9/4.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAViewController.h"

@interface SAViewController ()

@end

@implementation SAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tabBarController.tabBar setHidden:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonDidPress)];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - backbutton

- (void)backButtonDidPress {
    [self.navigationController popViewControllerAnimated:YES];
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
