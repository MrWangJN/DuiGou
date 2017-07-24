//
//  WeekView.m
//  CourseList
//
//  Created by wjn on 2017/4/18.
//  Copyright © 2017年 Ningmengkeji. All rights reserved.
//

#import "WeekView.h"
#import "SEFilterControl.h"
@interface WeekView() {
    UIButton *touchBtu;
    UIButton *backBtu;
}

@end

@implementation WeekView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)showWeekView {
    return [[WeekView alloc]initWithFrame:CGRectMake(0, 0, 280, 340)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initview];
    }
    return self;
}

- (void)show {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    backBtu = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtu.frame = keyWindow.bounds;
    backBtu.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [backBtu addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    [keyWindow addSubview:backBtu];
    [keyWindow addSubview:self];
    
    self.center = keyWindow.center;
}

- (void)dismiss {
    [self removeFromSuperview];
    [backBtu removeFromSuperview];
}

- (void)initview {
    
    CGFloat w = self.bounds.size.width / 5 - 10;
    
    for (int i = 1; i < 6; i++) {
        for (int j = 1; j < 6; j++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((j - 1) * (w + 5) + 15, (i - 1) * (w / 3 * 2 + 5) + 15, w, w / 3 * 2);
            button.layer.cornerRadius = 3;
            [button setBackgroundColor:GRAYISH];
            [button addTarget:self action:@selector(sender:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:[NSString stringWithFormat:@"%d", (i - 1) * 5 + j] forState:UIControlStateNormal];
            button.userInteractionEnabled = NO;
            button.tag = (i - 1) * 5 + j;
            [self addSubview:button];
        }
    }
    
//    UIButton *singularWeekBtu = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIButton *evenWeekBtu = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIButton *allrWeekBtu = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    singularWeekBtu.frame = CGRectMake(20, self.frame.size.height - 20, self.bounds.size.width / 3, 20);
//    evenWeekBtu.frame = CGRectMake(singularWeekBtu.frame.size.width, self.frame.size.height - 20, self.bounds.size.width / 3, 20);
//    allrWeekBtu.frame = CGRectMake(self.frame.size.width - singularWeekBtu.frame.size.width, self.frame.size.height - 20, self.bounds.size.width / 3, 20);
//    
//    [singularWeekBtu setTitle:@"单周" forState:UIControlStateNormal];
//    [evenWeekBtu setTitle:@"双周" forState:UIControlStateNormal];
//    [allrWeekBtu setTitle:@"全选" forState:UIControlStateNormal];
//    
//    [singularWeekBtu setBackgroundColor:[UIColor redColor]];
//    [evenWeekBtu setBackgroundColor:[UIColor greenColor]];
//    [allrWeekBtu setBackgroundColor:[UIColor purpleColor]];
//    
//    singularWeekBtu.tag = 10001;
//    evenWeekBtu.tag = 10002;
//    allrWeekBtu.tag = 10003;
//    
//    [singularWeekBtu addTarget:self action:@selector(weekAction:) forControlEvents:UIControlEventTouchUpInside];
//    [evenWeekBtu addTarget:self action:@selector(weekAction:) forControlEvents:UIControlEventTouchUpInside];
//    [allrWeekBtu addTarget:self action:@selector(weekAction:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self addSubview:singularWeekBtu];
//    [self addSubview:evenWeekBtu];
//    [self addSubview:allrWeekBtu];
    SEFilterControl *filter = [[SEFilterControl alloc]initWithFrame:CGRectMake(10, self.frame.size.height - 140, self.frame.size.width - 20, 40) Titles:[NSArray arrayWithObjects:@"自定义", @"单周", @"双周", @"全选", nil]];
    filter.tag = 100001;
    [filter addTarget:self action:@selector(filterValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    [filter setProgressColor:[UIColor groupTableViewBackgroundColor]];//设置滑杆的颜色
    [filter setTopTitlesColor:MAINCOLOR];//设置滑块上方字体颜色
    [filter setSelectedIndex:0];//设置当前选中
    [self addSubview:filter];
    
    UIButton *applyBtu = [UIButton buttonWithType:UIButtonTypeCustom];
    applyBtu.frame = CGRectMake(10, self.frame.size.height - 50, self.bounds.size.width - 20, 40);
    [applyBtu setTitle:@"确定" forState:UIControlStateNormal];
    [applyBtu addTarget:self action:@selector(weekAction:) forControlEvents:UIControlEventTouchUpInside];
    applyBtu.tag = 100002;
    applyBtu.backgroundColor = MAINCOLOR;
    applyBtu.layer.cornerRadius = 4;
    
    [self addSubview:applyBtu];
}

#pragma mark -- 点击底部按钮响应事件
-(void)filterValueChanged:(SEFilterControl *)sender
{
    switch (sender.SelectedIndex) {
        case 0:{
            for (UIButton *btu in self.subviews) {
                
                if (btu.tag > 10000) {
                    continue;
                }
                
//                [btu setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                [btu setBackgroundColor:GRAYISH];
            }
            break;
        }

        case 1:{
            
            for (UIButton *btu in self.subviews) {
                
                if (btu.tag > 10000) {
                    continue;
                }
                
                if (btu.tag % 2 == 1) {
//                    [btu setBackgroundImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
                    [btu setBackgroundColor:MAINCOLOR];
                } else {
//                    [btu setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                    [btu setBackgroundColor:GRAYISH];
                }
            }
            break;
        }
        case 2:{
            for (UIButton *btu in self.subviews) {
                
                if (btu.tag > 10000) {
                    continue;
                }
                
                if (btu.tag % 2 == 0) {
//                    [btu setBackgroundImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
                    [btu setBackgroundColor:MAINCOLOR];
                } else {
//                    [btu setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                    [btu setBackgroundColor:GRAYISH];
                }
            }
            break;
        }
        case 3:{
            for (UIButton *btu in self.subviews) {
                
                if (btu.tag > 10000) {
                    continue;
                }
                
//                [btu setBackgroundImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
                [btu setBackgroundColor:MAINCOLOR];
            }
            break;
        }
        default:
            break;

    }
}

- (void)weekAction:(UIButton *)sender {
    
    NSString *weeks = [NSString string];
    
    NSInteger i = 0;
    
    for (UIButton *btu in self.subviews) {
        
        if (btu.tag > 10000) {
            continue;
        }
        
//        if ([btu.currentBackgroundImage isEqual:[UIImage  imageNamed:@"select.png"]]) {
//        
//            weeks = [weeks stringByAppendingString:[NSString stringWithFormat:@"-%ld", (long)btu.tag]];
//        }
        
        
        
        if (CGColorEqualToColor(btu.backgroundColor.CGColor, MAINCOLOR.CGColor)) {
            weeks = [weeks stringByAppendingString:[NSString stringWithFormat:@"-%ld", (long)btu.tag]];
        }
    }
    
    
    if ([self.delegate respondsToSelector:@selector(choseFinish:)] && weeks.length) {
         weeks = [weeks substringFromIndex:1];
        [self.delegate choseFinish:weeks];
    }
    
    [self dismiss];
}

- (void)sender:(UIButton *)button {
    
    if (CGColorEqualToColor(button.backgroundColor.CGColor, MAINCOLOR.CGColor)) {
//        [button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [button setBackgroundColor:GRAYISH];
    } else {
//        [button setBackgroundImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
        [button setBackgroundColor:MAINCOLOR];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];//保存所有触摸事件
    if (touch) {
        for (UIButton *btn in self.subviews) {
                    CGPoint po = [touch locationInView:btn];//记录按键坐标
                    if ([btn pointInside:po withEvent:nil]) {//判断按键坐标是否在手势开始范围内,是则为选中的
                        [self sender:btn];
                        touchBtu = btn;
                    }
            }
        }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];//保存所有触摸事件
    if (touch) {
        for (UIButton *btn in self.subviews) {
            CGPoint po = [touch locationInView:btn];//记录按键坐标
            if ([btn pointInside:po withEvent:nil]) {//判断按键坐标是否在手势开始范围内,是则为选中的开始按键
    
                if (touchBtu != btn) {
                    [self sender:btn];
                }
                touchBtu = btn;
            }
        }
    }
}

@end
