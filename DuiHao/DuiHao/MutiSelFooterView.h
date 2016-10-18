//
//  MutiSelFooterView.h
//  StudyAssisTant
//
//  Created by wjn on 15/9/27.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"
#import "YYKit.h"
#import "YYControl.h"
/**
 文本 Line 位置修改
 将每行文本的高度和位置固定下来，不受中英文/Emoji字体的 ascent/descent 影响
 */
@interface FoorterTextLinePositionModifier : NSObject <YYTextLinePositionModifier>
@property (nonatomic, strong) UIFont *font; // 基准字体 (例如 Heiti SC/PingFang SC)
@property (nonatomic, assign) CGFloat paddingTop; //文本顶部留白
@property (nonatomic, assign) CGFloat paddingBottom; //文本底部留白
@property (nonatomic, assign) CGFloat lineHeightMultiple; //行距倍数
- (CGFloat)heightForLineCount:(NSUInteger)lineCount;
@end

@protocol MutiSelFooterViewDelegate;

@interface MutiSelFooterView : UIView

@property (weak, nonatomic) IBOutlet UIButton *cerTainButton;
@property (strong, nonatomic) IBOutlet UIButton *answerBtu;
@property (strong, nonatomic) IBOutlet YYLabel *answerLabel;
@property (strong, nonatomic) IBOutlet YYLabel *analysis;
@property (strong, nonatomic) IBOutlet UIView *answerView;
@property (strong, nonatomic) IBOutlet YYControl *analysisImageView;


@property (nonatomic, assign) CGFloat answerHeight;
@property (nonatomic, assign) CGFloat analysisHeight;
@property (nonatomic, assign) CGFloat analysisImageViewHeight;

@property (assign, nonatomic) id<MutiSelFooterViewDelegate>delegate;

- (void)setanswer:(NSString *)answer withAnalysis:(NSString *)analysis withImageURL:(NSString *)url;
- (CGFloat )getFooterHeight;

@end

@protocol MutiSelFooterViewDelegate <NSObject>

/// 点击了图片
- (void)cell:(UIView *)imgView didClickImageAtImageUrl:(NSString *)imageurl;

@end
