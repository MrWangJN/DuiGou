//
//  CircleViewCell.h
//  ColloctionView循环滚动控件
//
//  Created by caokun on 16/1/28.
//  Copyright © 2016年 caokun. All rights reserved.
//

#import "SAKit.h"
#import "TodayHistoryModel.h"

@interface CircleViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *imageUrl;
@property (assign, nonatomic) NSInteger index;
@property (copy, nonatomic) TodayHistoryModel *model;

@end
