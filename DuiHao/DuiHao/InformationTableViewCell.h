//
//  InformationTableViewCell.h
//  DuiHao
//
//  Created by wjn on 2017/3/30.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "SAKit.h"

@interface InformationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet SAWidthLabel *nameLabel;
@property (weak, nonatomic) IBOutlet RoundImageView *imageHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelW;

- (void)reloadPersonCell;

@end
