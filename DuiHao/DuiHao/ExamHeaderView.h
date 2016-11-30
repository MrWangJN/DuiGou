//
//  ExamHeaderView.h
//  StudyAssisTant
//
//  Created by wjn on 15/10/4.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExamHeaderViewDelegate;

@interface ExamHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) dispatch_source_t timer;

@property (assign, nonatomic) id<ExamHeaderViewDelegate>delegate;

- (void)setText:(NSInteger)number withCount:(NSInteger)count;
- (void)start:(int)examTime;

@end

@protocol ExamHeaderViewDelegate <NSObject>

- (void)submitCanUp;
- (void)updata;

@end
