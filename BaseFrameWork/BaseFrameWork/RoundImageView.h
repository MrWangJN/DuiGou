//
//  RoundImageView.h
//  SAFramework
//
//  Created by wjn on 15/8/26.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RoundImageView : UIImageView

/**
 *  必须保证是正方形
 */
- (void)setImageWithURL:(NSString *)URL;
- (void)setImageWithURL:(NSString *)URL withWidth:(CGFloat )width;
- (void)setImageWithURL:(NSString *)URL withborderWidth:(NSInteger )size;
- (void)setImageWithURL:(NSString *)URL withborderWidth:(NSInteger )size withColor:(UIColor *)color;
- (void)setImageWithname:(NSString *)name withborderWidth:(NSInteger )size withColor:(UIColor *)color;

@end
