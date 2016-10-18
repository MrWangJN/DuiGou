//
//  BaseViewController.m
//  BaseFrameWork
//
//  Created by wjn on 16/10/18.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "BaseViewController.h"
#import "UIView+UIViewAdditions.h"
#import "ColorManager.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.hintImageView];
    [self.view addSubview:self.backBtu];
}

- (UIImageView *)hintImageView {
    if (!_hintImageView) {
        self.hintImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _hintImageView.backgroundColor = TABLEBACKGROUND;
        _hintImageView.contentMode = UIViewContentModeCenter;
        _hintImageView.hidden = YES;
    }
    return _hintImageView;
}

- (UIButton *)backBtu {
    if (!_backBtu) {
        self.backBtu = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtu.frame = self.hintImageView.bounds;
        _backBtu.backgroundColor = [UIColor clearColor];
        [_backBtu addTarget:self action:@selector(backBtuDidPress) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtu;
}

#pragma mark - 设置提示图片

- (void)setHintImage:(NSString *)imageName whihHight:(int) hight{
    [self.hintImageView setImage:[UIImage imageNamed:imageName]];
    self.hintImageView.height -= hight;
}

#pragma mark - 显示

- (void)hiddenHint {
    self.hintImageView.hidden = NO;
}

#pragma mark - 隐藏

- (void)noHiddenHint {
    self.hintImageView.hidden = YES;
}

#pragma mark - 触发点击事件

- (void)backBtuDidPress {
    
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
