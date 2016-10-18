//
//  ItemModel.m
//  StudyAssisTant
//
//  Created by 王建男 on 15/3/10.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "ItemModel.h"

@implementation ItemModel

- (instancetype)initWithrawDictionary:(NSDictionary *)rawDictionary {
	self = [super init];
	if (self) {
        self.select = 0;
		[self setValuesForKeysWithDictionary:rawDictionary];
	}
	return self;
}

- (instancetype)initWithItemModel:(ItemModel *)itemModel {
    self = [super init];
    if (self) {
        if (itemModel.question.length) {
            self.question = [[NSString alloc] initWithString:itemModel.question];
        }
        
        if (itemModel.questionImageUrl.length) {
            self.questionImageUrl = [[NSString alloc] initWithString:itemModel.questionImageUrl];
        }
        
        if (itemModel.questionOrigin.length) {
            self.questionOrigin = [[NSString alloc] initWithString:itemModel.questionOrigin];
        }
        
        if (itemModel.answer.length) {
            
            NSString *string = [[NSString alloc] initWithString:itemModel.answer];
            NSRange range = [itemModel.answer rangeOfString:@"本题答案："];
            if (range.length) {
                
                self.answer = [string substringFromIndex:range.length];
                
            } else {
                
                self.answer = string;
            }
        }
        
        if (itemModel.answerAnalysis.length) {
            self.answerAnalysis = [[NSString alloc] initWithString:itemModel.answerAnalysis];
        }
        
        if (itemModel.answerAnalysisUrl.length) {
            self.answerAnalysisUrl = [[NSString alloc] initWithString:itemModel.answerAnalysisUrl];
        }
        
        if (itemModel.chapter.length) {
            self.chapter = [[NSString alloc] initWithString:itemModel.chapter];
        }
        
        if (itemModel.courseId.length) {
            self.courseId = [[NSString alloc] initWithString:itemModel.courseId];
        }
        
        if (itemModel.courseAlias.length) {
            self.courseAlias = [[NSString alloc] initWithString:itemModel.courseAlias];
        }
        if (itemModel.questionId.length) {
            self.questionId = [[NSString alloc] initWithString:itemModel.questionId];
        }
        if (itemModel.section.length) {
            self.section = [[NSString alloc] initWithString:itemModel.section];
        }
        if (itemModel.state.length) {
            self.state = [[NSString alloc] initWithString:itemModel.state];
        }
        if (itemModel.teacherAliasName.length) {
            self.teacherAliasName = [[NSString alloc] initWithString:itemModel.teacherAliasName];
        }
        if (itemModel.my_Answer.length) {
            self.my_Answer = [[NSString alloc] initWithString:itemModel.my_Answer];
        }
        
        if (itemModel.teacherId.length) {
            self.teacherId = [[NSString alloc] initWithString:itemModel.teacherId];
        }
        
        if (itemModel.answers.count) {
            self.answers = [[NSMutableArray alloc] initWithArray:itemModel.answers];
        }
        
        if (itemModel.optionArray.count) {
            self.optionArray = [NSArray arrayWithArray:itemModel.optionArray];
        }
        
        self.select = itemModel.select;
        self.type = itemModel.type;
    }
    return self;
}

//纠错方法

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
	if ([key isEqual:@"id"]) {
        self.questionId = value;
	}
    
    if ([key isEqual:@"optionList"]) {
        NSArray *array = value;
        NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dic in array) {
            OptionModel *optionModel = [[OptionModel alloc] initWithrawDictionary:dic];
            [mutableArr addObject:optionModel];
        }
        self.optionArray = [NSArray arrayWithArray:mutableArr];
    }
    
}

- (id)valueForUndefinedKey:(NSString *)key
{
	return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.question forKey:@"question"];
    [aCoder encodeObject:self.questionImageUrl forKey:@"questionImageUrl"];
    [aCoder encodeObject:self.questionOrigin forKey:@"questionOrigin"];
    [aCoder encodeObject:self.answer forKey:@"answer"];
    [aCoder encodeObject:self.answerAnalysis forKey:@"answerAnalysis"];
    [aCoder encodeObject:self.answerAnalysisUrl forKey:@"answerAnalysisUrl"];
    [aCoder encodeObject:self.courseId forKey:@"courseId"];
    [aCoder encodeObject:self.optionArray forKey:@"optionArray"];
    [aCoder encodeObject:self.chapter forKey:@"chapter"];
    [aCoder encodeObject:self.courseAlias forKey:@"courseAlias"];
    [aCoder encodeObject:self.questionId forKey:@"questionId"];
    [aCoder encodeObject:self.section forKey:@"section"];
    [aCoder encodeObject:self.state forKey:@"state"];
    [aCoder encodeObject:self.teacherAliasName forKey:@"teacherAliasName"];
    [aCoder encodeObject:self.teacherId forKey:@"teacherId"];
    [aCoder encodeObject:self.my_Answer forKey:@"my_Answer"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.select] forKey:@"select"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.type] forKey:@"type"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        self.question = [aDecoder decodeObjectForKey:@"question"];
        self.questionImageUrl = [aDecoder decodeObjectForKey:@"questionImageUrl"];
        self.questionOrigin = [aDecoder decodeObjectForKey:@"questionOrigin"];
        self.answer = [aDecoder decodeObjectForKey:@"answer"];
        self.answerAnalysis = [aDecoder decodeObjectForKey:@"answerAnalysis"];
        self.answerAnalysisUrl = [aDecoder decodeObjectForKey:@"answerAnalysisUrl"];
        self.courseId = [aDecoder decodeObjectForKey:@"courseId"];
        self.optionArray = [aDecoder decodeObjectForKey:@"optionArray"];
        self.chapter = [aDecoder decodeObjectForKey:@"chapter"];
        
        self.courseAlias = [aDecoder decodeObjectForKey:@"courseAlias"];
        self.questionId = [aDecoder decodeObjectForKey:@"questionId"];
        self.section = [aDecoder decodeObjectForKey:@"section"];
        self.state = [aDecoder decodeObjectForKey:@"state"];
        self.teacherAliasName = [aDecoder decodeObjectForKey:@"teacherAliasName"];
        self.teacherId = [aDecoder decodeObjectForKey:@"teacherId"];
        self.my_Answer = [aDecoder decodeObjectForKey:@"my_Answer"];
        NSNumber *number = [aDecoder decodeObjectForKey:@"select"];
        self.select = number.integerValue;
        number = [aDecoder decodeObjectForKey:@"type"];
        self.type = number.integerValue;
    }
    return self;
    
}

- (NSDictionary *)getDistionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if (self.question.length) {
        [dictionary setObject:self.question forKey:@"question"];
    }
    
    
    if (self.questionImageUrl.length) {
        [dictionary setObject:self.questionImageUrl forKey:@"questionImageUrl"];
    }
    
    if (self.questionOrigin.length) {
        [dictionary setObject:self.questionOrigin forKey:@"questionOrigin"];
    }
    
    if (self.answer.length) {
        [dictionary setObject:self.answer forKey:@"answer"];
    }
    
    if (self.answerAnalysis.length) {
        [dictionary setObject:self.answerAnalysis forKey:@"answerAnalysis"];
    }
    
    if (self.answerAnalysisUrl.length) {
        [dictionary setObject:self.answerAnalysisUrl forKey:@"answerAnalysisUrl"];
    }
    
    if (self.courseId.length) {
        [dictionary setObject:self.courseId forKey:@"courseId"];
    }
    
    if (self.optionArray
        .count) {
        NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:0];
        for (OptionModel *optionModel in self.optionArray) {
            [mutableArr addObject:[optionModel getDistionary]];
        }
        [dictionary setObject:mutableArr forKey:@"optionList"];
    }
    
    if (self.chapter.length) {
        [dictionary setObject:self.chapter forKey:@"chapter"];
    }
    if (self.courseAlias.length) {
        [dictionary setObject:self.courseAlias forKey:@"courseAlias"];
    }
    if (self.questionId.length) {
        [dictionary setObject:self.questionId forKey:@"questionId"];
    }
    if (self.section.length) {
        [dictionary setObject:self.section forKey:@"section"];
    }
    if (self.state.length) {
        [dictionary setObject:self.state forKey:@"state"];
    }
    if (self.teacherAliasName.length) {
        [dictionary setObject:self.teacherAliasName forKey:@"teacherAliasName"];
    }
    
    if (self.teacherId.length) {
        [dictionary setObject:self.teacherId forKey:@"teacherId"];
    }
    
    [dictionary setObject:[NSNumber numberWithInteger:self.type] forKey:@"type"];
    
    return dictionary;
}

- (NSMutableArray *)answers {
    if (!_answers) {
        self.answers = [NSMutableArray arrayWithCapacity:0];
    }
    return _answers;
}

@end
