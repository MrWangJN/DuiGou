//
//  CircleViewCell.m
//  ColloctionView循环滚动控件
//
//  Created by caokun on 16/1/28.
//  Copyright © 2016年 caokun. All rights reserved.
//

#import "CircleViewCell.h"

@interface CircleViewCell ()

@property (strong, nonatomic) UIImageView *imageV;
@property (strong, nonatomic) UILabel *label;

@end

@implementation CircleViewCell

- (instancetype)init {
    if (self = [super init]) {
        [self myInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self myInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self myInit];
    }
    return self;
}

- (void)myInit {
    [self.contentView addSubview:self.label];
    [self.contentView addSubview:self.imageV];
}

- (UIImageView *)imageV {
    if (_imageV == nil) {
        _imageV = [[UIImageView alloc] init];
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        _imageV.userInteractionEnabled = YES;
        _imageV.backgroundColor = [UIColor clearColor];
    }
    return _imageV;
}

- (UILabel *)label {
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:12];
        _label.numberOfLines = 0;
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = self.contentView.bounds;
    self.imageV.frame = self.contentView.bounds;
}

- (void)setModel:(TodayHistoryModel *)model {
    _model = model;
    self.label.text = [NSString stringWithFormat:@"%@ %@", model.date, model.title];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageV.image = image;
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"Banner"]];
}

@end
