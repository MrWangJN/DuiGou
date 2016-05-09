//
//  SAFullSizeImageControl.m
//  BaseFrameWork
//
//  Created by wjn on 16/5/7.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "SAFullSizeImageControl.h"

@implementation SAFullSizeImageControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        [self addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
        
        UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
        [self addGestureRecognizer:gestureRecognizer];
    }
    return self;
}

#pragma mark - property

- (UIImageView *)imageView {
    
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.clipsToBounds = YES;
        _imageView.userInteractionEnabled = NO;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UIWindow *)properWindow {
    
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    
    BOOL isWrongWindow = [window isKindOfClass:NSClassFromString(@"_UIAlertOverlayWindow")];
    isWrongWindow = isWrongWindow || [window isKindOfClass:NSClassFromString(@"DGStatusBarAlertWindow")];
    
    //add message to the most front window, except the alertview windows / actionsheet
    if (isWrongWindow && [UIApplication sharedApplication].windows.count) {
        NSInteger index = [[UIApplication sharedApplication].windows indexOfObject:window];
        window = [UIApplication sharedApplication].windows[--index];
    }
    
    return window;
}

#pragma mark - public

- (CGRect)finalRectForImage:(UIImage *)image {
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    
    if (!image) {
        return screenBounds;
    }
    
    CGSize imageSize = CGSizeMake(screenBounds.size.width, image.size.height * screenBounds.size.width / image.size.width);
    
    if (imageSize.height > screenBounds.size.height) {
        imageSize = CGSizeMake(imageSize.width * screenBounds.size.height / imageSize.height, screenBounds.size.height);
    }
    
    CGRect rect = CGRectMake((screenBounds.size.width - imageSize.width) / 2, (screenBounds.size.height - imageSize.height) / 2, imageSize.width, imageSize.height);
    
    return rect;
}

- (void)showImage:(UIImage *)image fromView:(UIView *)view {
    [self showImage:image imageURL:nil fromView:view];
}

- (void)showImage:(UIImage *)image imageURL:(NSString *)imageURL fromView:(UIView *)view {
    
    //    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    if (!image && imageURL.length <= 0) {
        return;
    }
    
    UIImage *presentingImage = image;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:image];
    
    
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageURL];
    if (cachedImage) {
        presentingImage = cachedImage;
    }

    
    [self addSubview:self.imageView];
    
    
    
    UIView *keyWindow = [self properWindow];
    CGRect rect = [view.superview convertRect:view.frame toView:keyWindow];
    self.imageView.frame = rect;
    
    
    
    self.backgroundColor = [UIColor clearColor];
    
    [keyWindow addSubview:self];
    
    CGFloat startRadius = view.layer.cornerRadius;
    CGFloat endRadius = 0;
    if (startRadius) {
        self.imageView.layer.cornerRadius = startRadius;
    }
    
    view.hidden = YES;
    
    CGFloat duration = 0.3;
    
    if (startRadius) {
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        
        animation.delegate = self;
        
        animation.fromValue = @(startRadius);
        animation.toValue = @(endRadius);
        animation.duration = duration;
        
        [self.imageView.layer addAnimation:animation forKey:@"cornerRadius"];
        
        self.imageView.layer.cornerRadius = 0;
    }
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:7 << 16
                     animations:^{
                         self.backgroundColor = [UIColor blackColor];
                         self.imageView.frame = [self finalRectForImage:presentingImage];
                         
                     } completion:^(BOOL finished) {
                         
                         self.imageView.layer.cornerRadius = endRadius;
                         [self imageShown];
                         view.hidden = NO;
                     }];
    
    
}

- (void)pressed:(id)sender {
    
    UIView *sourceView = nil;
    sourceView = [self.delegate sourceView];
    
    
    //    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
    CGFloat duration = 0.3;
    CGFloat startRadius = sourceView.layer.cornerRadius;
    CGFloat endRadius = 0;
    
    UIView *rootView = [UIApplication sharedApplication].keyWindow;
    CGRect rect = self.imageView.frame;
    
    if (sourceView) {
        rect = [sourceView.superview convertRect:sourceView.frame toView:rootView];
        
        if (startRadius) {
            self.imageView.layer.cornerRadius = endRadius;
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
            
            animation.fromValue = @(endRadius);
            animation.toValue = @(startRadius);
            animation.duration = duration;
            [self.imageView.layer addAnimation:animation forKey:@"cornerRadius"];
            
            self.imageView.layer.cornerRadius = startRadius;
        }
    }
    
    sourceView.hidden = YES;
    [UIView animateWithDuration:duration
                          delay:0
                        options:7 << 16
                     animations:^{
                         
                         [self imageShrink];
                         self.imageView.frame = rect;
                         self.backgroundColor = [UIColor clearColor];
                     } completion:^(BOOL finished) {
                         sourceView.hidden = NO;
                         [UIView animateWithDuration:0.2
                                               delay:0
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              self.alpha = 0;
                                          } completion:^(BOOL finished) {
                                              [self removeFromSuperview];
                                          }];
                     }];
}

- (void)longPressed:(UILongPressGestureRecognizer *)presser {
    [self.delegate fullSizeImageControlDidLongPress:self];
}

- (void)imageShown {
    
}

- (void)imageShrink {
    
}

@end
