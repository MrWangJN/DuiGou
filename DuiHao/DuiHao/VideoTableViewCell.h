//
//  VideoTableViewCell.h
//  DuiHao
//
//  Created by wjn on 2017/7/18.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "SAKit.h"
#import "VideoModel.h"

@interface VideoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *courseName;
@property (weak, nonatomic) IBOutlet UILabel *teacherNumL;
@property (weak, nonatomic) IBOutlet UILabel *fileNumL;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (strong, nonatomic) VideoModel *videoModel;

@end
