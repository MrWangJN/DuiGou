//
//  ExamListModel.h
//  DuiHao
//
//  Created by wjn on 2017/3/21.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "SAModel.h"

@interface ExamJobListModel : SAModel

@property (copy, nonatomic) NSString *real_name;
@property (copy, nonatomic) NSString *created_at;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *course;
@property (copy, nonatomic) NSString *teachingId;
@property (copy, nonatomic) NSString *modelId;
@property (copy, nonatomic) NSString *courseId;
@property (copy, nonatomic) NSString *teacherId;
@property (copy, nonatomic) NSString *duration;
@property (copy, nonatomic) NSNumber *isOpen;
@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *close_time;

@end
