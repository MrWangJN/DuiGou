//
//  TodayHistoryTableViewCell.h
//  DuiHao
//
//  Created by wjn on 2016/12/29.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodayHistoryLayout.h"

@protocol TodayHistoryTableViewCellDelegate <NSObject>

- (void)didClickTodayHistory:(TodayHistoryModel *)todayHistory;

@end

@interface TodayHistoryTableViewCell : UITableViewCell

@property (strong, nonatomic) TodayHistoryLayout *todayHistoryLayout;
@property (assign, nonatomic) id<TodayHistoryTableViewCellDelegate>delegate;

@end
