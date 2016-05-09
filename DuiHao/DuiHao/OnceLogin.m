//
//  OnlyLogin.m
//  单例登陆
//
//  Created by 王建男 on 14/10/21.
//  Copyright (c) 2014年 WJN_work@163.com. All rights reserved.
//

#import "OnceLogin.h"

static OnceLogin *_only = nil;

@implementation OnceLogin

+ (OnceLogin *)getOnlyLogin
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *path = [paths firstObject];
        path = [NSString stringWithFormat:@"%@/%@", path, @"USER"];
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        
        if ([fileManager fileExistsAtPath:path]) {
            NSData *data = [NSData dataWithContentsOfFile:path];
            _only = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        } else {
            _only = [[OnceLogin alloc] init];
        }
    });
    return _only;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    // 老版本代码
//    [aCoder encodeObject:self.schoolName forKey:@"schoolName"];
//    [aCoder encodeObject:self.schoolNumber forKey:@"schoolNumber"];
//    [aCoder encodeObject:self.studentID forKey:@"studentID"];
//    [aCoder encodeObject:self.imageURL forKey:@"imageURL"];
//    [aCoder encodeObject:self.sName forKey:@"sName"];
//    [aCoder encodeObject:self.version forKey:@"version"];
//    [aCoder encodeObject:self.message forKey:@"message"];
//    [aCoder encodeObject:self.passWord forKey:@"password"];
//    [aCoder encodeObject:self.adsImageURL forKey:@"adsImageURL"];
//    [aCoder encodeObject:[NSNumber numberWithInteger:self.asdState] forKey:@"asdState"];
    
    [aCoder encodeObject:self.studentID forKey:@"studentID"];
    [aCoder encodeObject:self.imageURL forKey:@"imageURL"];
    [aCoder encodeObject:self.studentSex forKey:@"studentSex"];
    [aCoder encodeObject:self.studentName forKey:@"studentName"];
    [aCoder encodeObject:self.studentPassword forKey:@"studentPassword"];
    [aCoder encodeObject:self.studentPhoneNum forKey:@"studentPhoneNum"];
    [aCoder encodeObject:self.privacyState forKey:@"privacyState"];
    [aCoder encodeObject:self.studentNumber forKey:@"studentNumber"];
    [aCoder encodeObject:self.organizationName forKey:@"organizationName"];
    [aCoder encodeObject:self.organizationCode forKey:@"organizationCode"];
    [aCoder encodeObject:self.sessionId forKey:@"sessionId"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        self.studentID = [aDecoder decodeObjectForKey:@"studentID"];
        self.imageURL = [aDecoder decodeObjectForKey:@"imageURL"];
        self.studentSex = [aDecoder decodeObjectForKey:@"studentSex"];
        self.studentName = [aDecoder decodeObjectForKey:@"studentName"];
        self.studentPassword = [aDecoder decodeObjectForKey:@"studentPassword"];
        self.studentPhoneNum = [aDecoder decodeObjectForKey:@"studentPhoneNum"];
        self.privacyState = [aDecoder decodeObjectForKey:@"privacyState"];
        self.studentNumber = [aDecoder decodeObjectForKey:@"studentNumber"];
        self.organizationName = [aDecoder decodeObjectForKey:@"organizationName"];
        self.organizationCode = [aDecoder decodeObjectForKey:@"organizationCode"];
        self.sessionId = [aDecoder decodeObjectForKey:@"sessionId"];
    }
    return self;
    
}

- (void)writeToLocal {
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    NSString *stringPath = [NSString stringWithFormat:@"%@/%@", path, @"SESSIONID"];
    path = [NSString stringWithFormat:@"%@/%@", path, @"USER"];
    [data writeToFile:path atomically:YES];
    
    [self.sessionId writeToFile:stringPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end
