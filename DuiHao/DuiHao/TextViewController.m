//
//  TextViewController.m
//  StudyAssisTant
//
//  Created by 王建男 on 15/3/20.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "TextViewController.h"
//#import "UIView+NMCategory.h"

@interface TextViewController ()

@end

@implementation TextViewController

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithType:(CollectionViewType )collectionViewType WithTime:(int )examTime {
	self = [super init];
	if (self) {
		self.examTime = examTime;
		self.collectionViewType = collectionViewType;
	}
	return self;
}

- (instancetype)initWithType:(CollectionViewType )collectionViewType withDatasource:(NSArray *)datasource {
	self = [super init];
	if (self) {
		self.examTime = 1;
		self.collectionViewType = collectionViewType;
        self.datasource = [NSMutableArray arrayWithArray:datasource];
        if (collectionViewType == SelectRandom || collectionViewType == MultiSelectRandom || collectionViewType == FillBankRandom || collectionViewType == ShortAnswerRandom || collectionViewType == JudgeMentRandom) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i < self.datasource.count; i++) {
                NSInteger index = [self getRandom:self.datasource.count];
                [array addObject:self.datasource[index]];
            }
            self.datasource = array;
        }
	}
	return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:YES];
    
     [self setTitle];
    
    [self.navigationItem setRightBarButtonItem:self.rightItem];
    [self changeCollect];
//	[[NSNotificationCenter defaultCenter] addObserver:self
//											 selector:@selector(programDidBack)name:UIApplicationDidBecomeActiveNotification object:nil];
	
	
    
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
	
    [self.footer setText:1 withCount:(unsigned long)self.datasource.count];
    [self.view addSubview:self.footer];
    
    if (self.collectionViewType == ShortAnswerOrder || self.collectionViewType == ShortAnswerRandom) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        //        [alert addButton:@"确定" actionBlock:^(void) {
        //        }];
        //        [alert addButton:@"取消" actionBlock:^(void) {
        //            return ;
        //        }];
        [alert showWarning:self title:@"警告" subTitle:@"本练习题无法判断对错，请自行查看答案" closeButtonTitle:@"确定" duration:0.0f];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - private

- (void)setTitle {
	
	if (self.collectionViewType == SelectOrder) {
        [self.navigationItem setTitle:@"单选题顺序练习"];
    } else if (self.collectionViewType == MultiSelect) {
        [self.navigationItem setTitle:@"多选题顺序练习"];
    } else if (self.collectionViewType == JudgeMentOrder) {
        [self.navigationItem setTitle:@"判断题顺序练习"];
	} else if (self.collectionViewType == FillBankOrder) {
        [self.navigationItem setTitle:@"填空题顺序练习"];
	} else if (self.collectionViewType == ShortAnswerOrder) {
        [self.navigationItem setTitle:@"简答题顺序练习"];
	} else if (self.collectionViewType == SelectRandom) {
        [self.navigationItem setTitle:@"单选题随机练习"];
    } else if (self.collectionViewType == MultiSelectRandom) {
        [self.navigationItem setTitle:@"多选题随机练习"];
    } else if (self.collectionViewType == JudgeMentRandom) {
        [self.navigationItem setTitle:@"判断题随机练习"];
	} else if (self.collectionViewType == FillBankRandom) {
        [self.navigationItem setTitle:@"填空题随机练习"];
	} else if (self.collectionViewType == ShortAnswerRandom) {
        [self.navigationItem setTitle:@"简答题随机练习"];
	} else if (self.collectionViewType == Collect) {
        [self.navigationItem setTitle:@"本地收藏"];
        
	}
}

- (TextViewFooter *)footer {

	if (!_footer) {
		_footer = [[NSBundle mainBundle] loadNibNamed:@"TextViewFooter" owner:self options:nil][0];
		[_footer setText:0 withCount:0];
		_footer.frame = CGRectMake(0, self.view.height - 50, 50, 50);
        [_footer setDragEnable:YES];
        [_footer setAdsorbEnable:YES];
		_footer.delegate = self;
	}
	return _footer;
}

- (NSSet *)randomSet {
	if (!_randomSet) {
		_randomSet = [NSMutableSet setWithCapacity:0];
	}
	return _randomSet;
}

- (UIBarButtonItem *)rightItem {
    if (!_rightItem) {
        self.rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"UnCollect"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonDidPress)];
    }
    return _rightItem;
}

- (UICollectionView *)collectionView {
	
	if (!_collectionView) {
		
		CGSize itemSize =  self.view.bounds.size;
		
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
		layout.minimumLineSpacing = 0;
		layout.minimumInteritemSpacing = 0;
		layout.itemSize = itemSize;
		layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		
		_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, itemSize.width, itemSize.height) collectionViewLayout:layout];
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

- (void)rightButtonDidPress {
 
    NSInteger index = self.collectionView.contentOffset.x / self.collectionView.width;
    ItemModel *item = self.datasource[index];
    NSString *tableName = [NSString stringWithFormat:@"%@_%lu", item.courseAlias, (unsigned long)item.type];
    SAKeyValueStore *store = [[SAKeyValueStore alloc] initDBWithName:@"test.db"];
    [store createTableWithName:tableName];
    NSString *key = item.questionId;
    NSDictionary *user = [item getDistionary];
    
    if (![self changeCollect]) {
        [store putObject:user withId:key intoTable:tableName];
        [KVNProgress showSuccessWithStatus:@"已成功收藏"];
    } else {
        [store deleteObjectById:key fromTable:tableName];
        [KVNProgress showSuccessWithStatus:@"已取消收藏"];
    }
    [self changeCollect];
    //    NSDictionary *queryUser = [store getObjectById:@"2" fromTable:tableName];
//    NSLog(@"query data result: %@", [store getAllItemsFromTable:tableName]);
}

- (void)quitBttonDidPress {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)pushAnswerViewController:(TextBlock)block {
	self.block = block;
}

- (void)answerOrder {
	
	if (self.collectionView.contentSize.width == self.collectionView.contentOffset.x + self.view.width) {
        [self.footer.numberOfFooter setText:@"正确"];
		[KVNProgress showErrorWithStatus:@"已经是最后一个"];
		return;
	}

	double x = self.collectionView.contentOffset.x;
	double wid = self.view.width;
	NSInteger value = (int)x % (int)wid;
	
	if (!value) {
		[self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x + self.view.width, 0) animated:YES];
	}
    [self.footer setText:self.collectionView.contentOffset.x / self.view.width + 2 withCount:(unsigned long)self.datasource.count];

}

- (void)answerRandom {
	
	NSInteger index = [self getRandom:self.datasource.count];
    [self.collectionView setContentOffset:CGPointMake(self.view.width * index, 0) animated:NO];
    [self.footer setText:index + 1 withCount:self.datasource.count];
}

- (BOOL)changeCollect {
    NSInteger index = self.collectionView.contentOffset.x / self.collectionView.width;
    if (!self.datasource.count) {
        return NO;
    }
    ItemModel *item = self.datasource[index];
    NSString *tableName = [NSString stringWithFormat:@"%@_%lu", item.courseAlias, (unsigned long)item.type];
    SAKeyValueStore *store = [[SAKeyValueStore alloc] initDBWithName:@"test.db"];
    [store createTableWithName:tableName];
    NSString *key = item.questionId;
    if ([store getObjectById:key fromTable:tableName]) {
        
        [self.rightItem setImage:[[UIImage imageNamed:@"Collect"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        return YES;
    } else {
        [self.rightItem setImage:[[UIImage imageNamed:@"UnCollect"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        return NO;
    }
}

- (NSString *)getNowTime {
	
	NSDate *senddate=[NSDate date];
	NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
	[dateformatter setDateFormat:@"YYYYMMdd"];
	NSString *locationString=[dateformatter stringFromDate:senddate];
	return locationString;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	if (self.collectionViewType == SelectRandom || self.collectionViewType == SelectOrder) {
		
		SelectCollectionViewCell *selectCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelectCollectionViewCell" forIndexPath:indexPath];
		if (self.datasource.count > indexPath.row) {
//            [selectCell setNeedsLayout];
//            [selectCell layoutIfNeeded];
			ItemModel *itemModel = self.datasource[indexPath.row];
			selectCell.delegate = self;
			selectCell.itemModel = itemModel;
			self.itemModel = itemModel;
			return selectCell;
		}
	}
	
    if (self.collectionViewType == MultiSelect || self.collectionViewType == MultiSelectRandom) {
        MultiSelCollectionViewCell *multiSelCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MultiSelCollectionViewCell" forIndexPath:indexPath];
        multiSelCell.delegate = self;
        if (self.datasource.count > indexPath.row) {
            ItemModel *itemModel = self.datasource[indexPath.row];
            multiSelCell.itemModel = itemModel;
            return multiSelCell;
        }
    }
    
	if (self.collectionViewType == JudgeMentRandom || self.collectionViewType == JudgeMentOrder) {

		JudgeMentModelCollectionViewCell *judgeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JudgeMentModelCollectionViewCell" forIndexPath:indexPath];
		
		if (self.datasource.count > indexPath.row) {
			ItemModel *judgeMentModel = self.datasource[indexPath.row];
			judgeCell.delegate = self;
			judgeCell.itemModel = judgeMentModel;
			return judgeCell;
		}
	}
	
    if (self.collectionViewType == ShortAnswerOrder || self.collectionViewType == ShortAnswerRandom) {
        ShortAnswerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShortAnswerCollectionViewCell" forIndexPath:indexPath];
        if (self.datasource.count > indexPath.row) {
            ItemModel *model = self.datasource[indexPath.row];
            cell.delegate = self;
            cell.itemModel = model;
            return cell;
        }
    }
    
	if (self.collectionViewType == FillBankOrder || self.collectionViewType == FillBankRandom) {
		FillBankOrderCollectionViewCell *fillBankCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FillBankOrderCollectionViewCell" forIndexPath:indexPath];
		
		if (self.datasource.count > indexPath.row) {
			ItemModel *fillBankModel = self.datasource[indexPath.row];
			fillBankCell.delegate = self;
            fillBankCell.itemModel = fillBankModel;
			return fillBankCell;
		}
	}
	
	return nil;
}

#pragma mark - SelectCollectionViewCellDelegate 

- (void)selectCorrectAnswer {
	
//	if (self.collectionViewType == SelectRandom) {
//		[self answerRandom];
//		return;
//	}
//    if (self.collectionViewType == JudgeMentRandom) {
//        [self answerRandom];
//        return;
//    }
//    if (self.collectionViewType == MultiSelectRandom) {
//        [self answerRandom];
//    }
	[self answerOrder];
}

- (void)selectWrongAnswer {
    [self.footer.numberOfFooter setText:@"错误"];
}

#pragma mark - FillBankOrderCollectionViewCellDelegate

- (void)fillBankCorrectAnswer {
	
	if (self.collectionViewType == FillBankRandom || self.collectionViewType == ShortAnswerRandom) {
		[self answerRandom];
		return;
	}
	[self answerOrder];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	
    [self.footer setText:scrollView.contentOffset.x / self.view.width + 1 withCount:(unsigned long)self.datasource.count];

    [self changeCollect];
}

#pragma mark - TextViewFooterDelegate


- (void)numberButtonHaveDidPress {
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    UITextField *textField = [alert addTextField:@"题号"];
    textField.delegate = self;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.returnKeyType = UIReturnKeyDone;
    //直接调用,类似于Delegate
    [alert addButton:@"确定" actionBlock:^(void) {
        NSLog(@"Text value: %@", textField.text);
        NSInteger index = textField.text.integerValue;
        if (self.datasource.count > index && index) {
            
            [self.collectionView setContentOffset:CGPointMake(self.view.width * (index - 1), 0) animated:YES];
            [self.footer setText:(long)index withCount:(unsigned long)self.datasource.count];
            return;
        }
        [KVNProgress showErrorWithStatus:@"输入错误"];
    }];
//    //显示
    [alert showEdit:self title:@"请输入题号" subTitle:@"单击本提示框隐藏键盘" closeButtonTitle:@"取消" duration:0.0f];
}

#pragma mark - InputNumberVIewDelegate

- (void)certainButtonDidPress:(NSInteger)index {
	
	if (self.datasource.count > index) {
		
		[self.collectionView setContentOffset:CGPointMake(self.view.width * (index - 1), 0) animated:YES];
        [self.footer setText:(long)index withCount:(unsigned long)self.datasource.count];
		return;
	}
	[KVNProgress showErrorWithStatus:@"输入错误"];
}

- (NSInteger )getRandom:(NSInteger )count {
	
	if (count) {
		NSInteger index = arc4random() % count;
		
		NSInteger number = self.randomSet.count;
		
		[self.randomSet addObject:[NSNumber numberWithInteger:index]];
		if (self.randomSet.count > number) {
			return index;
		}
		
		if (self.randomSet.count == self.datasource.count) {

			[KVNProgress showErrorWithStatus:@"所有习题已经练习"];
			[self.randomSet removeAllObjects];
		}
		
		return [self getRandom:count];
	}
	return 0;
}


@end
