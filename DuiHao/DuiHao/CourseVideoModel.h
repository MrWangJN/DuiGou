//
//  CourseVideoModel.h
//  DuiHao
//
//  Created by wjn on 2017/4/1.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "SAModel.h"

@interface CourseVideoModel : SAModel

@property (copy, nonatomic) NSString *downloadurl;
@property (copy, nonatomic) NSString *subject;
@property (copy, nonatomic) NSString *title;

@end
