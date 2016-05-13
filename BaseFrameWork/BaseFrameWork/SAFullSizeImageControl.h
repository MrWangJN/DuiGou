//
//  SAFullSizeImageControl.h
//  BaseFrameWork
//
//  Created by wjn on 16/5/7.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "SAKit.h"

@protocol SAFullSizeImageControlDelegate;

@interface SAFullSizeImageControl : UIControl<UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (nonatomic, assign) NSObject<SAFullSizeImageControlDelegate> *delegate;

@property (nonatomic, strong) UIImageView *imageView;

- (CGRect)finalRectForImage:(UIImage *)image;

- (void)showImage:(UIImage *)image fromView:(UIView *)view;
- (void)showImage:(UIImage *)image imageURL:(NSString *)imageURL fromView:(UIView *)view;

- (void)imageShown;
- (void)imageShrink;

@end

@protocol SAFullSizeImageControlDelegate

@optional

- (UIView *)sourceView;

- (void)fullSizeImageControlDidLongPress:(SAFullSizeImageControl *)control;

@end
