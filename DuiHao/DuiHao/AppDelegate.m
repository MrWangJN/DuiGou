//
//  AppDelegate.m
//  DuiHao
//
//  Created by wjn on 15/11/16.
//  Copyright © 2015年 WJN. All rights reserved.
//

#import "AppDelegate.h"
#import "UMMobClick/MobClick.h"
#import "ZWIntroductionViewController.h"
#import "UMessage.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif
#import <UMSocialCore/UMSocialCore.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@property (nonatomic, strong) ZWIntroductionViewController *introductionView;

@property (nonatomic, strong) NSArray *coverImageNames;
@property (nonatomic, strong) NSArray *backgroundImageNames;
@property (nonatomic, strong) NSArray *coverTitles;
@property (nonatomic, strong) NSURL *videoURL;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
   
    self.window.rootViewController = [[UIViewController alloc] init];
    
    [_window makeKeyAndVisible];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"Launch"]) {
        [defaults setBool:YES forKey:@"Launch"];
        [defaults synchronize];
        
        self.backgroundImageNames = @[@"FirstLaunch", @"SecondLaunch", @"ThridLaunch", @"FourthLaunch"];
        self.coverImageNames = nil;
        self.coverTitles = nil;
        self.videoURL = nil;
        
        self.introductionView = [self simpleIntroductionView];
        
        [self.window addSubview:self.introductionView.view];
        
        __weak AppDelegate *weakSelf = self;
        __weak UIWindow *weekWindow = self.window;
        self.introductionView.didSelectedEnter = ^() {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            //    UIStoryboard *startStoryBoard = [UIStoryboard storyboardWithName:@"Start" bundle:nil];
            weekWindow.rootViewController = [storyBoard instantiateInitialViewController];
            weakSelf.introductionView = nil;
        };
        
    } else {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //    UIStoryboard *startStoryBoard = [UIStoryboard storyboardWithName:@"Start" bundle:nil];
        self.window.rootViewController = [storyBoard instantiateInitialViewController];
//        self.window.rootViewController = [startStoryBoard instantiateInitialViewController];
    }

    UMConfigInstance.appKey = @"581867478f4a9d25e8003d22";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    
    //设置 AppKey 及 LaunchOptions
    [UMessage startWithAppkey:@"581867478f4a9d25e8003d22" launchOptions:launchOptions];
    //注册通知
    [UMessage registerForRemoteNotifications];
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            
        } else {
            //点击不允许
            
        }
    }];
    
    //如果你期望使用交互式(只有iOS 8.0及以上有)的通知，请参考下面注释部分的初始化代码
    UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
    action1.identifier = @"action1_identifier";
    action1.title=@"打开应用";
    action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
    
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
    action2.identifier = @"action2_identifier";
    action2.title=@"忽略";
    action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
    action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
    action2.destructive = YES;
    UIMutableUserNotificationCategory *actionCategory1 = [[UIMutableUserNotificationCategory alloc] init];
    actionCategory1.identifier = @"category1";//这组动作的唯一标示
    [actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
    NSSet *categories = [NSSet setWithObjects:actionCategory1, nil];
    
    //如果要在iOS10显示交互式的通知，必须注意实现以下代码
    if ([[[UIDevice currentDevice] systemVersion]intValue]>=10) {
        UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_ios10_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
        UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_ios10_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
        
        //UNNotificationCategoryOptionNone
        //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
        //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
        UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category101" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        NSSet *categories_ios10 = [NSSet setWithObjects:category1_ios10, nil];
        [center setNotificationCategories:categories_ios10];
    }else
    {
        [UMessage registerForRemoteNotifications:categories];
    }
    
    //如果对角标，文字和声音的取舍，请用下面的方法
    //UIRemoteNotificationType types7 = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
    //UIUserNotificationType types8 = UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge;
    //[UMessage registerForRemoteNotifications:categories withTypesForIos7:types7 withTypesForIos8:types8];
    
    //for log
    [UMessage setLogEnabled:NO];
    
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"581867478f4a9d25e8003d22"];
    
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx61cc4ba4b9146fc8" appSecret:@"c93673e69891aae8f1b6aa56be66cee2" redirectURL:@"http://mobile.umeng.com/social"];
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105815166"  appSecret:@"l7BidaTsUfY5xOP3" redirectURL:@"http://mobile.umeng.com/social"];
    //设置新浪的appKey和appSecret
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"892285707"  appSecret:@"ad671a37d31b174c1446300c2c4fc0d5" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
     [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"892285707"  appSecret:@"ad671a37d31b174c1446300c2c4fc0d5" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
    return YES;
}

// Example 1 : Simple
- (ZWIntroductionViewController *)simpleIntroductionView
{
    ZWIntroductionViewController *vc = [[ZWIntroductionViewController alloc] initWithCoverImageNames:self.backgroundImageNames];
    return vc;
}

//// Example 2 : Cover Images
//- (ZWIntroductionViewController *)coverImagesIntroductionView
//{
//    ZWIntroductionViewController *vc = [[ZWIntroductionViewController alloc] initWithCoverImageNames:self.coverImageNames backgroundImageNames:self.backgroundImageNames];
//    return vc;
//}
//
//// Example 3 : Custom Button
//- (ZWIntroductionViewController *)customButtonIntroductionView
//{
//    UIButton *enterButton = [UIButton new];
//    [enterButton setBackgroundImage:[UIImage imageNamed:@"bg_bar"] forState:UIControlStateNormal];
//    [enterButton setTitle:@"Login" forState:UIControlStateNormal];
//    ZWIntroductionViewController *vc = [[ZWIntroductionViewController alloc] initWithCoverImageNames:self.coverImageNames backgroundImageNames:self.backgroundImageNames button:enterButton];
//    return vc;
//}
//
//// Example 4 : Video
//- (ZWIntroductionViewController *)videoIntroductionView
//{
//    ZWIntroductionViewController *vc = [[ZWIntroductionViewController alloc] initWithVideo:self.videoURL volume:0.7];
//    vc.coverImageNames = self.coverImageNames;
//    vc.autoScrolling = YES;
//    return vc;
//}
//
//// Example 5 : Advance
//- (ZWIntroductionViewController *)advanceIntroductionView
//{
//    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(3, self.window.frame.size.height - 60, self.window.frame.size.width - 6, 50)];
//    loginButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
//    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
//    
//    ZWIntroductionViewController *vc = [[ZWIntroductionViewController alloc] initWithVideo:self.videoURL volume:0.7];
//    vc.coverImageNames = self.coverImageNames;
//    vc.autoScrolling = YES;
//    vc.hiddenEnterButton = YES;
//    vc.pageControlOffset = CGPointMake(0, -100);
//    vc.labelAttributes = @{ NSFontAttributeName : [UIFont fontWithName:@"Arial-BoldMT" size:28.0],
//                            NSForegroundColorAttributeName : [UIColor whiteColor] };
//    vc.coverView = loginButton;
//    
//    vc.coverTitles = self.coverTitles;
//    
//    return vc;
//}

//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    NSString *str = [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding];
//    [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]                  stringByReplacingOccurrencesOfString: @">" withString: @""]                 stringByReplacingOccurrencesOfString: @" " withString: @""]
//}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoNotification" object:self userInfo:@{@"userinfo":[NSString stringWithFormat:@"%@",userInfo]}];
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    
    //    self.userInfo = userInfo;
    //    //定制自定的的弹出框
    //    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    //    {
    //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
    //                                                            message:@"Test On ApplicationStateActive"
    //                                                           delegate:self
    //                                                  cancelButtonTitle:@"确定"
    //                                                  otherButtonTitles:nil];
    //
    //        [alertView show];
    //
    //    }
    
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
    
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (_allowRotation == 1) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }else{
        return (UIInterfaceOrientationMaskPortrait);
    }
}

// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    if (_allowRotation == 1) {
        return YES;
    }
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
