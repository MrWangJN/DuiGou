
//
//  ExamHeaderView.m
//  StudyAssisTant
//
//  Created by wjn on 15/10/4.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "ExamHeaderView.h"

@implementation ExamHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
}



- (IBAction)buttonDidPress:(id)sender {
    if ([self.delegate respondsToSelector:@selector(submitCanUp)]) {
        [self.delegate submitCanUp];
    }
}

- (void)setText:(NSInteger)number withCount:(NSInteger)count {
    NSMutableString *string = [NSMutableString stringWithFormat:@"%ld/%ld", (long)number, count];
//    NSMutableAttributedString *noteString = [[NSMutableAttributedString alloc] initWithString:string];
//    NSRange redRange = NSMakeRange(0, [string rangeOfString:@"/"].location);
//    [noteString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:redRange];
    [self.numberLabel setText:string] ;
}

- (void)start:(int)examTime {
    
    __block int timeout = examTime * 60;
   
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.delegate) {
                    [self.delegate updata];
                }
            });
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.timeLabel setText:[NSString stringWithFormat:@"%02d:%02d:%02d", timeout / 3600, timeout / 60, timeout % 60]];
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

@end
