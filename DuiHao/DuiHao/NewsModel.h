//
//  NewsModel.h
//  StudyAssisTant
//
//  Created by wjn on 15/9/8.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject

@property (nonatomic, strong) NSString *realname;
@property (nonatomic, strong) NSString *beginDateTime;
@property (nonatomic, strong) NSString *endDateTime;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *courseName;

@end
