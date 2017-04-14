//
//  CourseTableViewCell.h
//  StudyAssisTant
//
//  Created by wjn on 15/8/27.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"
#import "Course.h"

@interface CourseTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet SAWidthLabel *course;
@property (weak, nonatomic) IBOutlet SAWidthLabel *teachName;
@property (strong, nonatomic) Course *courseModel;
@property (weak, nonatomic) IBOutlet RoundLabel *hintLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rankImageV;
@property (weak, nonatomic) IBOutlet UILabel *rankL;

@end
