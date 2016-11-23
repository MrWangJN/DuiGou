//
//  WEBViewController.m
//  DuiHao
//
//  Created by wjn on 2016/11/11.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "WEBViewController.h"
#import "KVNProgress.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialUIManager.h"

@interface WEBViewController ()<UIWebViewDelegate>

@property (copy, nonatomic) NSString *webURL;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (copy, nonatomic) NSString *name;

@end

@implementation WEBViewController

- (instancetype)initWithURL:(NSString *)url withName:(NSString *)name
{
    self = [super init];
    if (self) {
        self.webURL = url;
        self.name = name;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.tabBarController.tabBar setHidden:YES];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"分析"];
    
    UIBarButtonItem *scanItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareDidPress:)];
    [self.navigationItem setRightBarButtonItem:scanItem];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    NSString *stringPath = [NSString stringWithFormat:@"%@/%@", path, @"SESSIONID"];
    NSString *sessionId = [[NSString alloc] initWithContentsOfFile:stringPath encoding:NSUTF8StringEncoding error:nil];
    
    if (!sessionId) {
        [KVNProgress showErrorWithStatus:@"登录信息过期，请重新登录"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    self.webURL = [NSString stringWithFormat:@"%@&SessionID=%@", self.webURL, sessionId];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.webURL]];
    [self.webView loadRequest:request];
    self.webView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shareDidPress:(id)sender {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.name descr:@"对勾教育服务平台数据分析统计" thumImage:[UIImage imageNamed:@"Icon"]];
    //设置网页地址
    shareObject.webpageUrl = self.webURL;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView, UMSocialPlatformType platformType) {
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
            }else{
            }
        }];
    }];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [KVNProgress showWithStatus:@"正在加载"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [KVNProgress dismiss];
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
