//
//  FirstPromptView.h
//  DuiHao
//
//  Created by wjn on 2016/11/15.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstPromptView : NSObject

+ (FirstPromptView *) shareManager;
- (void)showWithImageName:(NSString *)imageName;
- (void)disMiss;

@end
