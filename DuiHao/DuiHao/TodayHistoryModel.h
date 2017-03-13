//
//  TodayHistoryModel.h
//  DuiHao
//
//  Created by wjn on 2016/12/29.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodayHistoryModel : NSObject

@property (copy, nonatomic) NSString *e_id;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *day;
@property (copy, nonatomic) NSString *date;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
