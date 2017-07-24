//
//  AddTableViewCell.h
//  CourseList
//
//  Created by wjn on 2017/4/18.
//  Copyright © 2017年 Ningmengkeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeekView.h"
#import "WeekCourse.h"

@protocol AddTableViewCellDelegate <NSObject>

- (void)deleteWeek:(WeekCourse *)weekCourse;

@end

@interface AddTableViewCell : UITableViewCell<WeekViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tF;
@property (weak, nonatomic) IBOutlet UIButton *zhou;
@property (weak, nonatomic) IBOutlet UIButton *jie;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shanB;
@property (weak, nonatomic) IBOutlet UIButton *shan;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (assign, nonatomic) id<AddTableViewCellDelegate>delegate;

@property (strong, nonatomic) WeekCourse *weekCourse;

@end
