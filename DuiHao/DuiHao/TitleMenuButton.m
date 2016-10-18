//
//  TitleMenuButton.m
//  DuiHao
//
//  Created by wjn on 16/10/17.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "TitleMenuButton.h"

@implementation TitleMenuButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if ([self defaultGradient]) {
            
        } else {
            [self setSpotlightCenter:CGPointMake(frame.size.width/2, frame.size.height*(-1)+10)];
            [self setBackgroundColor:[UIColor clearColor]];
            [self setSpotlightStartRadius:0];
            [self setSpotlightEndRadius:frame.size.width/2];
        }
        
        frame.origin.y -= 2.0;
        self.title = [[UILabel alloc] initWithFrame:frame];
        self.title.textAlignment = NSTextAlignmentCenter;
        //self.title.backgroundColor = [UIColor clearColor];
        self.title.textColor = [UIColor whiteColor];
        //self.title.font = [UIFont boldSystemFontOfSize:20.0];
        //self.title.shadowColor = [UIColor darkGrayColor];
        //self.title.shadowOffset = CGSizeMake(0, -1);
        [self addSubview:self.title];
        
        self.arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Pilot"]];
        [self addSubview:self.arrow];
        
    }
    return self;
}

- (UIImageView *)defaultGradient
{
    return nil;
}

- (void)layoutSubviews
{
    [self.title sizeToFit];
    self.title.center = CGPointMake(self.frame.size.width/2, (self.frame.size.height-2.0)/2);
    self.arrow.center = CGPointMake(CGRectGetMaxX(self.title.frame) + 13, self.frame.size.height / 2);
}

#pragma mark -
#pragma mark Handle taps
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.isActive = !self.isActive;
    
    return YES;
}
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.spotlightGradientRef = nil;
}
- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    self.spotlightGradientRef = nil;
}


@end
