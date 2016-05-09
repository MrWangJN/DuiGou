//
//  RoundImageView.m
//  SAFramework
//
//  Created by wjn on 15/8/26.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "RoundImageView.h"

@implementation RoundImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setImageWithURL:(NSString *)URL {
        
    [self sd_setImageWithURL:[NSURL URLWithString:URL] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    [self.layer setCornerRadius:CGRectGetHeight([self bounds]) / 2];
    self.layer.masksToBounds = YES;
//    然后再给图层添加一个有色的边框
    self.layer.borderWidth = 2;
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
//    self.layer.contents = (id)[[UIImage imageNamed:@"Line"] CGImage];
}

- (void)setImageWithURL:(NSString *)URL withborderWidth:(NSInteger )size{
    
    [self sd_setImageWithURL:[NSURL URLWithString:URL] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    [self.layer setCornerRadius:CGRectGetHeight([self bounds]) / 2];
    self.layer.masksToBounds = YES;
    //    然后再给图层添加一个有2的边框
    self.layer.borderWidth = size;
    self.layer.borderColor = [[UIColor colorWithRed:75/255.0 green:177/255.0 blue:237/255.0 alpha:1] CGColor];
    //    self.layer.contents = (id)[[UIImage imageNamed:@"Line"] CGImage];
}

- (void)setImageWithURL:(NSString *)URL withborderWidth:(NSInteger )size withColor:(UIColor *)color{
    
    [self sd_setImageWithURL:[NSURL URLWithString:URL] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    [self.layer setCornerRadius:CGRectGetHeight([self bounds]) / 2];
    self.layer.masksToBounds = YES;
    //    然后再给图层添加一个有色的边框
    self.layer.borderWidth = size;
    self.layer.borderColor = [color CGColor];
    //    self.layer.contents = (id)[[UIImage imageNamed:@"Line"] CGImage];
}

@end
