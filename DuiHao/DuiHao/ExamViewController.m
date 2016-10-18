//
//  ExamViewController.m
//  StudyAssisTant
//
//  Created by 王建男 on 15/4/24.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "ExamViewController.h"

@interface ExamViewController ()

@end

@implementation ExamViewController

-(instancetype)initWithCouse:(Course *)couse withExam:(ExamModel *)examModel {
    
    self = [super init];
    if (self) {
        self.course = couse;
        self.examType = OnlineExam;
        self.examModel = examModel;
        [self.datasource addObjectsFromArray:examModel.sel];
        [self.datasource addObjectsFromArray:examModel.multiSelect];
        [self.datasource addObjectsFromArray:examModel.judgement];
    }
    return self;
}

- (instancetype)initWithAllCouse:(AllResult *)allResult {
    
    self = [super init];
    if (self) {
        self.examType = ExamText;
        self.allResult = allResult;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor whiteColor];
   
    if (self.examType == OnlineExam) {
        
//        OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
//        
//        NSDictionary *dic = @{TEACHERALIASNAME : self.course.teacherAliasName, COURSEALIAS : self.course.courseAlias, SCHOOLNUMBER : onceLogin.schoolNumber, STUDENTID : onceLogin.studentID};
//        [KVNProgress showWithStatus:@"正在获取考试题"];
//        [SANetWorkingTask requestWithPost:[SAURLManager isOpenExam] parmater:dic block:^(id result) {
//            
//            [KVNProgress dismiss];
//            if ([result[@"flag"] isEqualToString:@"002"]) {
//                [KVNProgress showErrorWithStatus:@"您已经提交过本次试题"];
//                [self.navigationController popViewControllerAnimated:YES];
//                
//            }
//            if ([result[@"flag"] isEqualToString:@"004"]) {
//                [KVNProgress showErrorWithStatus:@"暂未开通本次考试"];
//                [self.navigationController popViewControllerAnimated:YES];
//                
//            }
//            if ([result[@"flag"] isEqualToString:@"001"]) {
//                self.examModel = [[ExamModel alloc] initWithDictionary:result];
//                [self.datasource addObjectsFromArray:self.examModel.sel];
//                [self.datasource addObjectsFromArray:self.examModel.multiSelect];
//                [self.datasource addObjectsFromArray:self.examModel.judgement];
//                [self.examHeader setText:1 withCount:self.datasource.count];
//                [self.collectionView reloadData];
//                
//                if (!self.examModel.examId.length) {
//                    [self.navigationController popViewControllerAnimated:YES];
//                }
//                
//                NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
//                for (int i = 1; i <= self.datasource.count; i++) {
//                    [array addObject:[NSString stringWithFormat:@"%d", i]];
//                }
//                [self.sliderView setArray:array];
//                [self.examHeader start:self.examModel.examLength.intValue];
//            }
//        }];
        [self.examHeader setText:1 withCount:self.datasource.count];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (int i = 1; i <= self.datasource.count; i++) {
            [array addObject:[NSString stringWithFormat:@"%d", i]];
        }
        [self.sliderView setArray:array];
        [self.examHeader start:self.examModel.examLength.intValue];
        
    } else {
        [self getDataSourceWithResult:self.allResult];
    }
    [self.navigationController.navigationBar setHidden:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tabBarController.tabBar setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(programDidBack)name:UIApplicationDidBecomeActiveNotification object:nil];
    
    
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
    [self.view addSubview:self.examHeader];
    [self.view addSubview:self.sliderView];
}

#pragma mark - private

- (NSMutableArray *)datasource {
    if (!_datasource) {
        self.datasource = [NSMutableArray arrayWithCapacity:0];
    }
    return _datasource;
}

- (NSMutableArray *)wrongDataSource {
    if (!_wrongDataSource) {
        self.wrongDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _wrongDataSource;
}

- (SliderView *)sliderView {
    if (!_sliderView) {
        self.sliderView = [[NSBundle mainBundle] loadNibNamed:@"SliderView" owner:self options:nil][0];
        _sliderView.frame = CGRectMake(0, self.view.height - self.view.width / 10, self.view.width, self.view.width / 10);
        _sliderView.delegate = self;
    }
    return _sliderView;
}

- (ExamHeaderView *)examHeader {
    if (!_examHeader) {
        self.examHeader = [[NSBundle mainBundle] loadNibNamed:@"ExamHeaderView" owner:self options:nil][0];
        _examHeader.frame = CGRectMake(0, 0, self.view.width, 64);
        _examHeader.delegate = self;
    }
    return _examHeader;
}

- (void)getDataSourceWithResult:(AllResult *)result {
    if (result.selectQuestion.count >= 80) {
        [self.randomSet removeAllObjects];
        for (int i = 0; i < 80; i++) {
            NSInteger index = [self getRandom:80];
            [self.datasource addObject:result.selectQuestion[index]];
        }
    }
    if (result.multiSelectQuestion.count >= 10) {
        [self.randomSet removeAllObjects];
        for (int i = 0; i < 10; i++) {
            NSInteger index = [self getRandom:10];
            [self.datasource addObject:result.multiSelectQuestion[index]];
        }
    }
    if (result.judgeQuestion.count >= 10) {
        [self.randomSet removeAllObjects];
        for (int i = 0; i < 10; i++) {
            NSInteger index = [self getRandom:10];
            [self.datasource addObject:result.judgeQuestion[index]];
        }
    }
    if (self.datasource.count == 100) {
        
        [self.examHeader start:60];
        [self.examHeader setText:1 withCount:self.datasource.count];
        
        [self.collectionView reloadData];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        [KVNProgress showErrorWithStatus:@"习题数量未达到全真模拟要求"];
    }
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (int i = 1; i <= self.datasource.count; i++) {
        [array addObject:[NSString stringWithFormat:@"%d", i]];
    }
    [self.sliderView setArray:array];
}

- (int)getScore {
    
    int score = 0;
    NSMutableArray *sel = [NSMutableArray arrayWithCapacity:0];
    for (ItemModel *item in self.examModel.sel) {
        
        if ([item.answer isEqualToString:item.my_Answer]) {
            score++;
        } else {
            if (item.my_Answer.length) {
                NSDictionary *dic = @{@"answer":item.my_Answer, @"id": item.questionId};
                [sel addObject:dic];
            }
        }
    }
    [self.wrongDataSource addObject:@{@"sel": sel}];
    
    NSMutableArray *multiSelect = [NSMutableArray arrayWithCapacity:0];
    for (ItemModel *item in self.examModel.multiSelect) {
        NSMutableString *string = [NSMutableString string];
        
        for (NSIndexPath *indexPath in item.answers) {
            
            if (indexPath.row == 1) {
                [string appendString:@"/A"];
            } else if (indexPath.row == 2) {
                [string appendString:@"/B"];
            } else if (indexPath.row == 3 ) {
                [string appendString:@"/C"];
            } else if (indexPath.row == 4 ) {
                [string appendString:@"/D"];
            } else if (indexPath.row == 5 ) {
                [string appendString:@"/E"];
            } else if (indexPath.row == 6 ) {
                [string appendString:@"/F"];
            } else if (indexPath.row == 7 ) {
                [string appendString:@"/G"];
            } else if (indexPath.row == 8 ) {
                [string appendString:@"/H"];
            } else if (indexPath.row == 9 ) {
                [string appendString:@"/I"];
            }
        }
        if (string.length) {
            NSRange range = {0, 1};
            [string deleteCharactersInRange:range];
        }
        
        if ([string isEqualToString:item.answer]) {
            score++;
        } else {
            if (string.length) {
                NSDictionary *dic = @{@"answer": string, @"id": item.questionId};
                [multiSelect addObject:dic];
            }
        }
    }
    [self.wrongDataSource addObject:@{@"multiSelect": multiSelect}];
    
    NSMutableArray *judgement = [NSMutableArray arrayWithCapacity:0];
    for (ItemModel *item in self.examModel.judgement) {
        if ([item.answer isEqualToString:item.my_Answer]) {
            score++;
        } else {
            if (item.my_Answer.length) {
                NSDictionary *dic = @{@"answer": item.my_Answer, @"id": item.questionId};
                [judgement addObject:dic];
            }
        }
    }
    [self.wrongDataSource addObject:@{@"judgement": judgement}];
    return score;
}

- (NSSet *)randomSet {
    if (!_randomSet) {
        _randomSet = [NSMutableSet setWithCapacity:0];
    }
    return _randomSet;
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

- (NSInteger )getRandom:(NSInteger )count {
    
    if (count) {
        NSInteger index = arc4random() % count;
        
        NSInteger number = self.randomSet.count;
        
        [self.randomSet addObject:[NSNumber numberWithInteger:index]];
        if (self.randomSet.count > number) {
            return index;
        }
        
        return [self getRandom:count];
    }
    return 0;
}

- (NSString *)getNowTime {
    
    NSDate *senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}

- (void)programDidBack {
    if (self.examType == OnlineExam) {
        [KVNProgress showErrorWithStatus:@"成绩已自动提交"];
        [self upDataScore];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    }
}

#pragma mark - UICollectionViewDelegate

- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

        ItemModel *model = self.datasource[indexPath.item];
        if (model.type == Select) {
            SelectCollectionViewCell *selectCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelectCollectionViewCell" forIndexPath:indexPath];
            selectCell.isExam = YES;
            if (self.datasource.count > indexPath.row) {
                selectCell.delegate = self;
                selectCell.itemModel = model;
                selectCell.isExam = YES;
                return selectCell;
            }
            
        } else if(model.type == JudgeMent) {
            
            JudgeMentModelCollectionViewCell *judgeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JudgeMentModelCollectionViewCell" forIndexPath:indexPath];
            judgeCell.isExam = YES;
            if (self.datasource.count > indexPath.row) {
                judgeCell.itemModel = model;
                judgeCell.delegate = self;
                judgeCell.isExam = YES;
                return judgeCell;
            }
        }else if (model.type == Multil) {
            MultiSelCollectionViewCell *multiSelCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MultiSelCollectionViewCell" forIndexPath:indexPath];
            multiSelCell.isExam = YES;
            multiSelCell.delegate = self;
            if (self.datasource.count > indexPath.row) {
                ItemModel *itemModel = self.datasource[indexPath.row];
                multiSelCell.itemModel = itemModel;
                return multiSelCell;
            }
        } else if (model.type == ShortAnswer) {
            ShortAnswerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShortAnswerCollectionViewCell" forIndexPath:indexPath];
            cell.isExam = YES;
            if (self.datasource.count > indexPath.row) {
                ItemModel *model = self.datasource[indexPath.row];
                cell.delegate = self;
                cell.itemModel = model;
                return cell;
            }
        } else if (model.type == FillBank) {
            FillBankOrderCollectionViewCell *fillBankCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FillBankOrderCollectionViewCell" forIndexPath:indexPath];
            fillBankCell.isExam = YES;
            if (self.datasource.count > indexPath.row) {
                ItemModel *fillBankModel = self.datasource[indexPath.row];
                fillBankCell.delegate = self;
                fillBankCell.itemModel = fillBankModel;
                return fillBankCell;
            }
        }
    return nil;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self.examHeader setText:(scrollView.contentOffset.x / self.view.width + 1) withCount:self.datasource.count];

    if (self.datasource.count <= 3) {
        [self.sliderView selectIndex:scrollView.contentOffset.x / self.view.width];
        return;
    }
    if ((scrollView.contentOffset.x / self.view.width) > 2 && (scrollView.contentOffset.x / self.view.width) < self.datasource.count - 3) {
        [self.sliderView.scrollView setContentOffset:CGPointMake(self.view.width / 6 * (scrollView.contentOffset.x / self.view.width - 2) - 30, 0) animated:YES];
    } else if ((scrollView.contentOffset.x / self.view.width) == 0) {
        [self.sliderView.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if ((scrollView.contentOffset.x / self.view.width) == (self.datasource.count - 1)) {
        [self.sliderView.scrollView setContentOffset:CGPointMake(self.view.width / 6 * (self.datasource.count - 6), 0) animated:YES];

    }
        
    [self.sliderView selectIndex:scrollView.contentOffset.x / self.view.width];
}

#pragma mark - ExamHeaderViewDelegate

- (void)upDataScore {
    
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    if (self.examModel.examId.length) {
        NSDictionary *dic = @{EXAMSETID: self.examModel.examId, ORGANIZATIONCODE: onceLogin.organizationCode, TEACHERALIASNAME: self.course.teacherName, COURSEALIAS: self.course.courseName, STUDENTID: onceLogin.studentID, SCORE: [NSString stringWithFormat:@"%d", [self getScore]], WRONG: self.wrongDataSource};
        self.examModel.examId = nil;
        [KVNProgress showWithStatus:@"正在上传成绩"];
        [SANetWorkingTask requestWithPost:[SAURLManager uploadScore] parmater:dic blockOrError:^(id result, NSError *error) {
            
            [KVNProgress dismiss];
            
            if (error || ![result[@"flag"] isEqualToString:@"001"]) {
                SCLAlertView *errorView = [[SCLAlertView alloc] init];
                [errorView addButton:@"确定" actionBlock:^{
                    self.examModel.examId = dic[EXAMSETID];
                    [self upDataScore];
                }];
                [errorView addButton:@"取消" actionBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [errorView showError:self title:@"上传成绩失败" subTitle:@"点击取消您本次将没有任何成绩" closeButtonTitle:nil duration:0.0f];
            } else {
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                [alert addButton:@"确定" actionBlock:^(void) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alert showSuccess:self title:@"上传成功" subTitle:[NSString stringWithFormat:@"您本次成绩为%@分", dic[SCORE]] closeButtonTitle:nil duration:0.0f];
            }
        }];
    }
//    else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

- (void)updata {
    if (self.examType == OnlineExam) {
        [self upDataScore];
    } else {
        AnswerViewController *answerViewController = [[AnswerViewController alloc] initWithDatasuorce:self.datasource];
        [self.navigationController pushViewController:answerViewController animated:YES];
    }

}

- (void)submitCanUp {
    if (self.examType == OnlineExam) {
        NSInteger count = 0;
        for (ItemModel *itemModel in self.datasource) {
            if (itemModel.my_Answer.length || itemModel.answers.count) {
                count++;
            }
        }
        if (self.datasource.count == count) {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert addButton:@"确定" actionBlock:^(void) {
                [self upDataScore];
                [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
            }];
            [alert addButton:@"取消" actionBlock:^(void) {
                return ;
            }];
            [alert showWarning:self title:@"警告" subTitle:@"已完成所有题目是否继续" closeButtonTitle:nil duration:0.0f];
        } else {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert addButton:@"确定" actionBlock:^(void) {
                [self upDataScore];
                [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
                
            }];
            [alert addButton:@"取消" actionBlock:^(void) {
                return ;
            }];
            [alert showWarning:self title:@"警告" subTitle:@"存在未完成题目是否继续" closeButtonTitle:nil duration:0.0f];
        }
    } else {
        AnswerViewController *answerViewController = [[AnswerViewController alloc] initWithDatasuorce:self.datasource];
        [self.navigationController pushViewController:answerViewController animated:YES];
    }
}

#pragma mark - SliderViewDelegate
- (void)buttonDidPressWithIndex:(NSInteger)index {
    [self.collectionView setContentOffset:CGPointMake(self.view.width * index, 0) animated:NO];
    [self.examHeader setText:index + 1 withCount:self.datasource.count];
}

@end
