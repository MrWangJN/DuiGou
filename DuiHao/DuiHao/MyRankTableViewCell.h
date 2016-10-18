//
//  MyRankTableViewCell.h
//  StudyAssisTant
//
//  Created by wjn on 15/9/22.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAkit.h"
#import "RankModel.h"
#import "Course.h"

@interface MyRankTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userHeaderImage;
@property (strong, nonatomic) RankModel *rankModel;

- (void)setRankModel:(RankModel *)rankModel withCourse:(NSString *)course;

@end
