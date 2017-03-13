//
//  MessageTableViewCell.h
//  DuiHao
//
//  Created by wjn on 2017/3/13.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"

@interface MessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *teacherNameL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;

@property (strong, nonatomic) NewsModel *newsModel;

@end
