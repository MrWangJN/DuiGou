
//
//  QRCodeViewController.m
//  二维码
//
//  Created by wjn on 15/11/25.
//  Copyright © 2015年 WJN. All rights reserved.
//

#import "QRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "OnceLogin.h"
#import "BindInformationViewController.h"

#define AUTH_ALERT_TAG (int)281821
#define  ScreenHeight  [UIScreen mainScreen].bounds.size.height
#define  ScreenWidth   [UIScreen mainScreen].bounds.size.width

@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate, CAAnimationDelegate> {
    AVCaptureSession * session;//输入输出的中间桥梁
    int line_tag;
    UIView *highlightView;
}

@end

@implementation QRCodeViewController

/**
 *  @author Whde
 *
 *  viewDidLoad
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self instanceDevice];
}

/**
 *  @author Whde
 *
 *  配置相机属性
 */
- (void)instanceDevice{

    line_tag = 1872637;
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    if (input) {
        [session addInput:input];
    }
    if (output) {
        [session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        NSMutableArray *a = [[NSMutableArray alloc] init];
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [a addObject:AVMetadataObjectTypeQRCode];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
            [a addObject:AVMetadataObjectTypeEAN13Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
            [a addObject:AVMetadataObjectTypeEAN8Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
            [a addObject:AVMetadataObjectTypeCode128Code];
        }
        output.metadataObjectTypes=a;
    }
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    [self setOverlayPickerView];
    
    [session addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:nil];
    
    //开始捕获
    [session startRunning];
}

/**
 *  @author Whde
 *
 *  监听扫码状态-修改扫描动画
 *
 *  @param keyPath
 *  @param object
 *  @param change
 *  @param context
 */
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    if ([object isKindOfClass:[AVCaptureSession class]]) {
        BOOL isRunning = ((AVCaptureSession *)object).isRunning;
        if (isRunning) {
            [self addAnimation];
        }else{
            [self removeAnimation];
        }
    }
}

/**
 *  @author Whde
 *
 *  获取扫码结果
 *
 *  @param captureOutput
 *  @param metadataObjects
 *  @param connection
 */
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex :0];
        
        //输出扫描字符串
        NSString *data = metadataObject.stringValue;
        
        if ([data rangeOfString:@"mlearning"].location == NSNotFound) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无效的二维码" message:nil delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        NSString *jsonString = [data substringFromIndex:9];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *object = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        if (!object) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"签到失败，请重新扫码" message:data delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
        
        
        if ([onceLogin.studentNumber isEqualToString:@"未绑定"] ||  [onceLogin.organizationCode isEqualToString:@"未绑定"]) {
            
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert addButton:@"确定" actionBlock:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            [alert showError:self title:@"签到失败" subTitle:@"请到我的页面绑定学号以及机构" closeButtonTitle:nil duration:0.0f];
            return;
        }
        
        NSDictionary *dic = @{STUDENTID: onceLogin.studentID, ATTENDANCEID: object[ATTENDANCEID], DEVICENUMBER: [[[UIDevice currentDevice] identifierForVendor] UUIDString], STUDENTNUMBER: onceLogin.studentNumber, QRCODENUMBER: object[QRCODENUMBER]};
        [KVNProgress showWithStatus:@"正在签到"];
        [SANetWorkingTask requestWithPost:[SAURLManager qrcodeSignIn] parmater:dic blockOrError:^(id result, NSError *error) {
            [KVNProgress dismiss];
            
            if (error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"签到失败" message:nil delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alert show];
                return ;
            }
            
            if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
                 [KVNProgress showSuccessWithStatus:@"签到成功"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self selfRemoveFromSuperview];
                });
                return;
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"签到失败" message:result[ERRORMESSAGE] delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alert show];
            }
            
        }];
    }
}

/**
 *  @author Whde
 *
 *  未识别(其他)的二维码提示点击"好",继续扫码
 *
 *  @param alertView
 */

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
     [session startRunning];
}

/**
 *  @author Whde
 *
 *  didReceiveMemoryWarning
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  @author Whde
 *
 *  创建扫码页面
 */
- (void)setOverlayPickerView
{
    //左侧的view
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, ScreenHeight)];
    leftView.alpha = 0.5;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    //右侧的view
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-30, 0, 30, ScreenHeight)];
    rightView.alpha = 0.5;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    //最上部view
    UIImageView* upView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, ScreenWidth-60, (self.view.center.y-(ScreenWidth-60)/2))];
    upView.alpha = 0.5;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    
    //底部view
    UIImageView * downView = [[UIImageView alloc] initWithFrame:CGRectMake(30, (self.view.center.y+(ScreenWidth-60)/2), (ScreenWidth-60), (ScreenHeight-(self.view.center.y-(ScreenWidth-60)/2)))];
    downView.alpha = 0.5;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    
    UIImageView *centerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-60, ScreenWidth-60)];
    centerView.center = self.view.center;
    centerView.image = [UIImage imageNamed:@"scanFrame.png"];
    centerView.contentMode = UIViewContentModeScaleAspectFit;
    centerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:centerView];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(upView.frame), ScreenWidth-60, 2)];
    line.tag = line_tag;
    line.image = [UIImage imageNamed:@"scanLine.png"];
    line.contentMode = UIViewContentModeScaleAspectFill;
    line.backgroundColor = [UIColor clearColor];
    [self.view addSubview:line];
    
    UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMinY(downView.frame), ScreenWidth-60, 60)];
    msg.backgroundColor = [UIColor clearColor];
    msg.textColor = [UIColor whiteColor];
    msg.textAlignment = NSTextAlignmentCenter;
    msg.font = [UIFont systemFontOfSize:16];
    msg.text = @"将二维码放入框内,即可自动扫描";
    [self.view addSubview:msg];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenHeight-100, ScreenWidth, 100)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:24];
    label.text = @"扫一扫,让签到更轻松";
    [self.view addSubview:label];
    
    
    CGRect leftFrame;
    leftFrame = CGRectMake(-2, 10, 60, 64);
    UIButton *leftButton= [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame =leftFrame;
//    leftButton.backgroundColor = [UIColor redColor];
    [leftButton addTarget:self action:@selector(dismissOverlayView:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.view addSubview:leftButton];
}

/**
 *  @author Whde
 *
 *  添加扫码动画
 */
- (void)addAnimation{
    UIView *line = [self.view viewWithTag:line_tag];
    line.hidden = NO;
    CABasicAnimation *animation = [QRCodeViewController moveYTime:2 fromY:[NSNumber numberWithFloat:0] toY:[NSNumber numberWithFloat:ScreenWidth-60-2] rep:OPEN_MAX];
    [line.layer addAnimation:animation forKey:@"LineAnimation"];
}

+ (CABasicAnimation *)moveYTime:(float)time fromY:(NSNumber *)fromY toY:(NSNumber *)toY rep:(int)rep
{
    CABasicAnimation *animationMove = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [animationMove setFromValue:fromY];
    [animationMove setToValue:toY];
    animationMove.duration = time;
    animationMove.delegate = self;
    animationMove.repeatCount  = rep;
    animationMove.fillMode = kCAFillModeForwards;
    animationMove.removedOnCompletion = NO;
    animationMove.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animationMove;
}


/**
 *  @author Whde
 *
 *  去除扫码动画
 */
- (void)removeAnimation{
    UIView *line = [self.view viewWithTag:line_tag];
    [line.layer removeAnimationForKey:@"LineAnimation"];
    line.hidden = YES;
}

/**
 *  @author Whde
 *
 *  扫码取消button方法
 *
 *  @return
 */
- (void)dismissOverlayView:(id)sender{
    [self selfRemoveFromSuperview];
}

/**
 *  @author Whde
 *
 *  从父视图中移出
 */
- (void)selfRemoveFromSuperview{
    [session removeObserver:self forKeyPath:@"running" context:nil];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
//    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.view.alpha = 0;
//    } completion:^(BOOL finished) {
//        [self.view removeFromSuperview];
//    }];
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
