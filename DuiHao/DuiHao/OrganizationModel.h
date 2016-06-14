//
//  OrganizationModel.h
//  DuiHao
//
//  Created by wjn on 16/5/30.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrganizationModel : NSObject

@property (nonatomic, strong) NSString *organizationCode;
@property (nonatomic, strong) NSString *organizationId;
@property (nonatomic, strong) NSString *organizationName;

- (instancetype)initWithResult:(NSDictionary *)result;

@end
