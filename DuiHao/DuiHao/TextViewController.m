//
//  TextViewController.m
//  StudyAssisTant
//
//  Created by 王建男 on 15/3/20.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "TextViewController.h"
#import "YYPhotoGroupView.h"
#import "FirstPromptView.h"

@interface TextViewController ()

@property (nonatomic, assign) BOOL collectState;
@property (nonatomic, assign) int useTimer;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) Course *course;

@end

@implementation TextViewController

- (instancetype)initWithType:(CollectionViewType )collectionViewType WithTime:(int )examTime {
	self = [super init];
	if (self) {
		self.examTime = examTime;
        self.collectState = NO;
		self.collectionViewType = collectionViewType;
	}
	return self;
}

- (instancetype)initWithType:(CollectionViewType )collectionViewType withDatasource:(NSArray *)datasource withCourse:(Course *)course{
	self = [super init];
	if (self) {
		self.examTime = 1;
        self.collectState = NO;
		self.collectionViewType = collectionViewType;
        self.datasource = [NSMutableArray arrayWithArray:datasource];
        self.course = course;
    }
	return self;
}

- (instancetype)initWithType:(CollectionViewType )collectionViewType withDatasource:(NSArray *)datasource withCollect:(BOOL) collectState withCourse:(Course *)course{
    self = [super init];
    if (self) {
        self.examTime = 1;
        self.collectState = collectState;
        self.collectionViewType = collectionViewType;
        self.datasource = [NSMutableArray arrayWithArray:datasource];
        self.course = course;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"练习页面"]; // 页面统计
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"练习页面"]; // 页面统计
    
    if (_timer) {
        dispatch_source_cancel(_timer);
        // 上传时间
        
        if (self.course.courseId && self.useTimer > 60) {
            OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
            
            [SANetWorkingTask requestWithPost:[SAURLManager studentCourseScore] parmater:@{STUDENTID: onceLogin.studentID, COURSEID:self.course.courseId, ADDSCOREFLAG:ADDTIME, TIME:[NSString stringWithFormat:@"%d", self.useTimer * 1000]} block:^(id result) {
            }];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setTranslucent:NO];
//    [self.tabBarController.tabBar setHidden:YES];

    [self.navigationItem setRightBarButtonItem:self.rightItem];
    
    if (self.collectState) {
        [self beginApp];
        return;
    }
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert addButton:@"顺序练习" actionBlock:^(void) {
        [self beginApp];
        [self beginTimer];
    }];
    [alert addButton:@"随机练习" actionBlock:^(void) {
        
        switch (self.collectionViewType) {
            case SelectOrder:
                self.collectionViewType = SelectRandom;
                break;
             
            case MultiSelect:
                self.collectionViewType = MultiSelectRandom;
                break;
            case JudgeMentOrder:
                self.collectionViewType = JudgeMentRandom;
                break;
            case FillBankOrder:
                self.collectionViewType = FillBankRandom;
                break;
            case ShortAnswerOrder:
                self.collectionViewType = ShortAnswerRandom;
                break;
            default:
                break;
        }
        
        [self beginApp];
        [self beginTimer];

    }];
    [alert showEdit:self title:@"请选择练习方式" subTitle:@"顺序出题或者随机打乱顺序出题" closeButtonTitle:nil duration:0.0f];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(programDidBack)name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(programBack)name:UIApplicationDidEnterBackgroundNotification object:nil];
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

- (void)programDidBack {
    [self beginTimer];
}

- (void)programBack {
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - private


- (void)beginApp {
    
    if (self.collectionViewType == SelectRandom || self.collectionViewType == MultiSelectRandom || self.collectionViewType == FillBankRandom || self.collectionViewType == ShortAnswerRandom || self.collectionViewType == JudgeMentRandom) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < self.datasource.count; i++) {
            NSInteger index = [self getRandom:self.datasource.count];
            [array addObject:self.datasource[index]];
        }
        self.datasource = array;
    }

    
    [self setTitle];
    
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
        [alert showWarning:self title:@"警告" subTitle:@"本练习题无法判断对错，请自行查看答案" closeButtonTitle:@"确定" duration:0.0f];
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (![defaults boolForKey:@"Text"]) {
            [defaults setBool:YES forKey:@"Text"];
            [[FirstPromptView shareManager] showWithImageName:@"TextPrompt"];
        }
    }
}

- (void)beginTimer {
    
//    __block int timeout = self.useTimer;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        self.useTimer++;
    });
    dispatch_resume(_timer);
}

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
		
		_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, itemSize.width, itemSize.height) collectionViewLayout:layout];
		_collectionView.delegate = self;
		_collectionView.dataSource = self;
		
		_collectionView.bounces = YES;
		_collectionView.scrollsToTop = YES;
		_collectionView.pagingEnabled = YES;
		_collectionView.showsHorizontalScrollIndicator = NO;
		_collectionView.backgroundColor = [UIColor clearColor];
		
		if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
			_collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
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
    NSString *tableName = [NSString stringWithFormat:@"coursetable%@_%lu", item.courseId, (unsigned long)item.type];
    SAKeyValueStore *store = [[SAKeyValueStore alloc] initDBWithName:@"test.db"];
    [store createTableWithName:tableName];
    NSString *key = item.questionId;
    NSDictionary *user = [item getDistionary];
    
    if (![self changeCollect]) {
        [store putObject:user withId:key intoTable:tableName];
        [JKAlert alertText:@"收藏成功"];
    } else {
        [store deleteObjectById:key fromTable:tableName];
        [JKAlert alertText:@"取消收藏"];
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
    NSString *tableName = [NSString stringWithFormat:@"coursetable%@_%lu", item.courseId, (unsigned long)item.type];
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
        selectCell.delegate = self;
		if (self.datasource.count > indexPath.row) {
//            [selectCell setNeedsLayout];
//            [selectCell layoutIfNeeded];
			ItemModel *itemModel = self.datasource[indexPath.row];
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
//        return;
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
//    [self.collectionView scrollToTop];
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
        NSInteger index = textField.text.integerValue;
        if (self.datasource.count + 1 > index && index) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(index - 1) inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            [self.footer setText:(long)index withCount:(unsigned long)self.datasource.count];
            return;
        }
        [KVNProgress showErrorWithStatus:@"输入错误"];
    }];
    //显示
    [alert showEdit:self title:@"请输入题号" subTitle:@"单击空白处隐藏键盘" closeButtonTitle:@"取消" duration:0.0f];
}

#pragma mark - InputNumberVIewDelegate

- (void)certainButtonDidPress:(NSInteger)index {
	
	if (self.datasource.count > index) {
		
		[self.collectionView setContentOffset:CGPointMake(self.collectionView.width * (index - 1), 0) animated:YES];
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
		
//		if (self.randomSet.count == self.datasource.count) {
//
//			[KVNProgress showErrorWithStatus:@"所有习题已经练习"];
//			[self.randomSet removeAllObjects];
//		}
		
		return [self getRandom:count];
	}
	return 0;
}

-(void)textCell:(UIView *)imgView didClickImageAtImageUrl:(NSString *)imageurl {
    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    item.thumbView = imgView;
    item.largeImageURL = [NSURL URLWithString:imageurl];
    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:@[item]];
    [v presentFromImageView:imgView toContainer:self.navigationController.view animated:YES completion:nil];
}

@end
