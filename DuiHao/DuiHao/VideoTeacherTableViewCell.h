//
//  VideoTeacherTableViewCell.h
//  DuiHao
//
//  Created by wjn on 2017/7/18.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "SAKit.h"
#import "ChildVideoModel.h"

@interface VideoTeacherTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *ColorView;
@property (weak, nonatomic) IBOutlet UILabel *teacherName;
@property (weak, nonatomic) IBOutlet UILabel *videoCount;

@property (strong, nonatomic) ChildVideoModel *childVieoModel;

@end
