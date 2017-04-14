//
//  PPTTableViewCell.h
//  DuiHao
//
//  Created by wjn on 2017/3/14.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "SAKit.h"
#import "PPTModel.h"
#import "CourseVideoModel.h"

@interface PPTTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property (weak, nonatomic) IBOutlet UIButton *downloadB;

@property (strong, nonatomic) PPTModel *pptModel;
@property (strong, nonatomic) CourseVideoModel *cvModel;

@end
