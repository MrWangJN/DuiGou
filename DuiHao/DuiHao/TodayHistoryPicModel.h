//
//  TodayHistoryPicModel.h
//  DuiHao
//
//  Created by wjn on 2016/12/30.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodayHistoryPicModel : NSObject

@property (copy, nonatomic) NSString *pic_title;
@property (copy, nonatomic) NSString *url;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
