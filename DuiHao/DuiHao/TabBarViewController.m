//
//  TabBarViewController.m
//  StudyAssisTant
//
//  Created by wjn on 15/8/24.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.selectedViewController beginAppearanceTransition: YES animated: animated];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self.selectedViewController beginAppearanceTransition: NO animated: animated];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],
//                                                        NSForegroundColorAttributeName : [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1]
//                                                        } forState:UIControlStateNormal];
//    self.tabBar.hidden = YES;
    self.selectedIndex = 1;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
//    CGFloat width = self.tabBar.width / 3;
//    CGFloat hight = self.tabBar.height;
//    NSArray *images = @[@"Rank", @"Course_Choose", @"Mine"];
//    
//    
//    for (int i = 0; i < 3; i++) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setFrame:CGRectMake(i * width, self.view.height - hight, width, hight)];
//        button.tag = i;
//        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
//        [self.view addSubview:button];
//    }
    
    NSArray *images = @[@"Rank", @"Course", @"Mine"];
    
    for (UITabBarItem *item in self.tabBar.items) {
        item.selectedImage = [[UIImage imageNamed:images[[self.tabBar.items indexOfObject:item]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:MAINCOLOR,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    }
    
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
