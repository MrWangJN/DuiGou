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
    
    self.backgroundColor = self.colorArray[arc4random()%10];
    [self.layer setCornerRadius:CGRectGetHeight([self bounds]) / 2];
    self.layer.masksToBounds = YES;
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = [[UIColor colorWithRed:75/255.0 green:177/255.0 blue:237/255.0 alpha:1] CGColor];
}

- (void)setNewText:(NSString *)text {
    
    [super setText:text];
    [self.layer setCornerRadius:CGRectGetHeight([self bounds]) / 2];
    self.layer.masksToBounds = YES;
}

@end
