//
//  Personal TableViewCell.m
//  DuiHao
//
//  Created by wjn on 16/4/11.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "PersonalTableViewCell.h"
#import "OnceLogin.h"

@implementation PersonalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    CALayer * spreadLayer;
//    spreadLayer = [CALayer layer];
//    CGFloat diameter = 130;  //扩散的大小
//    spreadLayer.bounds = CGRectMake(0,0, diameter, diameter);
//    spreadLayer.cornerRadius = diameter/2; //设置圆角变为圆形
//    spreadLayer.position = self.imageHeaderView.center;
//    spreadLayer.backgroundColor = [MAINCOLOR CGColor];
//    [self.layer insertSublayer:spreadLayer below:self.imageHeaderView.layer];//把扩散层放到头像按钮下面
//    CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
//    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
//    animationGroup.duration = 3;
//    animationGroup.repeatCount = INFINITY;//重复无限次
//    animationGroup.removedOnCompletion = NO;
//    animationGroup.timingFunction = defaultCurve;
//    //尺寸比例动画
//    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
//    scaleAnimation.fromValue = @0.7;//开始的大小
//    scaleAnimation.toValue = @1.0;//最后的大小
//    scaleAnimation.duration = 3;//动画持续时间
//    //透明度动画
//    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
//    opacityAnimation.duration = 3;
//    opacityAnimation.values = @[@0.4, @0.45,@0];//透明度值的设置
//    opacityAnimation.keyTimes = @[@0, @0.2,@1];//关键帧
//    opacityAnimation.removedOnCompletion = NO;
//    animationGroup.animations = @[scaleAnimation, opacityAnimation];//添加到动画组
//    [spreadLayer addAnimation:animationGroup forKey:@"pulse"];
    
}

- (void)layoutSubviews {
//    self.HeaderImageView.constant = self.imageHeaderView.width;
    [super layoutSubviews];
    self.nameLabelX.constant = (self.width - self.nameLabelW.constant - 25) / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadPersonCell {
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    [self.imageHeaderView setImageWithURL:onceLogin.imageURL];
    [self.nameLabel setTitle:onceLogin.studentName withLayout:self.nameLabelW];
    [self.schoolLabel setText:onceLogin.organizationName];
    
    if ([onceLogin.studentSex isEqualToString:@"男"]) {
        [self.genderImageView setImage:[UIImage imageNamed:@"Boy"]];
    } else {
        [self.genderImageView setImage:[UIImage imageNamed:@"Girl"]];
    }
    
    
}

@end
