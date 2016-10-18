//
//  OptionStatusLayout.m
//  DuiHao
//
//  Created by wjn on 16/8/2.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "OptionStatusLayout.h"

#define kWBCellTextFontSize 17      // 文本字体大小
#define kWBCellPaddingText 10   // cell 文本与其他元素间留白
#define kWBCellPadding 45       // cell 内边距
#define kWBCellContentWidth (kScreenWidth - kWBCellPadding) // cell 内容宽度


@implementation OptionStatusLayout

- (instancetype)initWithOption:(NSString *)option {
    self = [super init];
    if (self) {
        
        OptionModel *status = [[OptionModel alloc] init];
        status.option = option;
        status.optionImage = @"";
        _status = status;
        [self layout];
        
    }
    return self;
}

- (instancetype)initWithStatus:(OptionModel *)status {
    if (!status) return nil;
    self = [super init];
    _status = status;
    [self layout];
    return self;
}

- (void)layout {
    [self _layout];
}

- (void)_layout {
    
    _textHeight = 0;
    _picHeight = 0;
    
    [self _layoutText];
    
    _height += 10;
    _height += _textHeight;
    
    if (_status.optionImage.length) {
        _height += 150;
    }
}

/// 文本
- (void)_layoutText {
    
    _textHeight = 0;
    _textLayout = nil;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:_status.option];
    if (text.length == 0) return;
    
    WBTextLinePositionModifier *modifier = [WBTextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:kWBCellTextFontSize];
    modifier.paddingTop = kWBCellPaddingText;
    modifier.paddingBottom = kWBCellPaddingText;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kWBCellContentWidth, HUGE);
    container.linePositionModifier = modifier;
    
    _textLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (!_textLayout) return;
    
    _textHeight = [modifier heightForLineCount:_textLayout.rowCount];
}


@end
