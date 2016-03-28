//
//  UIButton+NM.h
//  BaseFrameWork
//
//  Created by wjn on 15/11/17.
//  Copyright © 2015年 WJN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (NM)

@property(nonatomic,assign,getter = isDragEnable)   BOOL dragEnable;
@property(nonatomic,assign,getter = isAdsorbEnable) BOOL adsorbEnable;

@end
