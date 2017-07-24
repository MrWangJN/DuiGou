//
//  WeekView.h
//  CourseList
//
//  Created by wjn on 2017/4/18.
//  Copyright © 2017年 Ningmengkeji. All rights reserved.
//

#import "SAKit.h"

@protocol WeekViewDelegate <NSObject>

- (void)choseFinish:(NSString *)weeks;

@end

@interface WeekView : UIView

@property (assign, nonatomic)id <WeekViewDelegate> delegate;

+ (instancetype)showWeekView;
- (void)show;
- (void)dismiss;

@end
