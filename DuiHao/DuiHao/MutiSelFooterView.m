//
//  MutiSelFooterView.m
//  StudyAssisTant
//
//  Created by wjn on 15/9/27.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "MutiSelFooterView.h"

#define FooterSize 190
#define AnswerHeight 130
#define AnswerLabelHeight 60
#define kWBCellTextFontSize 17      // 文本字体大小
#define kWBCellPaddingText 5   // cell 文本与其他元素间留白
#define kWBCellPadding 15       // cell 内边距
#define kWBCellContentWidth (kScreenWidth - 4 * kWBCellPadding) // cell 内容宽度
/*
 将每行的 baseline 位置固定下来，不受不同字体的 ascent/descent 影响。
 
 注意，Heiti SC 中，    ascent + descent = font size，
 但是在 PingFang SC 中，ascent + descent > font size。
 所以这里统一用 Heiti SC (0.86 ascent, 0.14 descent) 作为顶部和底部标准，保证不同系统下的显示一致性。
 间距仍然用字体默认
 */
@implementation FoorterTextLinePositionModifier

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
    FoorterTextLinePositionModifier *one = [self.class new];
    one->_font = _font;
    one->_paddingTop = _paddingTop;
    one->_paddingBottom = _paddingBottom;
    one->_lineHeightMultiple = _lineHeightMultiple;
    return one;
}

- (CGFloat)heightForLineCount:(NSUInteger)lineCount {
    if (lineCount == 0) return 0;
    //    CGFloat ascent = _font.ascender;
    //    CGFloat descent = -_font.descender;
    CGFloat ascent = _font.pointSize * 0.86;
    CGFloat descent = _font.pointSize * 0.14;
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    return _paddingTop + _paddingBottom + ascent + descent + (lineCount - 1) * lineHeight;
}

@end


@implementation MutiSelFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib {
    [super awakeFromNib];
     self.answerView.layer.borderColor = MAINCOLOR.CGColor;
}

- (void)setanswer:(NSString *)answer withAnalysis:(NSString *)analysis withImageURL:(NSString *)url{
    
    [self.answerLabel setText:answer];
    [self.analysis setText:analysis];
    
    self.analysisImageView.hidden = YES;
    self.analysisImageView.exclusiveTouch = YES;
    _analysisImageViewHeight = 0;
    
    if (url && url.length) {
        
        self.analysisImageView.hidden = NO;
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            if (!error) {
                self.analysisImageView.image = image;
            }
            
        }];

        
        __block id delegate = self.delegate;
        __block UIView *analysisImage = self.analysisImageView;
        self.analysisImageView.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            
            if (![delegate respondsToSelector:@selector(cell:didClickImageAtImageUrl:)]) return;
            if (state == YYGestureRecognizerStateEnded) {
                UITouch *touch = touches.anyObject;
                CGPoint p = [touch locationInView:view];
                if (CGRectContainsPoint(view.bounds, p)) {
                    [delegate cell:analysisImage didClickImageAtImageUrl:url];
                }
            }
        };
    }
    
    if (url && url.length) {
        [self layoutWithImage:YES];
    } else {
        [self layoutWithImage:NO];
    }
}

- (CGFloat )getFooterHeight {
    return FooterSize + _answerHeight + _analysisHeight + _analysisImageViewHeight;
}

- (CGFloat )getReSetFooterHeight {
    return FooterSize + _answerHeight + _analysisHeight;
}

- (void)layoutWithImage:(BOOL)state {
    
    _answerHeight = 0;
    _analysisHeight = 0;
    _analysisImageViewHeight = 0;
    
    NSMutableAttributedString *answerText = [[NSMutableAttributedString alloc] initWithString:_answerLabel.text];
    NSMutableAttributedString *analysisText = [[NSMutableAttributedString alloc] initWithString:_analysis.text];
    if (answerText.length == 0 && analysisText == 0) return;
    
    FoorterTextLinePositionModifier *modifier = [FoorterTextLinePositionModifier new];
    modifier.font = [UIFont systemFontOfSize:kWBCellTextFontSize];
    modifier.paddingTop = kWBCellPaddingText;
    modifier.paddingBottom = kWBCellPaddingText;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kWBCellContentWidth, HUGE);
    container.linePositionModifier = modifier;
    
    YYTextLayout *answerTextLayout = [YYTextLayout layoutWithContainer:container text:answerText];
    YYTextLayout *analysisTextLayout = [YYTextLayout layoutWithContainer:container text:analysisText];
    if (!answerTextLayout && !analysisTextLayout ) return;
    
    _answerHeight = [modifier heightForLineCount:answerTextLayout.rowCount];
    _analysisHeight = [modifier heightForLineCount:analysisTextLayout.rowCount];
    self.answerView.height = AnswerHeight;
    
    if (state) {
        _analysisImageViewHeight = 60;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.answerView.height = self.answerView.height + _answerHeight + _analysisHeight - AnswerLabelHeight + _analysisImageViewHeight;
        
        self.answerLabel.height = _answerHeight;
        self.analysis.height = _analysisHeight;
        self.analysis.top = self.answerLabel.bottom + kWBCellPaddingText / 2;
        self.analysisImageView.top = self.analysis.bottom + 5;
    }];
}

@end
