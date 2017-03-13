//
//  HistoryTalkModel.h
//  DuiHao
//
//  Created by wjn on 2017/2/21.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryTalkModel : NSObject

@property (copy, nonatomic) NSString *auther;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *created_at;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) NSString *month;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
