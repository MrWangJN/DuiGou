//
//  ChildVideoModel.h
//  DuiHao
//
//  Created by wjn on 2017/7/18.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChildVideoModel : NSObject

@property (strong, nonatomic) NSString *courseName;
@property (copy, nonatomic) NSString *teacherName;
@property (strong, nonatomic) NSNumber *teacher_id;
@property (strong, nonatomic) NSNumber *course_id;
@property (strong, nonatomic) NSString *video_num;
@property (strong, nonatomic) NSArray *children;

- (id)initWithDic:(NSDictionary *)dic children:(NSArray *)array;
+ (id)dataObjectWithDic:(NSDictionary *)dic children:(NSArray *)children;

- (void)addChild:(id)child;
- (void)removeChild:(id)child;

@end
