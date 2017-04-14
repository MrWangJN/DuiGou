//
//  ExamAndJobStatusLayout.h
//  DuiHao
//
//  Created by wjn on 2017/3/16.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "OptionStatusLayout.h"
#import "ExamJobListModel.h"

@interface ExamAndJobStatusLayout : OptionStatusLayout

// 以下是数据
@property (nonatomic, strong) ExamJobListModel *model;
//
- (instancetype)initWithStatus:(ExamJobListModel *)status;

@end
