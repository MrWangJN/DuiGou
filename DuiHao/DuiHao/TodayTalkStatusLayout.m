//
//  TodayTalkStatusLayout.m
//  DuiHao
//
//  Created by wjn on 2017/2/21.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "TodayTalkStatusLayout.h"

#define kWBCellTextFontSize 13      // 文本字体大小
#define kWBCellPaddingText 15   // cell 文本与其他元素间留白
#define kWBCellPadding 100       // cell 内边距
#define kWBCellContentWidth (kScreenWidth - kWBCellPadding) // cell 内容宽度

@implementation TodayTalkStatusLayout

- (instancetype)initWithStatus:(HistoryTalkModel *)status {
    if (!status) return nil;
    self = [super init];
    _model = status;
    [self layout];
    return self;
}

- (void)_layout {
    
    self.picHeight = 0;
    
    [self _layoutText];
    
    self.height += 290;
    self.height += self.textHeight;
}

/// 文本
- (void)_layoutText {
    
    self.textHeight = 0;
    self.textLayout = nil;
    
    //    if (!_status.option || !_status.option.length) {
    //        _status.option = @"此选项存在问题，系统无法显示，请联系教师更改";
    //    }
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self.model.content];
    if (text.length == 0) return;
    
    WBTextLinePositionModifier *modifier = [WBTextLinePositionModifier new];
    //    modifier.font = [UIFont fontWithName:@"Heiti SC" size:kWBCellTextFontSize];
    modifier.font = [UIFont systemFontOfSize:kWBCellTextFontSize];
    modifier.paddingTop = kWBCellPaddingText;
    modifier.paddingBottom = kWBCellPaddingText;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kWBCellContentWidth, HUGE);
    container.linePositionModifier = modifier;
    
    self.textLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (!self.textLayout) return;
    
    self.textHeight = [modifier heightForLineCount:self.textLayout.rowCount];
}


@end
