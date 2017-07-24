//
//  VideoModel.h
//  DuiHao
//
//  Created by wjn on 2017/7/18.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject<NSCoding>

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *video_count;
@property (copy, nonatomic) NSString *teacher_count;

@property (strong, nonatomic) NSArray *children;

- (id)initWithDictionary:(NSDictionary *)dic children:(NSArray *)array;

@end
