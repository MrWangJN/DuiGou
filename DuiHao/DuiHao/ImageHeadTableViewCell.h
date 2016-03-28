//
//  ImageHeadTableViewCell.h
//  StudyAssisTant
//
//  Created by wjn on 15/8/26.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"

@interface ImageHeadTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet RoundImageView *imageHeader;
- (void)setImageHeaderView:(NSString *)imageURL;

@end
