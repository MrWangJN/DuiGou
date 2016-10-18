//
//  ItemTitleTableViewCell.m
//  StudyAssisTant
//
//  Created by 王建男 on 15/3/10.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "ItemTitleTableViewCell.h"

@implementation ItemTitleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    for (UIView *view in self.subviews) {
        if([view isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)view).delaysContentTouches = NO; // Remove touch delay for iOS 7
            break;
        }
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    
    
    return self;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setLayout:(ItemTitleStatusLayout *)layout {
    
    if (!layout) {
        return;
    }
    
    self.height = layout.height;
    
    self.titleLabel.height = layout.textHeight;
    self.titleLabel.text = layout.status.question;
    
    self.questionImage.hidden = YES;
    self.questionImage.exclusiveTouch = YES;
    
    if (layout.status.questionImageUrl.length) {
//        self.imageView.bottom = self.height;
        
        self.questionImage.hidden = NO;
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:layout.status.questionImageUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            if (!error) {
                self.questionImage.image = image;
            }
            
        }];
        
        __block id delegate = self.delegate;
        __block UIView *questionImage = self.questionImage;
        self.questionImage.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            
            if (![delegate respondsToSelector:@selector(cell:didClickImageAtImageUrl:)]) return;
            if (state == YYGestureRecognizerStateEnded) {
                UITouch *touch = touches.anyObject;
                CGPoint p = [touch locationInView:view];
                if (CGRectContainsPoint(view.bounds, p)) {
                    [delegate cell:questionImage didClickImageAtImageUrl:layout.status.questionImageUrl];
                }
            }
        };
    }
    
    self.section.text = [NSString stringWithFormat:@"第%@章 第%@节", layout.status.section, layout.status.chapter];
    self.fromLabel.text = [NSString stringWithFormat:@"试题来源：%@", layout.status.questionOrigin];
    
}

@end
