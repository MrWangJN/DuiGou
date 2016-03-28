//
//  OptionTableViewCell.h
//  StudyAssisTant
//
//  Created by wjn on 15/9/9.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"
#import "RCLabel.h"

@interface OptionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet SAHeightenLabel *option;

- (CGFloat)textHeight;

@end
