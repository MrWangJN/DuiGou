//
//  RoundLabel.h
//  SAFramework
//
//  Created by wjn on 15/9/8.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundLabel : UILabel

@property (strong, nonatomic)NSArray *colorArray;

- (void)setNewText:(NSString *)text;
- (void)setNewsText:(NSString *)text;
- (void)setSelectText:(NSString *)text;
- (void)select;
- (void)unSelect;
@end
