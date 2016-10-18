//
//  TitleMenuButton.h
//  DuiHao
//
//  Created by wjn on 16/10/17.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleMenuButton : UIControl

@property (nonatomic, unsafe_unretained) BOOL isActive;
@property (nonatomic) CGGradientRef spotlightGradientRef;
@property (unsafe_unretained) CGFloat spotlightStartRadius;
@property (unsafe_unretained) float spotlightEndRadius;
@property (unsafe_unretained) CGPoint spotlightCenter;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *arrow;

- (UIImageView *)defaultGradient;


@end
