//
//  DeformationButton.h
//  DeformationButton
//
//  Created by LuciusLu on 15/3/16.
//  Copyright (c) 2015年 MOZ. All rights reserved.
//

#import "SAKit.h"
#import "MMMaterialDesignSpinner.h"

@interface DeformationButton : UIControl

@property(nonatomic, assign)BOOL isLoading;
@property(nonatomic, retain)MMMaterialDesignSpinner *spinnerView;
@property(nonatomic, retain)UIColor *contentColor;
@property(nonatomic, retain)UIColor *progressColor;

@property(nonatomic, retain)UIButton *forDisplayButton;

- (void)initSetting;
- (void)loadingAction;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
