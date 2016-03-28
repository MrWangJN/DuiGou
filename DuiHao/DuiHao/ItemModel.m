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
        if (itemModel.answer.length) {
            
            NSString *string = [[NSString alloc] initWithString:itemModel.answer];
            NSRange range = [itemModel.answer rangeOfString:@"本题答案："];
            if (range.length) {
                
                self.answer = [string substringFromIndex:range.length];
                
            } else {
                
                self.answer = string;
            }
        }
        if (itemModel.answerA.length) {
            self.answerA = [[NSString alloc] initWithString:itemModel.answerA];
        }
        if (itemModel.answerB.length) {
            self.answerB = [[NSString alloc] initWithString:itemModel.answerB];
        }
        if (itemModel.answerC.length) {
            self.answerC = [[NSString alloc] initWithString:itemModel.answerC];
        }
        if (itemModel.answerD.length) {
            self.answerD = [[NSString alloc] initWithString:itemModel.answerD];
        }
        if (itemModel.answerE.length) {
            self.answerE = [[NSString alloc] initWithString:itemModel.answerE];
        }
        if (itemModel.answerF.length) {
            self.answerF = [[NSString alloc] initWithString:itemModel.answerF];
        }
        if (itemModel.answerG.length) {
            self.answerG = [[NSString alloc] initWithString:itemModel.answerG];
        }
        if (itemModel.answerH.length) {
            self.answerH = [[NSString alloc] initWithString:itemModel.answerH];
        }
        if (itemModel.answerI.length) {
            self.answerI = [[NSString alloc] initWithString:itemModel.answerI];
        }
        if (itemModel.chapter.length) {
            self.chapter = [[NSString alloc] initWithString:itemModel.chapter];
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
        if (itemModel.answers.count) {
            self.answers = [[NSMutableArray alloc] initWithArray:itemModel.answers];
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
}

- (id)valueForUndefinedKey:(NSString *)key
{
	return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.question forKey:@"question"];
    [aCoder encodeObject:self.answer forKey:@"answer"];
    [aCoder encodeObject:self.answerA forKey:@"answerA"];
    [aCoder encodeObject:self.answerB forKey:@"answerB"];
    [aCoder encodeObject:self.answerC forKey:@"answerC"];
    [aCoder encodeObject:self.answerD forKey:@"answerD"];
    [aCoder encodeObject:self.answerE forKey:@"answerE"];
    [aCoder encodeObject:self.answerF forKey:@"answerF"];
    [aCoder encodeObject:self.answerG forKey:@"answerG"];
    [aCoder encodeObject:self.answerH forKey:@"answerH"];
    [aCoder encodeObject:self.answerI forKey:@"answerI"];
    [aCoder encodeObject:self.chapter forKey:@"chapter"];
    [aCoder encodeObject:self.courseAlias forKey:@"courseAlias"];
    [aCoder encodeObject:self.questionId forKey:@"questionId"];
    [aCoder encodeObject:self.section forKey:@"section"];
    [aCoder encodeObject:self.state forKey:@"state"];
    [aCoder encodeObject:self.teacherAliasName forKey:@"teacherAliasName"];
    [aCoder encodeObject:self.my_Answer forKey:@"my_Answer"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.select] forKey:@"select"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.type] forKey:@"type"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        self.question = [aDecoder decodeObjectForKey:@"question"];
        self.answer = [aDecoder decodeObjectForKey:@"answer"];
        self.answerA = [aDecoder decodeObjectForKey:@"answerA"];
        self.answerB = [aDecoder decodeObjectForKey:@"answerB"];
        self.answerC = [aDecoder decodeObjectForKey:@"answerC"];
        self.answerD = [aDecoder decodeObjectForKey:@"answerD"];
        self.answerE = [aDecoder decodeObjectForKey:@"answerE"];
        self.answerF = [aDecoder decodeObjectForKey:@"answerF"];
        self.answerG = [aDecoder decodeObjectForKey:@"answerG"];
        self.answerH = [aDecoder decodeObjectForKey:@"answerH"];
        self.answerI = [aDecoder decodeObjectForKey:@"answerI"];
        self.chapter = [aDecoder decodeObjectForKey:@"chapter"];
        self.courseAlias = [aDecoder decodeObjectForKey:@"courseAlias"];
        self.questionId = [aDecoder decodeObjectForKey:@"questionId"];
        self.section = [aDecoder decodeObjectForKey:@"section"];
        self.state = [aDecoder decodeObjectForKey:@"state"];
        self.teacherAliasName = [aDecoder decodeObjectForKey:@"teacherAliasName"];
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
    if (self.answer.length) {
        [dictionary setObject:self.answer forKey:@"answer"];
    }
    if (self.answerA.length) {
        [dictionary setObject:self.answerA forKey:@"answerA"];
    }
    if (self.answerB.length) {
        [dictionary setObject:self.answerB forKey:@"answerB"];
    }
    if (self.answerC.length) {
        [dictionary setObject:self.answerC forKey:@"answerC"];
    }
    if (self.answerD.length) {
        [dictionary setObject:self.answerD forKey:@"answerD"];
    }
    if (self.answerE.length) {
        [dictionary setObject:self.answerE forKey:@"answerE"];
    }
    if (self.answerF.length) {
        [dictionary setObject:self.answerF forKey:@"answerF"];
    }
    if (self.answerG.length) {
        [dictionary setObject:self.answerG forKey:@"answerG"];
    }
    if (self.answerH.length) {
        [dictionary setObject:self.answerH forKey:@"answerH"];
    }
    if (self.answerI.length) {
        [dictionary setObject:self.answerI forKey:@"answerI"];
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
