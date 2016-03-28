//
//  StartViewController.m
//  StudyAssisTant
//
//  Created by wjn on 15/8/10.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "StartViewController.h"
#import "ViewController.h"

#define StateColumn 20

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setHidden:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
}

#pragma mark -
#pragma mark pravate

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        [_scrollView setContentSize:CGSizeMake(self.view.width * self.imageArray.count, 0)];
        [_scrollView setPagingEnabled:YES];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        
        for (NSString *imageName in self.imageArray) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_scrollView.width * [self.imageArray indexOfObject:imageName], _scrollView.top - StateColumn, _scrollView.width, _scrollView.height)];
            [imageView setBackgroundColor:[UIColor redColor]];
//            [imageView setContentMode:UIViewContentModeScaleAspectFill];
            [imageView setImage:[UIImage imageNamed:imageName]];
            [_scrollView addSubview:imageView];
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(_scrollView.width * (self.imageArray.count - 1) + _scrollView.width / 4, self.view.bottom - self.view.width / 7 - 70, self.view.width / 2, self.view.width / 7);
        [button setBackgroundImage:[UIImage imageNamed:@"Start"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonDidPress:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
        
        
        
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.bottom - 40, self.view.width, 20)];
        _pageControl.numberOfPages = self.imageArray.count;
    }
    return _pageControl;
}

- (NSArray *)imageArray {
    //imageNunbers
    if (!_imageArray) {
        _imageArray = @[@"FirstLaunch", @"SecondLaunch", @"ThridLaunch"];
    }
    return _imageArray;
}

- (void)buttonDidPress:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TabBarViewController *viewcontroller = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
    CATransition *animation = [CATransition animation];
    animation.duration = 1.5f;
    [animation setType:@"rippleEffect"];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController pushViewController:viewcontroller animated:YES];
    
}

#pragma mark - UISrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = (NSInteger)scrollView.contentOffset.x / self.view.width;
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
