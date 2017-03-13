//
//  RoundLabel.m
//  SAFramework
//
//  Created by wjn on 15/9/8.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "RoundLabel.h"
#import "ColorManager.h"
@implementation RoundLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSArray *)colorArray {
    if (!_colorArray) {
        self.colorArray = @[BEWItCHEDTREECOLOR, MYSTICALGREEN, LIGHTHEARTBLUECOLOR, CLASSGALLCOLOR, SILLYFIZZCOLOR, BRAINSANDCOLOR, MUSTRDADDICTEDCOLOR, MAGICPOWDERCOLOR, TRUEBLUSHCOLOR, MERRYCRANESBILLCOLOR];
    }
    return _colorArray;
}

- (void)setText:(NSString *)text {
    
    [super setText:[[text substringToIndex:1] uppercaseString]];
    self.textAlignment = NSTextAlignmentCenter;
//    self.backgroundColor = self.colorArray[arc4random()%10];
    self.backgroundColor = [UIColor colorWithRed:arc4random()%254 / 255.0 green:arc4random()%254 / 255.0 blue:arc4random()%254 / 255.0 alpha:1];
    [self.layer setCornerRadius:CGRectGetHeight([self bounds]) / 2];
    self.layer.masksToBounds = YES;
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = [[UIColor colorWithRed:75/255.0 green:177/255.0 blue:237/255.0 alpha:1] CGColor];
}

- (void)setText:(NSString *)text withColor:(UIColor *)color {
    
    [super setText:[[text substringToIndex:1] uppercaseString]];
    self.textAlignment = NSTextAlignmentCenter;
    //    self.backgroundColor = self.colorArray[arc4random()%10];
    self.backgroundColor = [UIColor clearColor];
    self.textColor = color;
//    [self.layer setCornerRadius:CGRectGetHeight([self bounds]) / 2];
//    self.layer.masksToBounds = YES;
    //    self.layer.borderWidth = 1;
    //    self.layer.borderColor = [[UIColor colorWithRed:75/255.0 green:177/255.0 blue:237/255.0 alpha:1] CGColor];
}

- (void)setNewsText:(NSString *)text {
    [super setText:[[text substringToIndex:1] uppercaseString]];
    self.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = [UIColor redColor];
    [self.layer setCornerRadius:CGRectGetHeight([self bounds]) / 2];
    self.layer.masksToBounds = YES;
}

- (void)setNewText:(NSString *)text {
    
    [super setText:text];
    self.textAlignment = NSTextAlignmentCenter;
    [self.layer setCornerRadius:CGRectGetHeight([self bounds]) / 2];
    self.layer.masksToBounds = YES;
}

- (void)setSelectText:(NSString *)text {
    [super setText:text];
    self.backgroundColor = [UIColor whiteColor];
    self.textColor = MAINCOLOR;
    [self.layer setCornerRadius:CGRectGetHeight([self bounds]) / 2];
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [MAINCOLOR CGColor];
}

- (void)select {
    self.backgroundColor = MAINCOLOR;
    self.textColor = [UIColor whiteColor];
}

- (void)unSelect {
    self.backgroundColor = [UIColor whiteColor];
    self.textColor = MAINCOLOR;
}

@end
