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
    [aCoder encodeObject:self.schoolName forKey:@"schoolName"];
    [aCoder encodeObject:self.schoolNumber forKey:@"schoolNumber"];
    [aCoder encodeObject:self.studentID forKey:@"studentID"];
    [aCoder encodeObject:self.imageURL forKey:@"imageURL"];
    [aCoder encodeObject:self.sName forKey:@"sName"];
    [aCoder encodeObject:self.version forKey:@"version"];
    [aCoder encodeObject:self.message forKey:@"message"];
    [aCoder encodeObject:self.passWord forKey:@"password"];
    [aCoder encodeObject:self.adsImageURL forKey:@"adsImageURL"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.asdState] forKey:@"asdState"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        self.schoolName = [aDecoder decodeObjectForKey:@"schoolName"];
        self.schoolNumber = [aDecoder decodeObjectForKey:@"schoolNumber"];
        self.studentID = [aDecoder decodeObjectForKey:@"studentID"];
        self.imageURL = [aDecoder decodeObjectForKey:@"imageURL"];
        self.sName = [aDecoder decodeObjectForKey:@"sName"];
        self.version = [aDecoder decodeObjectForKey:@"version"];
        self.message = [aDecoder decodeObjectForKey:@"message"];
        self.passWord = [aDecoder decodeObjectForKey:@"password"];
        self.adsImageURL = [aDecoder decodeObjectForKey:@"adsImageURL"];
        NSNumber *number = [aDecoder decodeObjectForKey:@"asdState"];
        self.asdState = number.integerValue;
    }
    return self;
    
}

- (void)writeToLocal {
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    path = [NSString stringWithFormat:@"%@/%@", path, @"USER"];
    [data writeToFile:path atomically:YES];

}

@end
