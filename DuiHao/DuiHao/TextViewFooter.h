//
//  TextViewFooter.h
//  StudyAssisTant
//
//  Created by 王建男 on 15/3/20.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"

@protocol TextViewFooterDelegate;

@interface TextViewFooter : UIView

@property (assign, nonatomic) id<TextViewFooterDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *numberOfFooter;

@property(nonatomic,assign,getter = isDragEnable)   BOOL dragEnable;
@property(nonatomic,assign,getter = isAdsorbEnable) BOOL adsorbEnable;

- (void)setText:(NSInteger)number withCount:(NSInteger)count;

@end

@protocol TextViewFooterDelegate <NSObject>

- (void)upTextButtonHaveDidPress;
- (void)nextTextButtonHaveDidPress;
- (void)numberButtonHaveDidPress;

@end