//
//  NewsTableViewCell.m
//  StudyAssisTant
//
//  Created by wjn on 15/9/8.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "NewsTableViewCell.h"

#define NewsCellHeight 80
#define AnswerHeight 130
#define AnswerLabelHeight 60
#define kWBCellTextFontSize 17      // 文本字体大小
#define kWBCellPaddingText 10   // cell 文本与其他元素间留白
#define kWBCellPadding 15       // cell 内边距
#define kWBCellContentWidth (kScreenWidth - 6 * kWBCellPadding) // cell 内容宽度
/*
 将每行的 baseline 位置固定下来，不受不同字体的 ascent/descent 影响。
 
 注意，Heiti SC 中，    ascent + descent = font size，
 但是在 PingFang SC 中，ascent + descent > font size。
 所以这里统一用 Heiti SC (0.86 ascent, 0.14 descent) 作为顶部和底部标准，保证不同系统下的显示一致性。
 间距仍然用字体默认
 */
@implementation NewsTextLinePositionModifier

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
    NewsTextLinePositionModifier *one = [self.class new];
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


@implementation NewsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat)getHeight {
    
//    self.becomeTime.top = self.news.bottom;
//    self.endTime.top = self.news.bottom ;
//    
//    self.height = self.becomeTime.bottom + 5;
    return NewsCellHeight + _newsImageViewHeight + _newsContentHeight;
}

- (void)setNewsModel:(NewsModel *)newsModel {
    
    [self.nameIcon setText:newsModel.courseName];
    [self.name setText:newsModel.teacherName];
    [self.courseName setText:newsModel.courseName];
    [self.newsName setText:newsModel.messageTitle];
    [self.newsContent setText:newsModel.messageContent];
    [self.becomeTime setText:newsModel.beginDateTime];
    [self.endTime setText:newsModel.endDateTime];
   
    self.newsImageView.hidden = YES;
    self.newsImageView.exclusiveTouch = YES;
    _newsImageViewHeight = 0;
    
    __block id delegate = self.delegate;
    
    if (newsModel.messageImageUrl && newsModel.messageImageUrl.length) {
        
        self.newsImageView.hidden = NO;
        
        __block UIView *newsImageView = self.newsImageView;
        self.newsImageView.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            
            if (![delegate respondsToSelector:@selector(cell:didClickImageAtImageUrl:)]) return;
            if (state == YYGestureRecognizerStateEnded) {
                UITouch *touch = touches.anyObject;
                CGPoint p = [touch locationInView:view];
                if (CGRectContainsPoint(view.bounds, p)) {
                    [delegate cell:newsImageView didClickImageAtImageUrl:newsModel.messageImageUrl];
                }
            }
        };
        
        if ([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:newsModel.messageImageUrl]) {
            self.newsImageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:newsModel.messageImageUrl];
//            _newsImageViewHeight = (_newsImageView.width * _newsImageView.image.size.height) / _newsImageView.image.size.width;
//            _newsImageView.height = _newsImageViewHeight;
        } else {
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:newsModel.messageImageUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                if (!error) {
                    self.newsImageView.image = image;
//                    _newsImageViewHeight = (_newsImageView.width * _newsImageView.image.size.height) / _newsImageView.image.size.width;
//                    _newsImageView.height = _newsImageViewHeight;
//                    if (![delegate respondsToSelector:@selector(reLoadCell:)]) return;
//                    [delegate reLoadCell:self];
                }
                
            }];

        }
    }

    if (newsModel.messageImageUrl && newsModel.messageImageUrl.length) {
        [self layoutWithImage:YES];
    } else {
        [self layoutWithImage:NO];
    }
}

- (void)layoutWithImage:(BOOL)state {
    
    _newsContentHeight = 0;
    _newsImageViewHeight = 0;
    
    NSMutableAttributedString *newsText = [[NSMutableAttributedString alloc] initWithString:_newsContent.text];
    if (newsText.length == 0) return;
    
    NewsTextLinePositionModifier *modifier = [NewsTextLinePositionModifier new];
    modifier.font = [UIFont systemFontOfSize:kWBCellTextFontSize];
    modifier.paddingTop = kWBCellPaddingText;
    modifier.paddingBottom = kWBCellPaddingText;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kWBCellContentWidth, HUGE);
    container.linePositionModifier = modifier;
    
    YYTextLayout *newsTextLayout = [YYTextLayout layoutWithContainer:container text:newsText];
    if (!newsTextLayout) return;
    
    _newsContentHeight = [modifier heightForLineCount:newsTextLayout.rowCount];
    
    self.newsContent.height = _newsContentHeight;
    self.newsContent.top = self.courseName.bottom + 10;
    
    if (state) {
        self.newsImageView.top = self.newsContent.bottom + 5;
        self.newsImageView.height = 60;
        _newsImageViewHeight = 60;
    }
}

@end
