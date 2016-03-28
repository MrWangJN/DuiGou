//
//  ItemTitleTableViewCell.h
//  StudyAssisTant
//
//  Created by 王建男 on 15/3/10.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"
#import "SAHeightenLabel.h"

@protocol ItemTitleTableViewCellDelegate;

@interface ItemTitleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet SAHeightenLabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *section;
@property (weak, nonatomic) IBOutlet UIButton *answerButton;
@property (weak, nonatomic) IBOutlet UIImageView *answerImage;

@property (assign, nonatomic) id<ItemTitleTableViewCellDelegate>delegate;

- (CGFloat)textHeight;

@end

@protocol ItemTitleTableViewCellDelegate <NSObject>

- (void)answerPress;

@end