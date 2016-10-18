//
//  OptionStatusLayout.h
//  DuiHao
//
//  Created by wjn on 16/8/2.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemTitleStatusLayout.h"
#import "OptionModel.h"
@interface OptionStatusLayout : NSObject

- (instancetype)initWithOption:(NSString *)option;
- (instancetype)initWithStatus:(OptionModel *)status;
- (void)layout; ///< 计算布局

// 以下是数据
@property (nonatomic, strong) OptionModel *status;

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
