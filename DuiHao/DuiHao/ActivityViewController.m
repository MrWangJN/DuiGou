//
//  ActivityViewController.m
//  DuiHao
//
//  Created by wjn on 2017/7/20.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityFlowLayout.h"
#import "OnceLogin.h"
#import "ActivityModel.h"
#import "ActivityCollectionViewCell.h"
#import "QRCodeViewController.h"

@interface ActivityViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, ActivityCollectionViewCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"活动"];
    
    // 无数据时显示的提示图片
    [self setHintImage:@"NoCourse" whihHight:65];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self getData];
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getData {
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    
    if (!onceLogin.studentID) {
        return;
    }
    
    [JKAlert alertWaitingText:@"正在加载"];
    
    [SANetWorkingTask requestWithPost:[SAURLManager activityList] parmater:@{STUDENTID: onceLogin.studentID} blockOrError:^(id result, NSError *error) {
        
        [JK_M dismissElast];
        
        if (error) {
            [JKAlert alertText:@"请求失败"];
            return ;
        }
        
        if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
            
            [self.datasource removeAllObjects];
            
            result = result[RESULT][LISTS];
            
            for (NSDictionary *dic in result) {
                ActivityModel *activityModel = [[ActivityModel alloc] initWithRawModel:dic];
                [self.datasource addObject:activityModel];
            }
            
            
            if (!self.datasource.count) {
                [self hiddenHint];
            } else {
                [self noHiddenHint];
                [self.collectionView reloadData];
            }
        } else {
            [self hiddenHint];
        }

        
    }];
}

- (NSMutableArray *)datasource {
    if (!_datasource) {
        self.datasource = [NSMutableArray arrayWithCapacity:0];
    }
    return _datasource;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        CGSize itemSize =  self.view.bounds.size;
        
        ActivityFlowLayout *layout = [[ActivityFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 64 - 60 - 30);
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, itemSize.width, itemSize.height) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.clipsToBounds = YES;
        _collectionView.bounces = YES;
        _collectionView.scrollsToTop = YES;
        // _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ActivityCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ActivityCollectionViewCell class])];
        
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
            _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
        } else {
            _collectionView.autoresizingMask = UIViewAutoresizingNone;
            _collectionView.top -= 64.0;
        }
    }
    
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ActivityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ActivityCollectionViewCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    cell.activityModel = self.datasource[indexPath.item];
    
    return cell;
}

#pragma mark - ActivityCollectionViewCellDelegate

- (void)signIn {
    QRCodeViewController *qrCode = [[QRCodeViewController alloc] init];
    [self presentViewController:qrCode animated:YES completion:^{
    }];
}

#pragma mark - 重载父类方法

- (void)hiddenHint {
    [super hiddenHint];
    self.collectionView.hidden = YES;
}

- (void)noHiddenHint {
    [super noHiddenHint];
    self.collectionView.hidden = NO;
}

- (void)backBtuDidPress {
    [self getData];
}

@end
