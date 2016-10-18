//
//  ItemTitleStatusLayout.h
//  DuiHao
//
//  Created by wjn on 16/8/1.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemModel.h"
#import "SAKit.h"
#import "YYKit.h"

/**
 文本 Line 位置修改
 将每行文本的高度和位置固定下来，不受中英文/Emoji字体的 ascent/descent 影响
 */
@interface WBTextLinePositionModifier : NSObject <YYTextLinePositionModifier>
@property (nonatomic, strong) UIFont *font; // 基准字体 (例如 Heiti SC/PingFang SC)
@property (nonatomic, assign) CGFloat paddingTop; //文本顶部留白
@property (nonatomic, assign) CGFloat paddingBottom; //文本底部留白
@property (nonatomic, assign) CGFloat lineHeightMultiple; //行距倍数
- (CGFloat)heightForLineCount:(NSUInteger)lineCount;
@end

@interface ItemTitleStatusLayout : NSObject

- (instancetype)initWithStatus:(ItemModel *)status;
- (void)layout; ///< 计算布局

// 以下是数据
@property (nonatomic, strong) ItemModel *status;

//以下是布局结果

// 文本
@property (nonatomic, assign) CGFloat textHeight; //文本高度(包括下方留白)
@property (nonatomic, strong) YYTextLayout *textLayout; //文本

// 图片
@property (nonatomic, assign) CGFloat picHeight; //图片高度，0为没图片
@property (nonatomic, assign) CGSize picSize;

// 总高度
@property (nonatomic, assign) CGFloat height;


@end
