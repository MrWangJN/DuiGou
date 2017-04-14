//
//  TodayTalkTableViewCell.h
//  DuiHao
//
//  Created by wjn on 2017/2/21.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodayTalkStatusLayout.h"

@protocol TodayTalkTableViewCellDelegate <NSObject>

- (void)shareSender:(UIImage *)image;

@end

@interface TodayTalkTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *talkImageV;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UILabel *autherL;
@property (weak, nonatomic) IBOutlet UILabel *monthL;
@property (weak, nonatomic) IBOutlet UILabel *dateL;

@property (assign, nonatomic) id<TodayTalkTableViewCellDelegate>delegate;

@property (strong, nonatomic) TodayTalkStatusLayout *todayTalkStatusLayout;

@end
