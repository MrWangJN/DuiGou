//
//  TitleView.h
//  DuiHao
//
//  Created by wjn on 2016/12/30.
//  Copyright © 2016年 WJN. All rights reserved.
//
#import "SAKit.h"
#import "YYKit.h"

/*文本 Line 位置修改
将每行文本的高度和位置固定下来，不受中英文/Emoji字体的 ascent/descent 影响
*/
@interface TVTextLinePositionModifier : NSObject <YYTextLinePositionModifier>
@property (nonatomic, strong) UIFont *font; // 基准字体 (例如 Heiti SC/PingFang SC)
@property (nonatomic, assign) CGFloat paddingTop; //文本顶部留白
@property (nonatomic, assign) CGFloat paddingBottom; //文本底部留白
@property (nonatomic, assign) CGFloat lineHeightMultiple; //行距倍数
- (CGFloat)heightForLineCount:(NSUInteger)lineCount;
@end

@interface TitleView : UIView

- (void)setDetail:(NSString *)string;

@end
