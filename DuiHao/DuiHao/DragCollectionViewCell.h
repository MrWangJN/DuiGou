//
//  DragCollectionViewCell.h
//  DuiHao
//
//  Created by wjn on 2016/12/28.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SKDragSortDelegate <NSObject>

- (void)YLDargSortCellGestureAction:(UIGestureRecognizer *)gestureRecognizer;

- (void)YLDargSortCellCancelSubscribe:(NSString *)subscribe;

@end

@interface DragCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *functionNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *functionImageV;

- (void)setImage:(NSString *)imageName text:(NSString *)text;

@end
