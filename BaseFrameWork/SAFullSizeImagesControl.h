//
//  DR6FullSizeImagesControl.h
//  DouguoRecipes6
//
//  Created by 王建男 on 15/1/12.
//  Copyright (c) 2015年 Douguo Inc. All rights reserved.
//

#import "SAFullSizeImageControl.h"
#import "SDImageCache.h"

@protocol SAFullSizeImagesControlDelegate;


@interface SAFullSizeImagesControl : SAFullSizeImageControl<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign) NSObject<SAFullSizeImagesControlDelegate, SAFullSizeImageControlDelegate> *delegate;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSArray *imageURLs;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) NSMutableArray *scrollViews;
@property (nonatomic, strong) NSArray *images;

@property (nonatomic, assign) NSInteger currentPage;

- (void)showImages:(NSArray *)images imageURLs:(NSArray *)imageURLs fromView:(UIView *)view index:(NSInteger )index;
- (void)showImage:(UIImage *)image imageURL:(NSString *)imageURL fromView:(UIView *)view;

@end



@protocol SAFullSizeImagesControlDelegate <SAFullSizeImageControlDelegate>

@optional

- (NSArray *)sourceViews;

- (void)fullSizeImagesControlDidLongPress:(NSInteger )index;

@end
