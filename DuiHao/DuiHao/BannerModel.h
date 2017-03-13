//
//  BannerModel.h
//  DuiHao
//
//  Created by wjn on 2017/2/20.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerModel : NSObject

@property (copy, nonatomic) NSString *content;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
