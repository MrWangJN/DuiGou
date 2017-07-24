//
//  FooterView.h
//  CourseList
//
//  Created by wjn on 2017/4/20.
//  Copyright © 2017年 Ningmengkeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FooterViewDelegate <NSObject>

- (void)add;

@end

@interface FooterView : UIView

@property (assign, nonatomic) id<FooterViewDelegate>delegate;

@end
