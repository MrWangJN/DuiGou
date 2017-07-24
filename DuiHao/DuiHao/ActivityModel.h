//
//  ActivityModel.h
//  DuiHao
//
//  Created by wjn on 2017/7/20.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAModel.h"

@interface ActivityModel : SAModel

@property (strong, nonatomic) NSNumber *activity_id;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *start_time;
@property (copy, nonatomic) NSString *end_time;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *pic;
@property (copy, nonatomic) NSString *applied_count;
@property (copy, nonatomic) NSString *people_count;
@property (copy, nonatomic) NSNumber *state;
@property (strong, nonatomic) NSNumber *is_close;

@end
