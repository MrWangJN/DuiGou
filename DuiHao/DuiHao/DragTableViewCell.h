//
//  DragTableViewCell.h
//  DuiHao
//
//  Created by wjn on 2016/12/28.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "SAKit.h"

@protocol DragTableViewCellDelegate <NSObject>

- (void)dragTableViewCellDidSelect:(NSInteger )index;

@end

@interface DragTableViewCell : UITableViewCell

@property (assign, nonatomic) id<DragTableViewCellDelegate>delegate;

@end
