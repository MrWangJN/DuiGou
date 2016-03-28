//
//  SliderView.h
//  StudyAssisTant
//
//  Created by wjn on 15/10/6.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"

@protocol SliderViewDelegate;

@interface SliderView : UIView<UIScrollViewDelegate>

@property (strong, nonatomic) NSArray *array;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *buttonArray;

@property (assign, nonatomic) NSInteger select;

@property (assign, nonatomic) id<SliderViewDelegate>delegate;

- (void)selectIndex:(NSInteger ) index;

@end

@protocol SliderViewDelegate <NSObject>

- (void)buttonDidPressWithIndex:(NSInteger )index;

@end