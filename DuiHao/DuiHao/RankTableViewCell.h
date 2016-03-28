//
//  RankTableViewCell.h
//  StudyAssisTant
//
//  Created by wjn on 15/9/22.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"
#import "RankModel.h"

@interface RankTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet RoundImageView *header;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) RankModel *rankModel;

@end
