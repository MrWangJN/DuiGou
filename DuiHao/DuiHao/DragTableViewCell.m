//
//  DragTableViewCell.m
//  DuiHao
//
//  Created by wjn on 2016/12/28.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "DragTableViewCell.h"
#import "DragCollectionViewCell.h"

@interface DragTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation DragTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView addSubview:self.collectionView];
    [self.contentView sendSubviewToBack:self.contentView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSArray *)images {
    return @[@"Funcourse", @"Exam", @"Homework", @"Classroom", @"Syllabus", @"Video", @"Vote", @"Apply"];
}

- (NSArray *)titles {
    return @[@"课程", @"考试", @"作业", @"课堂", @"课程表", @"视频", @"投票", @"报名"];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        CGSize itemSize =  [UIScreen mainScreen].bounds.size;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        layout.itemSize = CGSizeMake((itemSize.width - 15) / 4, (itemSize.width - 15) / 4);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, itemSize.height) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.bounces = YES;
        _collectionView.scrollsToTop = YES;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"DragCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"dragCollectionViewCell"];
        
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
            _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
        } else {
            _collectionView.autoresizingMask = UIViewAutoresizingNone;
            _collectionView.top -= 64.0;
        }
    }
    
    return _collectionView;

}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DragCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"dragCollectionViewCell" forIndexPath:indexPath];
    [cell setImage:self.images[indexPath.item] text:self.titles[indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(dragTableViewCellDidSelect:)]) {
        [self.delegate dragTableViewCellDidSelect:indexPath.item];
    }
    
}

@end
