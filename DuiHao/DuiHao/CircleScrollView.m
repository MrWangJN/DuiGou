//
//  CircleScrollView.m
//  ColloctionView循环滚动控件
//
//  Created by caokun on 16/1/28.
//  Copyright © 2016年 caokun. All rights reserved.
//

#import "CircleScrollView.h"
#import "CircleViewCell.h"

@interface CircleScrollView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *images;              // 图片数组
@property (strong, nonatomic) NSArray *textes;              // 文字数组
@property (assign, nonatomic) NSInteger imageCount;         // 数量
@property (strong, nonatomic) NSMutableArray *cellData;     // 模型数组
// 模型数组开 100 组, 每组 n 张图片id, NSInteger 8 字节, 总大小 800n 个字节
// collectionView 停留在第 50 组模型那, 每次动画停止, 手动设置回第 50 组

@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UILabel *numberL;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSLock *mLock;

@end

@implementation CircleScrollView

static NSString *CollectionCellID = @"CollectionCellID";

-(void)awakeFromNib {
    [super awakeFromNib];
    [self initV];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initV];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = self.bounds.size;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.frame = self.bounds;
    [self.collectionView setCollectionViewLayout:layout];
}

- (void)initV {
    // 初始化 collectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = self.bounds.size;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.alwaysBounceHorizontal = YES;
    self.collectionView.alwaysBounceVertical = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[CircleViewCell class] forCellWithReuseIdentifier:CollectionCellID];       // 注册 cell 重用
    [self addSubview:self.collectionView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 30, self.bounds.size.width, 30)];
    self.pageControl.tag = 100;
    self.pageControl.userInteractionEnabled = NO;
    [self addSubview:self.pageControl];
    [self bringSubviewToFront:self.pageControl];
    self.backgroundColor = [UIColor whiteColor];
    self.mLock = [[NSLock alloc] init];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CircleViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionCellID forIndexPath:indexPath];
    NSInteger index = [_cellData[indexPath.row] integerValue];
    if (_images && _images.count) {
        if ([_images[index] isKindOfClass:[NSString class]]) {
            cell.imageUrl = _images[index];
        } else {
            cell.image = _images[index];
        }
    } else {
        cell.model = _textes[index];
    }
    cell.index = index;

    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 动画停止, 重新定位到第 50 组模型
    int inc = ((int)(scrollView.contentOffset.x / scrollView.frame.size.width)) % _imageCount;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:50 * _imageCount + inc inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    // 设置 PageControl
    self.pageControl.currentPage = inc;
    if (self.numberL) {
        [self.numberL setText:[NSString stringWithFormat:@"%d/%ld", inc + 1, _imageCount]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CircleViewCell *cell = (CircleViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(didClickImageAtIndex:scrollView:)]) {
        [self.delegate didClickImageAtIndex:cell.index scrollView:self];
    }
}

- (void)setDuringTime:(NSTimeInterval)duringTime {
    _duringTime = duringTime;
    if (duringTime < 0.001) {
        return ;
    }
    [self closeTimer];
    [self openTimer];
}

- (void)textes:(NSArray *)textes {
    [self.mLock lock];
    [self closeTimer];
    
    if (!textes.count) {
        return;
    }
    
    _textes = textes;
    _imageCount = textes.count;
    
    // 生成数据源
    self.cellData = [[NSMutableArray alloc] init];
    for (int i=0; i<100; i++) {
        for (int j=0; j<_imageCount; j++) {
            [self.cellData addObject:@(j)];
        }
    }
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:50 * _imageCount inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    // 设置 PageControl
//    self.pageControl.hidden = _imageCount > 1 ? NO : YES;
//    self.pageControl.numberOfPages = _imageCount;
//    self.pageControl.currentPage = 0;
    
    if (!_numberL) {
        self.numberL = [[UILabel alloc] init];
        
        self.numberL.top = self.bottom - 20;
        self.numberL.width = 40;
        self.numberL.height = 15;
        self.numberL.right = self.right;
        self.numberL.textAlignment = NSTextAlignmentRight;
        
        [self.numberL setFont:[UIFont systemFontOfSize:10]];
        [self.numberL setText:[NSString stringWithFormat:@"1/%ld", _imageCount]];
        [self addSubview:self.numberL];
    }
    
    [self openTimer];
    [self.mLock unlock];
}

- (void)images:(NSArray *)images {
    [self.mLock lock];
    [self closeTimer];
    
    _images = images;
    _imageCount = images.count;
    
    // 生成数据源
    self.cellData = [[NSMutableArray alloc] init];
    for (int i=0; i<100; i++) {
        for (int j=0; j<_imageCount; j++) {
            [self.cellData addObject:@(j)];
        }
    }
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:50 * _imageCount inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    // 设置 PageControl
    self.pageControl.hidden = _imageCount > 1 ? NO : YES;
    self.pageControl.numberOfPages = _imageCount;
    self.pageControl.currentPage = 0;
    
    [self openTimer];
    [self.mLock unlock];
}

- (void)closeTimer {
    if (self.timer) {
        [self.timer invalidate];
    }
}

- (void)openTimer {
    if (_duringTime > 0.8) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:_duringTime target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
}

- (void)onTimer {
    if (self.cellData.count > 0) {
        NSArray *array = [self.collectionView indexPathsForVisibleItems];
        if (array.count == 0) return ;
        
        NSIndexPath *indexPath = array[0];
        NSInteger row = indexPath.row;
        
        if (row % _imageCount == 0) {
            row = 50 * _imageCount;         // 重新定位
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        self.pageControl.currentPage = (row + 1) % _imageCount;
        if (self.numberL) {
            [self.numberL setText:[NSString stringWithFormat:@"%ld/%ld", (row + 1) % _imageCount + 1, _imageCount]];
        }
    }
}

@end

