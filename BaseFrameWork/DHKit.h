#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SAReachabilityManager.h"
#import "SANetWorkingTask.h"
#import "UIView+UIViewAdditions.h"
#import "SAModel.h"
#import "SAURLManager.h"
#import "SAKeyValueStore.h"
#import "ColorManager.h"
#import "LocationManager.h"
#import "URLKeyManager.h"
#import "RoundImageView.h"
#import "RoundLabel.h"
#import "SAWidthLabel.h"
#import "SAHeightenLabel.h"
#import "SAHTMLHeightenLabel.h"
#import "SAViewController.h"
#import "GUAAlertView.h"
#import "DXAlertView.h"
#import "SCLAlertView.h"
#import "RegularExpression.h"
#import "UIScrollView+UzysAnimatedGifPullToRefresh.h"
#import "QRCodeViewController.h"
#import "BaseViewController.h"

#define IS_IOS7 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 && floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1)
#define IS_IOS8  ([[[UIDevice currentDevice] systemVersion] compare:@"8" options:NSNumericSearch] != NSOrderedAscending)
#define IS_IPHONE6PLUS ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && [[UIScreen mainScreen] nativeScale] == 3.0f)
