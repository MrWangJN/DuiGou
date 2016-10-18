//
//  BaseViewController.h
//  BaseFrameWork
//
//  Created by wjn on 16/10/18.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (strong, nonatomic) UIImageView *hintImageView;
@property (strong, nonatomic) UIButton *backBtu;

- (void)setHintImage:(NSString *)imageName whihHight:(int) hight;
- (void)hiddenHint;
- (void)noHiddenHint;
- (void)backBtuDidPress;

@end
