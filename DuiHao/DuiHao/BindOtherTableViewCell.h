//
//  BindOtherTableViewCell.h
//  DuiHao
//
//  Created by wjn on 16/4/20.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindOtherTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIView *bottomLineView;

- (void)setTitle:(NSString *)title withContent:(NSString *)content;

@end
