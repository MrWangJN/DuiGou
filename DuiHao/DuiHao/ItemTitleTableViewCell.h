//
//  ItemTitleTableViewCell.h
//  StudyAssisTant
//
//  Created by 王建男 on 15/3/10.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"
#import "SAHeightenLabel.h"
#import "YYKit.h"
#import "YYControl.h"
#import "ItemTitleStatusLayout.h"

@protocol ItemTitleTableViewCellDelegate;

@interface ItemTitleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet YYLabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *section;
@property (strong, nonatomic) IBOutlet UILabel *fromLabel;

@property (strong, nonatomic) IBOutlet YYControl *questionImage;

@property (assign, nonatomic) id<ItemTitleTableViewCellDelegate>delegate;

- (void)setLayout:(ItemTitleStatusLayout *)layout;

@end

@protocol ItemTitleTableViewCellDelegate <NSObject>

/// 点击了图片
- (void)cell:(UIView *)imgView didClickImageAtImageUrl:(NSString *)imageurl;

@end