//
//  TodayTalkStatusLayout.h
//  DuiHao
//
//  Created by wjn on 2017/2/21.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "OptionStatusLayout.h"
#import "HistoryTalkModel.h"

@interface TodayTalkStatusLayout : OptionStatusLayout

// 以下是数据
@property (nonatomic, strong) HistoryTalkModel *model;

- (instancetype)initWithStatus:(HistoryTalkModel *)status;

@end
