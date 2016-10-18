//
//  OpenPrivacyState.h
//  DuiHao
//
//  Created by wjn on 16/7/26.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "SAKit.h"

@protocol OpenPrivacyStateDelegate;

@interface OpenPrivacyState : UIView

@property (nonatomic, assign) id<OpenPrivacyStateDelegate>delegate;

@end

@protocol OpenPrivacyStateDelegate <NSObject>

- (void)openHasPress;

@end
