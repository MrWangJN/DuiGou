//
//  PassWordViewController.h
//  DuiHao
//
//  Created by wjn on 16/4/4.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "SAKit.h"

@protocol PassWordViewControllerDelegate;


@interface PassWordViewController : UIViewController

@property (assign, nonatomic) id<PassWordViewControllerDelegate>delegate;

- (instancetype)initWithPhoneNum:(NSString *)phoneNum;

@end

@protocol PassWordViewControllerDelegate <NSObject>

- (void)phoneNumAndpassWorld:(NSString *)passWorld;

@end