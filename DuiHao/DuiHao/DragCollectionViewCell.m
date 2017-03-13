
//
//  DragCollectionViewCell.m
//  DuiHao
//
//  Created by wjn on 2016/12/28.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "DragCollectionViewCell.h"
#define kDeleteBtnWH 10 * SCREEN_WIDTH_RATIO

@implementation DragCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setImage:(NSString *)imageName text:(NSString *)text {
    [self.functionImageV setImage:[UIImage imageNamed:imageName]];
    [self.functionNameLabel setText:text];
}

@end
