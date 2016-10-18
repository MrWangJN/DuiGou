//
//  MineControlTableViewCell.m
//  DuiHao
//
//  Created by wjn on 16/7/26.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "MineControlTableViewCell.h"
#import "OnceLogin.h"

@implementation MineControlTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    
    if ([onceLogin.privacyState isEqualToString:@"1"]) {
        [self.switchBtu setOn:YES];
    } else {
        [self.switchBtu setOn:NO];
    }
    
}

- (IBAction)switchChange:(id)sender {
    
    NSString *state;
    
    NSString *open = @"1";
    NSString *close = @"2";
    
    if (self.switchBtu.isOn) {
        state = open;
    } else {
        state = close;
    }
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    [KVNProgress showWithStatus:@"正在更改权限"];
    
    [SANetWorkingTask requestWithPost:[SAURLManager changePrivacyState] parmater:@{STUDENTID: onceLogin.studentID,PRIVACYSTATE: state} blockOrError:^(id result, NSError *error) {
       
        if (error) {
            
            if ([onceLogin.privacyState isEqualToString:@"1"]) {
                [self.switchBtu setOn:YES];
            } else {
                [self.switchBtu setOn:NO];
            }
            return ;
        }
        
        if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
            onceLogin.privacyState = state;
            [onceLogin writeToLocal];
            [KVNProgress showSuccess];
        } else {
            
            if ([onceLogin.privacyState isEqualToString:@"1"]) {
                [self.switchBtu setOn:YES];
            } else {
                [self.switchBtu setOn:NO];
            }
            
            [KVNProgress showErrorWithStatus:result[@"errMsg"]];
        }
        
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
