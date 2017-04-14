//
//  VideoPlayViewController.h
//  ZXVideoPlayer
//
//  Created by Shawn on 16/4/29.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import "SAKit.h"

@class ZXVideo;
@interface VideoPlayViewController : SAViewController

@property (nonatomic, strong, readwrite) ZXVideo *video;

@end
