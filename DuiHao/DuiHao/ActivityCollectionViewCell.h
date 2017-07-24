//
//  ActivityCollectionViewCell.h
//  DuiHao
//
//  Created by wjn on 2017/7/20.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "SAKit.h"
#import "ActivityModel.h"

@protocol ActivityCollectionViewCellDelegate <NSObject>

- (void)signIn;

@end

@interface ActivityCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *activityImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *detailL;
@property (weak, nonatomic) IBOutlet UIButton *activityBtu;
@property (weak, nonatomic) IBOutlet UILabel *endtimeL;
@property (weak, nonatomic) IBOutlet RoundImageView *stateImageV;

@property (strong, nonatomic) ActivityModel *activityModel;

@property (assign, nonatomic) id<ActivityCollectionViewCellDelegate>delegate;

@end
