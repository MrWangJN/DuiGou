//
//  UpdateView.h
//  StudyAssisTant
//
//  Created by wjn on 15/9/4.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"
#import "UpdateTableViewCell.h"

@protocol UpdateViewDelegate;

@interface UpdateView : UIView

@property (weak, nonatomic) IBOutlet UIButton *update;
@property (weak, nonatomic) IBOutlet UIButton *remove;

@property (assign, nonatomic) BOOL show;
@property (assign, nonatomic) id<UpdateViewDelegate>delegate;

@end

@protocol UpdateViewDelegate <NSObject>

- (void)updateDatasource;
- (void)removeDatasource;

@end