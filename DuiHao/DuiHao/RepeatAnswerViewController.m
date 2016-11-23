//
//  RepeatAnswerViewController.m
//  StudyAssisTant
//
//  Created by 王建男 on 15/4/23.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "RepeatAnswerViewController.h"

@interface RepeatAnswerViewController ()

@end

@implementation RepeatAnswerViewController

- (instancetype)initWithDatasource:(NSArray *)datasource index:(NSInteger)index
{
	self = [super init];
	if (self) {
        for (ItemModel *model in datasource) {
            ItemModel *itemModel = [[ItemModel alloc] initWithItemModel:model];
            if (itemModel.my_Answer.length) {
                itemModel.answer = [NSString stringWithFormat:@"本题答案:%@。 您的选项:%@", model.answer, model.my_Answer];
            } else {
                itemModel.answer = [NSString stringWithFormat:@"本题答案:%@。 您未作答", model.answer];
            }
            [self.datasource addObject:itemModel];
        }
		self.index = index;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:NO];
	[self.navigationItem setTitle:@"查看选项"];
    
    self.textCollectionViewCellNib = [UINib nibWithNibName:@"TextCollectionViewCell" bundle:nil];
    self.selectCollectionViewCellNib = [UINib nibWithNibName:@"SelectCollectionViewCell" bundle:nil];
    self.judgeMentModelCollectionViewCellNib = [UINib nibWithNibName:@"JudgeMentModelCollectionViewCell" bundle:nil];
    self.fillBankOrderCollectionViewCellNib = [UINib nibWithNibName:@"FillBankOrderCollectionViewCell" bundle:nil];
    self.multiSelCollectionViewCellNib = [UINib nibWithNibName:@"MultiSelCollectionViewCell" bundle:nil];
    self.shortAnswerCollectionViewCellNib = [UINib nibWithNibName:@"ShortAnswerCollectionViewCell" bundle:nil];
    
    [self.collectionView registerNib:self.textCollectionViewCellNib forCellWithReuseIdentifier:@"TextCollectionViewCell"];
    [self.collectionView registerNib:self.selectCollectionViewCellNib forCellWithReuseIdentifier:@"SelectCollectionViewCell"];
    [self.collectionView registerNib:self.judgeMentModelCollectionViewCellNib forCellWithReuseIdentifier:@"JudgeMentModelCollectionViewCell"];
    [self.collectionView registerNib:self.fillBankOrderCollectionViewCellNib forCellWithReuseIdentifier:@"FillBankOrderCollectionViewCell"];
    [self.collectionView registerNib:self.multiSelCollectionViewCellNib forCellWithReuseIdentifier:@"MultiSelCollectionViewCell"];
    [self.collectionView registerNib:self.shortAnswerCollectionViewCellNib forCellWithReuseIdentifier:@"ShortAnswerCollectionViewCell"];
	
	[self.view addSubview:self.collectionView];
	
	[self.view addSubview:self.footer];
	
    [self.footer.numberOfFooter setText:[NSString stringWithFormat:@"%ld/%ld", (long)self.index + 1, self.datasource.count]];
    self.collectionView.contentSize = CGSizeMake(_collectionView.width * self.datasource.count, 0);
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.footer.frame = CGRectMake(0, self.view.height - 50, 50, 50);
    
    CGSize itemSize =  self.view.bounds.size;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = itemSize;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.frame = CGRectMake(0, 0, itemSize.width, itemSize.height);
    [self.collectionView setCollectionViewLayout:layout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - private

- (NSArray *)datasource {
    if (!_datasource) {
        self.datasource = [NSMutableArray arrayWithCapacity:0];
    }
    return _datasource;
}

- (TextViewFooter *)footer {
	
	if (!_footer) {
		_footer = [[NSBundle mainBundle] loadNibNamed:@"TextViewFooter" owner:self options:nil][0];
		[_footer.numberOfFooter setText:@"0/0"];
		_footer.frame = CGRectMake(0, self.view.height - 50, 50, 50);
		_footer.delegate = self;
        [_footer setDragEnable:YES];
        [_footer setAdsorbEnable:YES];
	}
	return _footer;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        CGSize itemSize =  self.view.bounds.size;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = itemSize;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, itemSize.width, itemSize.height) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.bounces = YES;
        _collectionView.scrollsToTop = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];

        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
            _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        } else {
            _collectionView.autoresizingMask = UIViewAutoresizingNone;
            _collectionView.top -= 64.0;
        }
    }
    
    return _collectionView;
}


- (void)quitBttonDidPress {
	[self dismissViewControllerAnimated:YES completion:^{
		
	}];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ItemModel *model = self.datasource[indexPath.item];
    if (model.type == Select) {
        SelectCollectionViewCell *selectCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelectCollectionViewCell" forIndexPath:indexPath];
        if (self.datasource.count > indexPath.row) {
            selectCell.itemModel = model;
            selectCell.isExam = NO;
            [selectCell answerPress];
            return selectCell;
        }
        
    } else if(model.type == JudgeMent) {
        
        JudgeMentModelCollectionViewCell *judgeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JudgeMentModelCollectionViewCell" forIndexPath:indexPath];
        judgeCell.isExam = YES;
        if (self.datasource.count > indexPath.row) {
            judgeCell.itemModel = model;
            judgeCell.isExam = NO;
            [judgeCell answerPress];
            return judgeCell;
        }
    }else if (model.type == Multil) {
        MultiSelCollectionViewCell *multiSelCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MultiSelCollectionViewCell" forIndexPath:indexPath];
        multiSelCell.isExam = NO;
        if (self.datasource.count > indexPath.row) {
            ItemModel *itemModel = self.datasource[indexPath.row];
            multiSelCell.itemModel = itemModel;
            [multiSelCell answerPress];
            return multiSelCell;
        }
    } else if (model.type == ShortAnswer) {
        ShortAnswerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShortAnswerCollectionViewCell" forIndexPath:indexPath];
        cell.isExam = NO;
        if (self.datasource.count > indexPath.row) {
            ItemModel *model = self.datasource[indexPath.row];
            cell.itemModel = model;
            return cell;
        }
    } else if (model.type == FillBank) {
        FillBankOrderCollectionViewCell *fillBankCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FillBankOrderCollectionViewCell" forIndexPath:indexPath];
        fillBankCell.isExam = NO;
        if (self.datasource.count > indexPath.row) {
            ItemModel *fillBankModel = self.datasource[indexPath.row];
            fillBankCell.itemModel = fillBankModel;
            return fillBankCell;
        }
    }
    return nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	
	[self.footer.numberOfFooter setText:[NSString stringWithFormat:@"%0.f/%lu", scrollView.contentOffset.x / self.view.width + 1, (unsigned long)self.datasource.count]];
}

#pragma mark - TextViewFooterDelegate

- (void)upTextButtonHaveDidPress {
	
	if (self.collectionView.contentOffset.x < self.view.width) {
		
		return;
	}
	
	[self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x - self.view.width, 0) animated:YES];
	
	[self.footer.numberOfFooter setText:[NSString stringWithFormat:@"%0.f/%lu", self.collectionView.contentOffset.x / self.view.width, (unsigned long)self.datasource.count]];
}

- (void)nextTextButtonHaveDidPress {
	
	if (self.collectionView.contentSize.width == self.collectionView.contentOffset.x + self.view.width) {
		
		return;
	}
	
	[self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x + self.view.width, 0) animated:YES];
	
	[self.footer.numberOfFooter setText:[NSString stringWithFormat:@"%0.f/%lu", self.collectionView.contentOffset.x / self.view.width + 2, (unsigned long)self.datasource.count]];
}

@end
