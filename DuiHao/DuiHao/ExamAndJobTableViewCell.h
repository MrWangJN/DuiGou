//
//  ExamAndJobTableViewCell.h
//  DuiHao
//
//  Created by wjn on 2017/3/16.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "SAKit.h"
#import "YYKit.h"
#import "ExamAndJobStatusLayout.h"

@interface ExamAndJobTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet YYLabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *teacherNameL;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageV;

@property (strong, nonatomic) ExamAndJobStatusLayout *examAndJobLayout;

@end
