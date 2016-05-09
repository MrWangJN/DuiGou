//
//  NSString+MD5.h
//  StudyAssisTant
//
//  Created by 王建男 on 15/3/8.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "NSString+MD5.h"

@implementation NSString (MD5)

- (NSString *)md5ForString {

    //1.获取C字符串（MD5加密基于C语言实现，Foundation框架字符串需要转化）
    const char * fooData = [self UTF8String];//__strong const char *UTF8String,C语言无法持有字符串，必须用__strong修饰来拷贝内容
    //2.创建字符串数组接收MD5值
    //一个字节是8位，两个字节是16位，两个字符可以表示一个16位进制的数，MD5结果为32位，实际上由16位16进制数组成。
    unsigned char resut[CC_MD5_DIGEST_LENGTH];
    
    //3.计算MD5值(结果存储在result数组中)
    CC_MD5(fooData, (CC_LONG)strlen(fooData), resut);
    
    //4.获取摘要值
    NSMutableString *hash = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++) {
        [hash appendFormat:@"%02X",resut[i]];
    }
    return [hash lowercaseString];
}

- (NSString *)md5ForData {
    //1.NSData对象获取
    //获取文件路径
    //根据文件路径获取NSData对象
    NSData *data = [NSData dataWithContentsOfFile:self];
    //2.创建MD5变量
    CC_MD5_CTX md5;
    //3.初始化MD5变量
    CC_MD5_Init(&md5);
    //4.准备MD5加密
    CC_MD5_Update(&md5, data.bytes, (CC_LONG)data.length);
    //5.结束MD5加密
    unsigned char result[CC_MD5_DIGEST_LENGTH];
                      CC_MD5_Final(result, &md5);
    //6.获取结果
    NSMutableString *resultString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++) {
        [resultString appendFormat:@"%02X",result[i]];
    }
    return [resultString lowercaseString];
}

@end
