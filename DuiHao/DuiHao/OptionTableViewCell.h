//
//  OptionTableViewCell.h
//  StudyAssisTant
//
//  Created by wjn on 15/9/9.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"
#import "RCLabel.h"
#import "YYKit.h"
#import "YYControl.h"
#import "OptionStatusLayout.h"

@protocol OptionTableViewCellDelegate;

@interface OptionTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet YYLabel *option;
@property (strong, nonatomic) IBOutlet RoundLabel *selectLabel;

@property (strong, nonatomic) IBOutlet YYControl *optionImage;

@property (assign, nonatomic) id<OptionTableViewCellDelegate>delegate;

- (void)setLayout:(OptionStatusLayout *)layout;

@end

@protocol OptionTableViewCellDelegate <NSObject>

/// 点击了图片
- (void)cell:(UIView *)imgView didClickImageAtImageUrl:(NSString *)imageurl;


@end