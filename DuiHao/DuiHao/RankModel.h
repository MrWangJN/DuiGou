//
//  rankModel.h
//  StudyAssisTant
//
//  Created by wjn on 15/9/22.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RankModel : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *rankImageUrl;
@property (copy, nonatomic) NSString *accumulatePoints;
@property (copy, nonatomic) NSString *timeScore;
@property (copy, nonatomic) NSString *examImitateScore;
@property (copy, nonatomic) NSString *timesScore;
@property (copy, nonatomic) NSString *examScore;
@property (copy, nonatomic) NSString *absenteeismTimes;
@property (copy, nonatomic) NSString *absenteeismScore;
@property (copy, nonatomic) NSString *lateTimes;
@property (copy, nonatomic) NSString *lateScore;
@property (copy, nonatomic) NSString *classScore;
@property (strong, nonatomic) NSArray *topList;
@property (copy, nonatomic) NSString *flag;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface RankPersonalModel : NSObject

@property (copy, nonatomic) NSString *studentName;
@property (copy, nonatomic) NSString *studentId;
@property (copy, nonatomic) NSString *imageUrl;
@property (copy, nonatomic) NSString *rankImageUrl;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *accumulatePoints;
@property (copy, nonatomic) NSString *timeScore;
@property (copy, nonatomic) NSString *timesScore;
@property (copy, nonatomic) NSString *examScore;
@property (copy, nonatomic) NSString *sginScore;
@property (copy, nonatomic) NSString *classScore;
@property (copy, nonatomic) NSString *examImitateScore;
@property (copy, nonatomic) NSString *flag;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
