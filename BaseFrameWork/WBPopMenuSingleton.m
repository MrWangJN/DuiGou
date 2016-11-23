//
//  WBPopMenuSingleton.m
//  QQ_PopMenu_Demo
//
//  Created by Transuner on 16/3/17.
//  Copyright © 2016年 吴冰. All rights reserved.
//

#import "WBPopMenuSingleton.h"
#import "WBPopMenuView.h"

@interface WBPopMenuSingleton ()
@property (nonatomic, strong) WBPopMenuView * popMenuView;
@property (nonatomic, strong) UIButton *button;
@end

@implementation WBPopMenuSingleton

+ (WBPopMenuSingleton *) shareManager {
    static WBPopMenuSingleton *_PopMenuSingleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _PopMenuSingleton = [[WBPopMenuSingleton alloc]init];
    });
    return _PopMenuSingleton;
}

- (void) showPopMenuSelecteWithFrame:(CGFloat)width
                                item:(NSArray *)item
                              action:(void (^)(NSInteger))action withDelegate:(id<WBPopMenuSingletonDelegate>)delegate{
    __weak __typeof(&*self)weakSelf = self;
    if (self.popMenuView != nil) {
        [weakSelf hideMenu];
    }
//    UIWindow * window = [[[UIApplication sharedApplication] windows] firstObject];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    self.popMenuView = [[WBPopMenuView alloc]initWithFrame:window.bounds
                                             menuWidth:width
                                                 items:item
                                                action:^(NSInteger index) {
                                                    action(index);
                                                    [weakSelf hideMenu];
                                                }];
    self.popMenuView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    self.popMenuView.alpha = 0.0;
    [window addSubview:self.popMenuView];
    

    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width -  100) / 2, [UIScreen mainScreen].bounds.size.height - 100, 100, 40);
    [_button setTitle:@"刷新" forState:UIControlStateNormal];
    [_button setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    _button.layer.borderColor = MAINCOLOR.CGColor;
    _button.layer.cornerRadius = 2;
    _button.layer.borderWidth = 1;
    
    [_button addTarget:self action:@selector(buttonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
     [window addSubview:_button];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.popMenuView.tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.popMenuView.alpha = 1.0;
         self.button.alpha = 1.0;
    }];
    
    self.delegate = delegate;
}

- (void) buttonDidPress:(id)sender {
    self.popMenuView.action(10000);
}

- (void) hideMenu {
    [UIView animateWithDuration:0.15 animations:^{
        self.popMenuView.tableView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
        self.popMenuView.alpha = 0.0;
        self.button.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.popMenuView.tableView removeFromSuperview];
        [self.popMenuView removeFromSuperview];
        [self.button removeFromSuperview];
        self.popMenuView.tableView = nil;
        self.popMenuView = nil;
        self.button = nil;
        
        if ([self.delegate respondsToSelector:@selector(dismiss)]) {
            [self.delegate dismiss];
        }
    }];
}



@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
