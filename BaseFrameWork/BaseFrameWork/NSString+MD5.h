//
//  NSString+MD5.h
//  StudyAssisTant
//
//  Created by 王建男 on 15/3/8.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonCrypto/CommonDigest.h"
#import "CommonCrypto/CommonCrypto.h"

@interface NSString (MD5)

- (NSString *)md5ForString;
- (NSString *)md5ForData;

@end
