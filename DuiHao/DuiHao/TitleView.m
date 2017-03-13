//
//  TitleView.m
//  DuiHao
//
//  Created by wjn on 2016/12/30.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "TitleView.h"

@interface TitleView()

@property (weak, nonatomic) IBOutlet YYLabel *titleContentL;

@end

#define kWBCellTextFontSize 14      // 文本字体大小
#define kWBCellPaddingText 5   // cell 文本与其他元素间留白
#define kWBCellPadding 5       // cell 内边距
#define kWBCellContentWidth (kScreenWidth - 2 * kWBCellPadding) // cell 内容宽度
/*
 将每行的 baseline 位置固定下来，不受不同字体的 ascent/descent 影响。
 
 注意，Heiti SC 中，    ascent + descent = font size，
 但是在 PingFang SC 中，ascent + descent > font size。
 所以这里统一用 Heiti SC (0.86 ascent, 0.14 descent) 作为顶部和底部标准，保证不同系统下的显示一致性。
 间距仍然用字体默认
 */
@implementation TVTextLinePositionModifier

- (instancetype)init {
    self = [super init];
    
    if (kiOS9Later) {
        _lineHeightMultiple = 1.34;   // for PingFang SC
    } else {
        _lineHeightMultiple = 1.3125; // for Heiti SC
    }
    
    return self;
}

- (void)modifyLines:(NSArray *)lines fromText:(NSAttributedString *)text inContainer:(YYTextContainer *)container {
    //CGFloat ascent = _font.ascender;
    CGFloat ascent = _font.pointSize * 0.86;
    
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    for (YYTextLine *line in lines) {
        CGPoint position = line.position;
        position.y = _paddingTop + ascent + line.row  * lineHeight;
        line.position = position;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    TVTextLinePositionModifier *one = [self.class new];
    one->_font = _font;
    one->_paddingTop = _paddingTop;
    one->_paddingBottom = _paddingBottom;
    one->_lineHeightMultiple = _lineHeightMultiple;
    return one;
}

- (CGFloat)heightForLineCount:(NSUInteger)lineCount {
    if (lineCount == 0) return 0;
    //   CGFloat ascent = _font.ascender;
    //   CGFloat descent = -_font.descender;
    CGFloat ascent = _font.pointSize * 0.86;
    CGFloat descent = _font.pointSize * 0.14;
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    return _paddingTop + _paddingBottom + ascent + descent + (lineCount) * lineHeight;
}

@end


@implementation TitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setDetail:(NSString *)string {
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    if (text.length == 0) return;
    
    NSRange range = [string rangeOfString:@"\n"];
    
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, range.location)];
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//    style.alignment = NSTextAlignmentCenter;
    
    text.alignment = NSTextAlignmentCenter;
//    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange([string rangeOfString:@"\n"].location, text.length - [string rangeOfString:@"\n"].length)];
    
    TVTextLinePositionModifier *modifier = [TVTextLinePositionModifier new];
    modifier.font = [UIFont systemFontOfSize:kWBCellTextFontSize];
    modifier.paddingTop = kWBCellPaddingText;
    modifier.paddingBottom = kWBCellPaddingText;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kWBCellContentWidth, HUGE);
    container.linePositionModifier = modifier;
    
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (!textLayout) return;
    
//    self.titleContentL.height = [modifier heightForLineCount:textLayout.rowCount];
    self.height = [modifier heightForLineCount:textLayout.rowCount];
    
    [self.titleContentL setAttributedText:text];
//    [self.titleContentL setText:string];
}

@end
