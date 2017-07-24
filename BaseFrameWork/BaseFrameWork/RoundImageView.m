//
//  RoundImageView.m
//  SAFramework
//
//  Created by wjn on 15/8/26.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "RoundImageView.h"
#import "UIImageView+WebCache.h"

@implementation RoundImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setImageWithURL:(NSString *)URL {
    
    // 然后再给图层添加一个有色的边框
    self.layer.borderWidth = 2;
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    //
    [self.layer setCornerRadius:CGRectGetWidth([self bounds]) / 2];
    self.layer.masksToBounds = YES;
//    
//    self.layer.contents = (id)[[UIImage imageNamed:@"Line"] CGImage];
    
    [self sd_setImageWithURL:[NSURL URLWithString:URL] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    
}

- (void)setImageWithURL:(NSString *)URL withWidth:(CGFloat )width {
    
    [self.layer setCornerRadius:width / 2];
    self.layer.masksToBounds = YES;
    //    然后再给图层添加一个有色的边框
    self.layer.borderWidth = 2;
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    //    self.layer.contents = (id)[[UIImage imageNamed:@"Line"] CGImage];
    
    [self sd_setImageWithURL:[NSURL URLWithString:URL] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
}

- (void)setImageWithURL:(NSString *)URL withborderWidth:(NSInteger )size{
    
    [self.layer setCornerRadius:CGRectGetHeight([self bounds]) / 2];
    self.layer.masksToBounds = YES;
    //    然后再给图层添加一个有2的边框
    self.layer.borderWidth = size;
    self.layer.borderColor = [[UIColor colorWithRed:75/255.0 green:177/255.0 blue:237/255.0 alpha:1] CGColor];
    //    self.layer.contents = (id)[[UIImage imageNamed:@"Line"] CGImage];
    
    [self sd_setImageWithURL:[NSURL URLWithString:URL] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
}

- (void)setImageWithURL:(NSString *)URL withborderWidth:(NSInteger )size withColor:(UIColor *)color{
    
        [self.layer setCornerRadius:CGRectGetHeight([self bounds]) / 2];
    self.layer.masksToBounds = YES;
    //    然后再给图层添加一个有色的边框
    self.layer.borderWidth = size;
    self.layer.borderColor = [color CGColor];
    //    self.layer.contents = (id)[[UIImage imageNamed:@"Line"] CGImage];
    
    [self sd_setImageWithURL:[NSURL URLWithString:URL] placeholderImage:[UIImage imageNamed:@"Placeholder"]];

}

- (void)setImageWithname:(NSString *)name withborderWidth:(NSInteger )size withColor:(UIColor *)color {
    [self.layer setCornerRadius:CGRectGetHeight([self bounds]) / 2];
    self.layer.masksToBounds = YES;
    //    然后再给图层添加一个有色的边框
    self.layer.borderWidth = size;
    self.layer.borderColor = [color CGColor];
    //    self.layer.contents = (id)[[UIImage imageNamed:@"Line"] CGImage];
    
    [self setImage:[UIImage imageNamed:name]];
}

@end
