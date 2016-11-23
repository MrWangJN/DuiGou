//
//  AnswerViewController.m
//  StudyAssisTant
//
//  Created by 王建男 on 15/4/23.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "AnswerViewController.h"

@interface AnswerViewController ()

@end

@implementation AnswerViewController
- (instancetype)initWithDatasuorce:(NSArray *)datasuorce
{
	self = [super init];
	if (self) {
		self.datasource = datasuorce;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    [self.navigationController setNavigationBarHidden:NO];
//    [self.navigationController.navigationBar setTranslucent:NO];
	[self.navigationItem setTitle:@"成绩单"];
    
	self.answerCollectionViewCellNib = [UINib nibWithNibName:@"AnswerCollectionViewCell" bundle:nil];
	[self.collectionView registerNib:self.answerCollectionViewCellNib forCellWithReuseIdentifier:@"AnswerCollectionViewCell"];
	
	[self.view addSubview:self.collectionView];
	[self.view addSubview:self.answerView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (void)quitBttonDidPress {
	[self dismissViewControllerAnimated:YES completion:^{
	}];
}

- (NSInteger )getScore {
    int score = 0;
    for (ItemModel *item in self.datasource) {
        
        if ([item.answer isEqualToString:item.my_Answer]) {
            score++;
        }
        if (item.answers.count) {
            NSMutableString *string = [NSMutableString string];
            for (NSIndexPath *indexPath in item.answers) {
                
                    [string appendFormat:@"%@", [NSString stringWithFormat:@",%c", (char)(indexPath.row + '@')]];
            }
            if (string.length) {
                NSRange range = {0, 1};
                [string deleteCharactersInRange:range];
            }
            item.my_Answer = string;
            if ([string isEqualToString:item.answer]) {
                score++;
            }
            
        }
    }
    return score * 2;
}

- (void)backButtonDidPress {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (UICollectionView *)collectionView {
	
	if (!_collectionView) {
		
		CGSize itemSize = CGSizeMake(60, 40);
		if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_6_1) {
			itemSize.height -= 64.0;
		}
		
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
		layout.minimumLineSpacing = 15;
		layout.minimumInteritemSpacing = 15;
		layout.itemSize = itemSize;
		layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(10,0,10,0);
        
		_collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
		_collectionView.delegate = self;
		_collectionView.dataSource = self;
		
		_collectionView.top = 65;
		_collectionView.left = 10.0;
		_collectionView.width = self.view.width - 18;
		_collectionView.height = self.view.height - 65;
		_collectionView.bounces = YES;
		_collectionView.scrollsToTop = NO;
		_collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
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

- (AnswerHeaderView *)answerView {
    if (!_answerView) {
        self.answerView = [[NSBundle mainBundle] loadNibNamed:@"AnswerHeaderView" owner:self options:nil][0];
        _answerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 65);
        OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
        [_answerView.UserImage setImageWithURL:onceLogin.imageURL withborderWidth:2 withColor:MAINCOLOR];
        [_answerView.userNameLabel setText:onceLogin.studentName];
        [_answerView.ScoreLabel setText:[NSString stringWithFormat:@"%ld", (long)[self getScore]]];
    }
    return _answerView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	AnswerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AnswerCollectionViewCell" forIndexPath:indexPath];
	if (indexPath.row < self.datasource.count) {
		
		ItemModel *model = self.datasource[indexPath.item];
		cell.model = model;
		[cell.answerLabel setText:[NSString stringWithFormat:@"第%ld题",indexPath.item + 1]];
	}
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	RepeatAnswerViewController *repeatAnswerViewController = [[RepeatAnswerViewController alloc] initWithDatasource:self.datasource index:indexPath.item];
	
    [self.navigationController pushViewController:repeatAnswerViewController animated:YES];
}

@end
