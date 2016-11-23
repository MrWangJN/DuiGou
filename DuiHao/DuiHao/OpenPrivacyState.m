//
//  OpenPrivacyState.m
//  DuiHao
//
//  Created by wjn on 16/7/26.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "OpenPrivacyState.h"
#import "OnceLogin.h"

@implementation OpenPrivacyState

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)openButtonDidPress:(id)sender {
    
    [KVNProgress showWithStatus:@"正在更改权限"];
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    [SANetWorkingTask requestWithPost:[SAURLManager changePrivacyState] parmater:@{STUDENTID: onceLogin.studentID,PRIVACYSTATE: @"1"} blockOrError:^(id result, NSError *error) {
        
        if (error) {
            return ;
        }
        
        if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
            onceLogin.privacyState = @"1";
            [onceLogin writeToLocal];
            [KVNProgress showSuccessWithStatus:@"已开启排行榜权限"];
            [self.delegate openHasPress];            
        } else {
            [KVNProgress showErrorWithStatus:@"开启权限失败"];
        }
        
    }];
}

@end
