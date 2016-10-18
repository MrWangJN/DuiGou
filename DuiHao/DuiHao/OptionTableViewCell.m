//
//  OptionTableViewCell.m
//  StudyAssisTant
//
//  Created by wjn on 15/9/9.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "OptionTableViewCell.h"

@implementation OptionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    for (UIView *view in self.subviews) {
//        if([view isKindOfClass:[UIScrollView class]]) {
//            ((UIScrollView *)view).delaysContentTouches = NO; // Remove touch delay for iOS 7
//            break;
//        }
//    }
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.backgroundView.backgroundColor = [UIColor clearColor];
//    self.contentView.backgroundColor = [UIColor clearColor];
//    self.backgroundColor = [UIColor clearColor];
    
    
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setLayout:(OptionStatusLayout *)layout {
    
    if (!layout) {
        return;
    }
    
    self.height = layout.height;
    
    self.option.height = layout.textHeight;
    self.option.text = layout.status.option;

    self.optionImage.hidden = YES;
    self.optionImage.exclusiveTouch = YES;

    if (layout.status.optionImage.length) {
        
        self.optionImage.hidden = NO;
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:layout.status.optionImage] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            if (!error) {
                self.optionImage.image = image;
            }
            
        }];
        
        __block id delegate = self.delegate;
        __block UIView *questionImage = self.optionImage;
        self.optionImage.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            
            if (![delegate respondsToSelector:@selector(cell:didClickImageAtImageUrl:)]) return;
            if (state == YYGestureRecognizerStateEnded) {
                UITouch *touch = touches.anyObject;
                CGPoint p = [touch locationInView:view];
                if (CGRectContainsPoint(view.bounds, p)) {
                    [delegate cell:questionImage didClickImageAtImageUrl:layout.status.optionImage];
                }
            }
        };
    }
}


@end
