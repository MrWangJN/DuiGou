//
//  ADSViewController.m
//  StudyAssisTant
//
//  Created by wjn on 15/10/8.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "ADSViewController.h"

@interface ADSViewController ()

@end

@implementation ADSViewController

- (instancetype)init
{
    self = [super initWithNibName:@"ADSViewController" bundle:nil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
    self.timeLabel.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.5];
    // Do any additional setup after loading the view from its nib.
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    [self.adsImageView sd_setImageWithURL:[NSURL URLWithString:onceLogin.adsImageURL]];
    
    __block int timeout = 3;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self buttonDidPress:self.button];

            });
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.timeLabel setNewText:[NSString stringWithFormat:@"%ds", timeout % 60]];
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);

    
}

- (IBAction)buttonDidPress:(UIButton *)sender {
    if (!sender.tag) {
        return;
    }
    sender.tag = 0;
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
