//
//  NewsTableViewCell.h
//  StudyAssisTant
//
//  Created by wjn on 15/9/8.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"
#import "NewsModel.h"
#import "YYKit.h"
#import "YYControl.h"

/**
 文本 Line 位置修改
 将每行文本的高度和位置固定下来，不受中英文/Emoji字体的 ascent/descent 影响
 */
@interface NewsTextLinePositionModifier : NSObject <YYTextLinePositionModifier>
@property (nonatomic, strong) UIFont *font; // 基准字体 (例如 Heiti SC/PingFang SC)
@property (nonatomic, assign) CGFloat paddingTop; //文本顶部留白
@property (nonatomic, assign) CGFloat paddingBottom; //文本底部留白
@property (nonatomic, assign) CGFloat lineHeightMultiple; //行距倍数
- (CGFloat)heightForLineCount:(NSUInteger)lineCount;
@end

@protocol NewsTableViewCellViewDelegate;

@interface NewsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet RoundLabel *nameIcon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *newsName;
@property (weak, nonatomic) IBOutlet YYLabel *newsContent;
@property (weak, nonatomic) IBOutlet UILabel *becomeTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (strong, nonatomic) NewsModel *newsModel;
@property (weak, nonatomic) IBOutlet UILabel *courseName;
@property (weak, nonatomic) IBOutlet YYControl *newsImageView;

@property (nonatomic, assign) CGFloat newsContentHeight;
@property (nonatomic, assign) CGFloat newsImageViewHeight;

@property (assign, nonatomic) id<NewsTableViewCellViewDelegate>delegate;

- (CGFloat)getHeight;

@end

@protocol NewsTableViewCellViewDelegate <NSObject>

/// 点击了图片
- (void)cell:(UIView *)imgView didClickImageAtImageUrl:(NSString *)imageurl;
- (void)reLoadCell:(NewsTableViewCell *)cell;


@end
