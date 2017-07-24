//
//  ActivityCollectionViewCell.m
//  DuiHao
//
//  Created by wjn on 2017/7/20.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "ActivityCollectionViewCell.h"
#import "OnceLogin.h"

@implementation ActivityCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 5.0f;
    self.activityBtu.layer.cornerRadius = 2.0f;
}

- (void)setActivityModel:(ActivityModel *)activityModel {
    _activityModel = activityModel;
    
    [self.titleL setText:activityModel.title];
    [self.detailL setText:activityModel.content];
    
    switch (activityModel.is_close.intValue) {
        case 0:
            [self.stateImageV setImageWithname:@"proceed" withborderWidth:1 withColor:[UIColor lightGrayColor]];
            break;
        case 1:
            [self.stateImageV setImageWithname:@"notproceed" withborderWidth:1 withColor:[UIColor lightGrayColor]];
            break;
        case 2:
            [self.stateImageV setImageWithname:@"abort" withborderWidth:1 withColor:[UIColor lightGrayColor]];
            break;
        default:
            break;
    }
    
    if (activityModel.pic) {
        [self.activityImageV sd_setImageWithURL:[NSURL URLWithString:activityModel.pic] placeholderImage:[UIImage imageNamed:@"Banner"]];
    }
    
    NSString *string = [NSString stringWithFormat:@"%@截止 已报名%@/%@", activityModel.end_time, activityModel.applied_count, activityModel.people_count];
    [self.endtimeL setText:string];
    
    switch (self.activityModel.state.intValue) {
        case 0:
            [self.activityBtu setTitle:@"报名" forState:UIControlStateNormal];
            break;
        case 1:
            [self.activityBtu setTitle:@"签到" forState:UIControlStateNormal];
            break;
        case 2:
            [self.activityBtu setTitle:@"已参加" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (IBAction)applyAction:(id)sender {
    
    if (self.activityModel.is_close.intValue == 1) {
        [JKAlert alertText:@"活动未开启"];
        return;
    }
    
    if (self.activityModel.is_close.intValue == 2) {
        [JKAlert alertText:@"活动已截止"];
        return;
    }
    
    switch (self.activityModel.state.intValue) {
        case 0: {
            OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
            
            if (!onceLogin.studentID) {
                return;
            }
            
            [JKAlert alertWaitingText:@"正在报名"];
            
            [SANetWorkingTask requestWithPost:[SAURLManager joinActivity] parmater:@{STUDENTID: onceLogin.studentID, ACTIVITYID:self.activityModel.activity_id} blockOrError:^(id result, NSError *error) {
                [JK_M dismissElast];
                
                if (error) {
                    [JKAlert alertText:@"请求失败"];
                    return ;
                }
                
                if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
                    [JKAlert alertText:@"成功报名"];
                    [self.activityBtu setTitle:@"签到" forState:UIControlStateNormal];
                    self.activityModel.state = [NSNumber numberWithBool:YES];
                    
                    self.activityModel.applied_count = [NSString stringWithFormat:@"%d", self.activityModel.applied_count.intValue + 1];
                    
                    NSString *string = [NSString stringWithFormat:@"%@截止 已报名%@/%@", _activityModel.end_time, _activityModel.applied_count, _activityModel.people_count];
                    [self.endtimeL setText:string];
                    
                } else {
                    [JKAlert alertText:@"报名失败"];
                }
            }];   

            break;
        }
        case 1:
            if ([self.delegate respondsToSelector:@selector(signIn)]) {
                [self.delegate signIn];
            }
            break;
        case 2:
            
            break;
        default:
            break;
    }
}
@end
