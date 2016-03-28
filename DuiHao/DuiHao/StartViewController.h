//
//  StartViewController.h
//  StudyAssisTant
//
//  Created by wjn on 15/8/10.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"
#import "TabBarViewController.h"

@interface StartViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *imageArray;

@end
