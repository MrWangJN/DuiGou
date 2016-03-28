//
//  SASubjectViewController.m
//  StudyAssisTant
//
//  Created by 王建男 on 15/3/9.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SASubjectViewController.h"

@interface SASubjectViewController ()

@end

@implementation SASubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - private

- (UICollectionView *)collectionView {
	
	if (!_collectionView) {
		
		CGSize itemSize = [UIScreen mainScreen].bounds.size;
		if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_6_1) {
			itemSize.height -= 64.0;
		}
		
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
		layout.minimumLineSpacing = 0;
		layout.minimumInteritemSpacing = 0;
		layout.itemSize = itemSize;
		layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		
		_collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
		_collectionView.delegate = self;
		_collectionView.dataSource = self;
		
		_collectionView.bounces = YES;
		_collectionView.scrollsToTop = NO;
		_collectionView.pagingEnabled = YES;
		_collectionView.showsHorizontalScrollIndicator = NO;
		_collectionView.backgroundColor = [UIColor whiteColor];
		
		if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
			_collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		} else {
			_collectionView.autoresizingMask = UIViewAutoresizingNone;
			_collectionView.top -= 64.0;
		}
	}
	
	return _collectionView;
}


@end
