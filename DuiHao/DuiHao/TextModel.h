//
//  JudgeMentModel.h
//  StudyAssisTant
//
//  Created by 王建男 on 15/4/7.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextModel : NSObject

@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSString *answer;
@property (nonatomic, strong) NSString *data_time;
@property (nonatomic, strong) NSString *my_Answer;

- (instancetype)initWithrawDictionary:(NSDictionary *)rawDictionary;

@end
