//
//  DR6FullSizeImagesControl.m
//  DouguoRecipes6
//
//  Created by 王建男 on 15/1/12.
//  Copyright (c) 2015年 Douguo Inc. All rights reserved.
//

#import "SAFullSizeImagesControl.h"
#import "UIImageView+WebCache.h"

static CGFloat kMargin = 20.0;

@implementation SAFullSizeImagesControl

#pragma mark - property

- (UIScrollView *)scrollView {
	
	if (!_scrollView) {
		
		_scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
		_scrollView.pagingEnabled = YES;
		_scrollView.bounces = YES;
		_scrollView.delegate = self;
		_scrollView.showsHorizontalScrollIndicator = NO;
		_scrollView.showsVerticalScrollIndicator = NO;
	}
	return _scrollView;
}

- (UIPageControl *)pageControl {
	
	if (!_pageControl) {
		
		_pageControl = [[UIPageControl alloc]initWithFrame:CGRectZero];
//		_pageControl.currentPageIndicatorTintColor = [DR6StyleManager globalStyleManager].windowTintColor;
//		_pageControl.pageIndicatorTintColor = [DR6StyleManager globalStyleManager].imageBackgroundColor;
		_pageControl.userInteractionEnabled = NO;
	}
	return _pageControl;
}

- (NSMutableArray *)imageViews {
	
	if (!_imageViews) {
		_imageViews = [NSMutableArray arrayWithCapacity:0];
	}
	return _imageViews;
}

- (NSMutableArray *)scrollViews {
	
	if (!_scrollViews) {
		_scrollViews = [NSMutableArray arrayWithCapacity:0];
	}
	return _scrollViews;
}

- (void)setImageURLs:(NSArray *)imageURLs {
	_imageURLs = imageURLs;
	
	self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width + kMargin, self.frame.size.height);
	self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * imageURLs.count, 0);
	[self addSubview:self.scrollView];
	
	for (int i = 0; i < imageURLs.count; i++) {
		
		UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
		imageScrollView.delegate  = self;
		imageScrollView.bounces = YES;
		imageScrollView.maximumZoomScale = 1.0;
		imageScrollView.minimumZoomScale = 1.0;
		
		imageScrollView.showsHorizontalScrollIndicator = NO;
		imageScrollView.showsVerticalScrollIndicator = NO;
		
		UIImageView *imageView = [[UIImageView alloc] init];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		__weak typeof(UIImageView) *weakimageView = imageView;
		
		if (self.images.count > i) {
			imageView.image = self.images[i];
			imageView.frame = CGRectMake(0, 0, imageScrollView.width, imageScrollView.height);
			imageView.center = imageScrollView.center;
		}
		
		UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		spinner.center = imageScrollView.center;
		[spinner startAnimating];
		
		[self.scrollView addSubview:spinner];
		[imageScrollView addSubview:imageView];
		
		CGFloat enlarge = 1.5;
		
		[imageView sd_setImageWithURL:imageURLs[i] placeholderImage:imageView.image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
			
			[spinner stopAnimating];
			
			if (!image) {
				return;
			}
			
			CGFloat kHeight = self.height - weakimageView.image.size.height * self.width / weakimageView.image.size.width;
			CGFloat kWidth = self.width - self.height / weakimageView.image.size.height * weakimageView.image.size.width;
			
			if (kHeight >= 0) {
				weakimageView.frame = CGRectMake(0, kHeight / 2.0, self.width, weakimageView.image.size.height * self.width / weakimageView.image.size.width);
			} else {
				weakimageView.frame = CGRectMake(kWidth / 2.0, 0, self.height/ weakimageView.image.size.height * weakimageView.image.size.width, self.height);
			}
			
			imageScrollView.maximumZoomScale = (self.scrollView.height / weakimageView.height > enlarge ? self.height / weakimageView.height : (self.width / weakimageView.width >= 2.0 ? self.width / weakimageView.width : 2.0));
			imageScrollView.minimumZoomScale = 1.0;
		}];
		
		UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
		UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
		doubleTapGesture.numberOfTapsRequired = 2;
		[singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
		
		[imageScrollView addGestureRecognizer:doubleTapGesture];
		[imageScrollView addGestureRecognizer:singleTapGesture];
		[imageScrollView setContentSize:CGSizeMake(imageView.width, imageView.height)];
		
		[self.imageViews addObject:imageView];
		[self.scrollView addSubview:imageScrollView];
		[self.scrollViews addObject:imageScrollView];
	}
	
	CGFloat pageControlHeight = 10.0;
	CGFloat margin = 30.0;
	
	if (imageURLs.count > 1) {
		self.pageControl.frame = CGRectMake(0, self.frame.size.height - margin, self.frame.size.width, pageControlHeight);
		[self addSubview:_pageControl];
	}
}

#pragma mark - public

- (void)showImages:(NSArray *)images imageURLs:(NSArray *)imageURLs fromView:(UIView *)view index:(NSInteger )index {
	
	UIImage *presentingImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageURLs[index]];
	
	if (imageURLs.count <= 0 && !presentingImage) {
		return;
	}
	
	self.pageControl.numberOfPages = imageURLs.count;
	self.pageControl.currentPage = index;
	
	self.images = images;
	
	[self.imageView sd_setImageWithURL:[NSURL URLWithString:imageURLs[index]]];
	
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
	
	self.imageView.contentMode = UIViewContentModeScaleAspectFit;
	
	if (!self.imageView.image) {
		
		self.backgroundColor = [UIColor blackColor];
		self.imageURLs = imageURLs;
		self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * index, 0);
		self.pageControl.currentPage = index;
		
		if (self.images) {
			self.imageView.image = self.images[index];
			self.imageView.frame = [self finalRectForImage:self.images[index]];
		}
		
		self.imageView.hidden = YES;
		view.hidden = NO;
		return ;
	}
	
	[UIView animateWithDuration:duration
						  delay:0
						options:7 << 16
					 animations:^{
						 self.backgroundColor = [UIColor blackColor];
						 self.imageView.frame = [self finalRectForImage:presentingImage];
					 } completion:^(BOOL finished) {
						 
						 self.imageView.layer.cornerRadius = endRadius;
						 if (![NSStringFromCGRect(self.imageView.frame) isEqualToString:NSStringFromCGRect([self finalRectForImage:presentingImage])]) {
							 return ;
						 }
						 
						 self.currentPage = index;
						 self.imageURLs = imageURLs;
						 self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * index, 0);
						 self.pageControl.currentPage = index;
						 self.imageView.hidden = YES;
						 view.hidden = NO;

					}];
}

- (void)showImage:(UIImage *)image imageURL:(NSString *)imageURL fromView:(UIView *)view {

	[self showImages:[NSArray arrayWithObject:image] imageURLs:[NSArray arrayWithObject:imageURL] fromView:view index:0];
}

- (void)pressed:(id)sender {
	
	UIView *sourceView = nil;
	
    
    
	if ([self.delegate respondsToSelector:@selector(sourceView)]) {
		sourceView = [self.delegate sourceView];
	} else if ([self.delegate respondsToSelector:@selector(sourceViews)]) {
		if (self.pageControl.currentPage < [self.delegate sourceViews].count) {
			sourceView = (UIView *)[self.delegate sourceViews][self.pageControl.currentPage];
		}
	}
	
	self.imageView.hidden = NO;
	[self.scrollView removeFromSuperview];
	[self.pageControl removeFromSuperview];
	self.imageView.contentMode = UIViewContentModeScaleAspectFill;
	
	CGFloat duration = 0.3;
	CGFloat startRadius = sourceView.layer.cornerRadius;
	CGFloat endRadius = 0;
	
	UIView *rootView = [self properWindow];
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
	
	if (presser.state == UIGestureRecognizerStateBegan && [self.delegate respondsToSelector:@selector(fullSizeImagesControlDidLongPress:)]) {
		[self.delegate fullSizeImagesControlDidLongPress:self.pageControl.currentPage];
	}
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gesture {
	
	float newScale;
	UIScrollView *scrollView = (UIScrollView *)gesture.view;
	
	if (scrollView.zoomScale == 1.0) {
		newScale = scrollView.maximumZoomScale;
	} else {
		newScale = 1.0 / scrollView.maximumZoomScale;
	}
	
	CGRect zoomRect = [self zoomRectForScale:newScale withCenter: [gesture locationInView:(UIScrollView *)gesture.view]];
	[(UIScrollView *)gesture.view zoomToRect:zoomRect animated:YES];
}

- (void)handleSingleTap:(UIGestureRecognizer *)gesture {
	
	UIScrollView *scrollView = (UIScrollView *)gesture.view;
	
	if (scrollView.zoomScale != 1.0) {
		self.imageView.frame = CGRectMake(-scrollView.contentOffset.x, -scrollView.contentOffset.y, scrollView.contentSize.width, scrollView.contentSize.height);
	}
	
	self.imageView.hidden = NO;
	[self.scrollView removeFromSuperview];
	[self.pageControl removeFromSuperview];
	[self pressed:self];
}

#pragma mark - private

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
	
	CGRect zoomRect;
	zoomRect.size.height = self.frame.size.height / scale;
	zoomRect.size.width  = self.frame.size.width  / scale;
	zoomRect.origin.x = center.x - zoomRect.size.width / 2.0;
	zoomRect.origin.y = center.y - zoomRect.size.height / 2.0;
	return zoomRect;
}

- (UIWindow *)properWindow {
	
	UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
	
	BOOL isWrongWindow = [window isKindOfClass:NSClassFromString(@"_UIAlertOverlayWindow")];
	isWrongWindow = isWrongWindow || [window isKindOfClass:NSClassFromString(@"DGStatusBarAlertWindow")];
	
	//add message to the most front window, except the alertview windows / actionsheet
	if (isWrongWindow && [UIApplication sharedApplication].windows.count) {
		NSInteger index = [[UIApplication sharedApplication].windows indexOfObject:window];
		window = [UIApplication sharedApplication].windows[--index];
	}
	
	return window;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	
	[_pageControl setCurrentPage:_scrollView.contentOffset.x / _scrollView.frame.size.width];
	
	if (self.currentPage == self.pageControl.currentPage) {
		return;
	}
	
	if (self.scrollView == scrollView) {
		
		for (UIScrollView *imagescrollView in self.scrollViews) {
			
			if ([imagescrollView isKindOfClass:[UIScrollView class]]) {
				
				imagescrollView.zoomScale = 1.0;
			}
		}
		self.currentPage = self.pageControl.currentPage;
	}
	
	if (self.pageControl.currentPage >= _imageViews.count) {
		return;
	}
	
	UIImageView *imageView = _imageViews[self.pageControl.currentPage];
	
	if (!imageView.image) {
        
        [imageView sd_setImageWithURL:self.imageURLs[self.pageControl.currentPage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
	}
	
	self.imageView.image = imageView.image;
	self.imageView.frame = imageView.frame;
}

#pragma mark - UIScrollViewZoom

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	if (scrollView != self.scrollView) {
		if (self.imageViews.count == self.scrollViews.count) {
			UIImageView *imageView = [self.imageViews objectAtIndex:[self.scrollViews indexOfObject:scrollView]];
			return imageView;
		}
	}
	return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
	
	CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
	(scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
	CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
	(scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
	
	UIImageView *imageView = [self.imageViews objectAtIndex:[self.scrollViews indexOfObject:scrollView]];
	imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

@end
