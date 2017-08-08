//
//  WKWebViewController.m
//  DuiHao
//
//  Created by wjn on 2017/7/24.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "WKWebViewController.h"
#import "SDWebView.h"
#import "WEBViewController.h"

@interface WKWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) SDWebView *sdWebView;
@property (nonatomic, copy) NSString *loadURL;

@end


@implementation WKWebViewController

- (instancetype)initWithLoadURL:(NSString *)loadURL withTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        
        if (loadURL) {
            self.loadURL = loadURL;
        }
        
        [self.navigationItem setTitle:title];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.sdWebView];
    
    if (self.loadURL) {
        [self.sdWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.loadURL]]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.sdWebView.frame = self.view.bounds;
}

- (SDWebView *)sdWebView {
    if (!_sdWebView) {
        self.sdWebView = [[SDWebView alloc] initWithFrame:self.view.bounds];
        _sdWebView.webDelegate = self;
    }
    return _sdWebView;
}

#pragma mark - backbutton

- (void)backButtonDidPress {
    [self.view resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    WEBViewController *wkWebViewController = [[WEBViewController alloc] initWithURL:navigationAction.request.URL.absoluteString withName:@"投票详情"];
    [self.navigationController pushViewController:wkWebViewController animated:YES];
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
