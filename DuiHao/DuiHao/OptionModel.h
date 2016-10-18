//
//  OptionModel.h
//  DuiHao
//
//  Created by wjn on 16/7/27.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OptionModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *option;
@property (nonatomic, copy) NSString *optionImage;

- (instancetype)initWithrawDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)getDistionary;

@end
