//
//  TodayTalkTableViewCell.m
//  DuiHao
//
//  Created by wjn on 2017/2/21.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "TodayTalkTableViewCell.h"
#import "ShareView.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>

@implementation TodayTalkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)shareBtuDidPress:(id)sender {
    ShareView *shareView = [[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:self options:nil][0];
    [shareView.titleL setText:[NSString stringWithFormat:@"%@\n\n %@", self.todayTalkStatusLayout.model.content, self.todayTalkStatusLayout.model.auther]];

    if ([self.delegate respondsToSelector:@selector(shareSender:)]) {
        [self.delegate shareSender:[self makeImageWithView:shareView]];
    }
}

- (void)setTodayTalkStatusLayout:(TodayTalkStatusLayout *)todayTalkStatusLayout {
    if (!todayTalkStatusLayout) {
        return;
    }
    _todayTalkStatusLayout = todayTalkStatusLayout;
    
    self.height = todayTalkStatusLayout.height;
    
    [self.dateL setText:todayTalkStatusLayout.model.date];
    [self.monthL setText:todayTalkStatusLayout.model.month];
    [self.contentL setText:todayTalkStatusLayout.model.content];
    [self.autherL setText:todayTalkStatusLayout.model.auther];
    
}

- (UIImage *)makeImageWithView:(UIView *)view

{
    
    CGSize s = view.bounds.size;
    
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数。
    
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}


@end
