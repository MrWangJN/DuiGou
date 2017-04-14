//
//  PPTModel.h
//  DuiHao
//
//  Created by wjn on 2017/3/14.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPTModel : NSObject

@property (strong, nonatomic) NSString *theme;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *downloadurl;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
