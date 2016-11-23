//
//  FirstPromptView.m
//  DuiHao
//
//  Created by wjn on 2016/11/15.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "FirstPromptView.h"

@interface FirstPromptView()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *button;

@end

@implementation FirstPromptView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (FirstPromptView *) shareManager {
    static FirstPromptView *_firstPromptView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _firstPromptView = [[FirstPromptView alloc]init];
    });
    return _firstPromptView;
}

- (void)showWithImageName:(NSString *)imageName {
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    _imageView.frame = window.bounds;
    _imageView.contentMode = UIViewContentModeScaleToFill;
    [window addSubview:_imageView];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = _imageView.bounds;
    _button.backgroundColor = [UIColor clearColor];
    
    [_button addTarget:self action:@selector(dismissBtuAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [window addSubview:_button];
}

- (void)disMiss {
    
    [self.imageView removeFromSuperview];
    [self.button removeFromSuperview];
    
    self.imageView = nil;
    self.button = nil;
}

- (void)dismissBtuAction:(id)sender {
    [self disMiss];
}

@end
