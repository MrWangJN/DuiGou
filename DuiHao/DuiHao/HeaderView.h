//
//  HeaderView.h
//  CourseList
//
//  Created by wjn on 2017/4/20.
//  Copyright © 2017年 Ningmengkeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *courseT;
@property (weak, nonatomic) IBOutlet UITextField *teacherT;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
