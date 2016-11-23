//
//  TextViewFooter.m
//  StudyAssisTant
//
//  Created by 王建男 on 15/3/20.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "TextViewFooter.h"

#import <objc/runtime.h>
#define PADDING     5
static void *DragEnableKey = &DragEnableKey;
static void *AdsorbEnableKey = &AdsorbEnableKey;

@implementation TextViewFooter

-(void)awakeFromNib {
	self.backgroundColor = [UIColor clearColor];
    [self.layer setCornerRadius:CGRectGetHeight([self bounds]) / 2];
    self.layer.masksToBounds = YES;
    //    然后再给图层添加一个有色的边框
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.7] CGColor];
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
}

//- (IBAction)numberButtonDidPress:(id)sender {
//	if ([self.delegate respondsToSelector:@selector(numberButtonHaveDidPress)]) {
//		[self.delegate numberButtonHaveDidPress];
//	}
//}

- (void)setText:(NSInteger)number withCount:(NSInteger)count {
    
    NSMutableString *string = [NSMutableString stringWithFormat:@"%ld/%ld", number, count];
    NSMutableAttributedString *noteString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange redRange = NSMakeRange(0, [string rangeOfString:@"/"].location);
    [noteString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:redRange];
    [self.numberOfFooter setAttributedText:noteString] ;
//    [self.numberOfFooter sizeToFit];
    
}

-(void)setDragEnable:(BOOL)dragEnable
{
    objc_setAssociatedObject(self, DragEnableKey,@(dragEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)isDragEnable
{
    return [objc_getAssociatedObject(self, DragEnableKey) boolValue];
}

-(void)setAdsorbEnable:(BOOL)adsorbEnable
{
    objc_setAssociatedObject(self, AdsorbEnableKey,@(adsorbEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)isAdsorbEnable
{
    return [objc_getAssociatedObject(self, AdsorbEnableKey) boolValue];
}

CGPoint beginPoint;
CGPoint viewCenter;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    self.highlighted = YES;
    if (![objc_getAssociatedObject(self, DragEnableKey) boolValue]) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    beginPoint = [touch locationInView:self];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    self.highlighted = NO;
    if (![objc_getAssociatedObject(self, DragEnableKey) boolValue]) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint nowPoint = [touch locationInView:self];
    
    float offsetX = nowPoint.x - beginPoint.x;
    float offsetY = nowPoint.y - beginPoint.y;
    
    self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    if (self.highlighted) {
    //        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    //        self.highlighted = NO;
    //    }
    viewCenter = self.center;
    if (self.superview && [objc_getAssociatedObject(self,AdsorbEnableKey) boolValue] ) {
        float marginLeft = self.frame.origin.x;
        float marginRight = self.superview.frame.size.width - self.frame.origin.x - self.frame.size.width;
//        float marginTop = self.frame.origin.y - 64;
        float marginBottom = self.superview.frame.size.height - self.frame.origin.y - self.frame.size.height;
        [UIView animateWithDuration:0.125 animations:^(void){
//            if (marginTop<60) {
//                self.frame = CGRectMake(marginLeft<marginRight?marginLeft<PADDING?PADDING:self.frame.origin.x:marginRight<PADDING?self.superview.frame.size.width -self.frame.size.width-PADDING:self.frame.origin.x,
//                                        PADDING,
//                                        self.frame.size.width,
//                                        self.frame.size.height);
//            }
           if (marginBottom<60) {
                self.frame = CGRectMake(marginLeft<marginRight?marginLeft<PADDING?PADDING:self.frame.origin.x:marginRight<PADDING?self.superview.frame.size.width -self.frame.size.width-PADDING:self.frame.origin.x,
                                        self.superview.frame.size.height - self.frame.size.height-PADDING,
                                        self.frame.size.width,
                                        self.frame.size.height);
                
            }
            else {
                self.frame = CGRectMake(marginLeft<marginRight?PADDING:self.superview.frame.size.width - self.frame.size.width-PADDING,
                                        self.frame.origin.y,
                                        self.frame.size.width,
                                        self.frame.size.height);
                if (self.top < 0) {
                    self.top = 0;
                }
                
            }
         
            if (self.center.x == viewCenter.x && self.center.y == viewCenter.y) {
                if ([self.delegate respondsToSelector:@selector(numberButtonHaveDidPress)]) {
                    [self.delegate numberButtonHaveDidPress];
                }
            }
        }];
    }
}


@end
