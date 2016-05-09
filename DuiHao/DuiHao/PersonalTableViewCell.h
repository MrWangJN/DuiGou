//
//  Personal TableViewCell.h
//  DuiHao
//
//  Created by wjn on 16/4/11.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "SAKit.h"

@interface PersonalTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *HeaderImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nameLabelX;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nameLabelW;



@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *schoolLabel;
@property (strong, nonatomic) IBOutlet RoundImageView *imageHeaderView;
@property (strong, nonatomic) IBOutlet UIImageView *genderImageView;

- (void)reloadPersonCell;

@end
