//
//  CouresTableViewCell.h
//  CourseList
//
//  Created by wjn on 2017/4/18.
//  Copyright © 2017年 Ningmengkeji. All rights reserved.
//

#import "SAKit.h"
#import "WeekCourse.h"
typedef enum : NSUInteger {
    BEN ,
    WANG
} CouresTableViewCellType;

@protocol CouresTableViewCellDelegate <NSObject>

- (void)reload:(WeekCourse *)weekCourse;
- (void)add:(WeekCourse *)weekCourse;

@end

@interface CouresTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *CourseTitleL;
@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet UIButton *typeBtu;

@property (strong, nonatomic) WeekCourse *weekCourse;

@property (assign, nonatomic) CouresTableViewCellType type;

@property (assign, nonatomic) id<CouresTableViewCellDelegate> delegate;

@end
