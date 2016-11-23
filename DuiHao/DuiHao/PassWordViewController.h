//
//  PassWordViewController.h
//  DuiHao
//
//  Created by wjn on 16/4/4.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "SAKit.h"
typedef enum : NSUInteger {
    Register,
    GetPassword
} GetType;

@protocol PassWordViewControllerDelegate;


@interface PassWordViewController : SAViewController

@property (assign, nonatomic) id<PassWordViewControllerDelegate>delegate;
@property (assign, nonatomic) GetType getType;

- (instancetype)initWithPhoneNum:(NSString *)phoneNum withType:(GetType )type;

@end

@protocol PassWordViewControllerDelegate <NSObject>

- (void)phoneNumAndpassWorld:(NSString *)passWorld;

@end
