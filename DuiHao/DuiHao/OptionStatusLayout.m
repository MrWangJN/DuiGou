//
//  OptionStatusLayout.m
//  DuiHao
//
//  Created by wjn on 16/8/2.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "OptionStatusLayout.h"

#define kWBCellTextFontSize 18      // 文本字体大小
#define kWBCellPaddingText 15   // cell 文本与其他元素间留白
#define kWBCellPadding 100       // cell 内边距
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
    
    _picHeight = 0;
    
    [self _layoutText];
    
    _height += 10;
    _height += _textHeight;
    
    if (_status.optionImage.length) {
        _height += 60;
    }
}

/// 文本
- (void)_layoutText {
    
    _textHeight = 0;
    _textLayout = nil;
    
    if (!_status.option || !_status.option.length) {
        _status.option = @"此选项存在问题，系统无法显示，请联系教师更改";
    }
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:_status.option];
    if (text.length == 0) return;
    
    WBTextLinePositionModifier *modifier = [WBTextLinePositionModifier new];
//    modifier.font = [UIFont fontWithName:@"Heiti SC" size:kWBCellTextFontSize];
    modifier.font = [UIFont systemFontOfSize:kWBCellTextFontSize];
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
