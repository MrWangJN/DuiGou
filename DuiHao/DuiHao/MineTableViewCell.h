//
//  MineTableViewCell.h
//  StudyAssisTant
//
//  Created by wjn on 15/8/31.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"

#define TITLE @"title"
#define TITLEIMAGE @"titleImage"
#define ARROWIMAGE @"arrowImage"

@interface MineTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (strong, nonatomic) NSDictionary *dic;

@end
