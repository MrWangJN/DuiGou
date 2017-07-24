//
//  UIViewController+LewPopupViewController.h
//  LewPopupViewController
//
//  Created by pljhonglu on 15/3/4.
//  Copyright (c) 2015年 pljhonglu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LewPopupAnimation <NSObject>
@required
- (void)showView:(UIView*)popupView overlayView:(UIView*)overlayView;
- (void)dismissView:(UIView*)popupView overlayView:(UIView*)overlayView completion:(void (^)(void))completion;

@end

@interface UIViewController (LewPopupViewController)
@property (nonatomic, retain, readonly) UIView *lewPopupView;
@property (nonatomic, retain, readonly) UIView *lewOverlayView;
@property (nonatomic, retain, readonly) id<LewPopupAnimation> lewPopupAnimation;

- (void)lew_presentPopupView:(UIView *)popupView animation:(id<LewPopupAnimation>)animation;
- (void)lew_presentPopupView:(UIView *)popupView animation:(id<LewPopupAnimation>)animation dismissed:(void(^)(void))dismissed;

- (void)lew_dismissPopupView;
- (void)lew_dismissPopupViewWithanimation:(id<LewPopupAnimation>)animation;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com