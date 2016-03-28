//
//  SAModel.h
//  SAFramework
//
//  Created by 王建男 on 15/3/7.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAModel : NSObject

- (instancetype)initWithRawModel:(NSDictionary *)rawModel;

- (void)updateWithRawModel:(NSDictionary *)rawModel;

@end
