//
//  NewsTableViewCell.h
//  StudyAssisTant
//
//  Created by wjn on 15/9/8.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"
#import "NewsModel.h"

@interface NewsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet RoundLabel *nameIcon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet SAHeightenLabel *news;
@property (weak, nonatomic) IBOutlet UILabel *becomeTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (strong, nonatomic) NewsModel *newsModel;
@property (weak, nonatomic) IBOutlet UILabel *courseName;

- (CGFloat)getHeight;

@end
