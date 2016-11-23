//
//  SliderView.m
//  StudyAssisTant
//
//  Created by wjn on 15/10/6.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SliderView.h"

#define MAX_BUTTON self.width / 6
#define HEIGHT_BUTTON self.width / 9

@implementation SliderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.select = 0;
}

- (void)setArray:(NSArray *)array {
    _array = array;
    [self creatButton];
}

- (void)creatButton {
    for (int i = 0; i < self.array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.array[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [button setTag:i];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(MAX_BUTTON * i, 0, MAX_BUTTON, HEIGHT_BUTTON)];
        [button addTarget:self action:@selector(buttonDidPress:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(MAX_BUTTON, 10, 1, HEIGHT_BUTTON - 20)];
        view.backgroundColor = [UIColor lightGrayColor];
        [button addSubview:view];
        
        [self.scrollView addSubview:button];
        [self.buttonArray addObject:button];
    }
    [self.scrollView setContentSize:CGSizeMake(MAX_BUTTON * self.array.count, 0)];
    [self selectIndex:0];
}

- (void)buttonDidPress:(UIButton *)sender {
    [self selectIndex:sender.tag];
    if ([self.delegate respondsToSelector:@selector(buttonDidPressWithIndex:)]) {
        [self.delegate buttonDidPressWithIndex:sender.tag];
    }
}

- (void)selectIndex:(NSInteger ) index {
    if (!self.buttonArray.count) {
        return;
    }
    UIButton *button = (UIButton *)self.buttonArray[self.select];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button = (UIButton *)self.buttonArray[index];
    [button setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    self.select = index;
//    [self.scrollView setContentOffset:CGPointMake((index - 2) * (MAX_BUTTON + 5), 0) animated:YES];
}

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        self.buttonArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _buttonArray;
}

@end
