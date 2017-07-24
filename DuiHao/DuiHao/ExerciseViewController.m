//
//  ExerciseViewController.m
//  StudyAssisTant
//
//  Created by wjn on 15/9/4.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "ExerciseViewController.h"
#import "ContextMenuCell.h"
#import "RATreeView.h"
#import "CourseTableViewCell.h"
//#import "RADataObject.h"
#import "RankViewController.h"

#import "RADataObject.h"

#import "RATableViewCell.h"
#import "PPTViewController.h"
#import "CourseVideoViewController.h"

static NSString *const menuCellIdentifier = @"rotationCell";

@interface ExerciseViewController ()
<
YALContextMenuTableViewDelegate, RATreeViewDelegate, RATreeViewDataSource
>

@property (nonatomic, strong) YALContextMenuTableView* contextMenuTableView;

@property (nonatomic, strong) NSArray *menuTitles;
@property (nonatomic, strong) NSArray *menuIcons;
//
//@property (nonatomic, strong) NSArray *iconArray;

//@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) RATreeView *treeView;
@property (strong, nonatomic) NSArray *colors;

@end

@implementation ExerciseViewController

- (void)viewWillAppear:(BOOL)animated {
//    [self getExercise];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    if (self.course.courseName) {
        self.allResult = [[AllResult alloc] initWithCourseName:self.course.courseName];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
//    [self.navigationItem setTitle:self.course.courseName];
    
    [self.navigationItem setTitle:@"课程"];
    
    // 无数据时显示的提示图片
    [self setHintImage:@"NoCourse" whihHight:65];
    
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Update"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonDidPress)];
//    [self.navigationItem setRightBarButtonItem:rightItem];
    
    [self getCourse];
    [self.view addSubview:self.treeView];
    
//    [self initiateMenuOptions];
}

- (void)viewDidLayoutSubviews {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (NSMutableArray *)datasource {
    if (!_datasource) {
        self.datasource = [NSMutableArray arrayWithCapacity:0];
    }
    return _datasource;
}

- (NSArray *)colors {
    return @[COURSEFIRST, COURSESECOND, COURSETHIRD, COURSEFORTH];
}

- (void)getCourse {
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    
    if (!onceLogin.studentNumber.length) {
        return;
    }

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    path = [NSString stringWithFormat:@"%@/%@/%@", path, @"Course", onceLogin.studentID];
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    if (onceLogin.studentID.length && onceLogin.organizationCode.length) {
        if (dic) {
            
            [self.datasource removeAllObjects];
            
            
            NSArray *array = dic[RESULT][@"lists"];
            for (NSDictionary *dic in array) {
                
                Course *sonCourse = [[Course alloc] initWithDictionary:dic children:nil];
                
                RADataObject *first = [RADataObject dataObjectWithName:@"全真模拟" withCourse:sonCourse children:nil];
                RADataObject *second = [RADataObject dataObjectWithName:@"我的收藏" withCourse:sonCourse children:nil];
                RADataObject *third = [RADataObject dataObjectWithName:@"单选题" withCourse:sonCourse children:nil];
                RADataObject *fourth = [RADataObject dataObjectWithName:@"多选题" withCourse:sonCourse children:nil];
                RADataObject *fifth = [RADataObject dataObjectWithName:@"判断题" withCourse:sonCourse children:nil];
                RADataObject *six = [RADataObject dataObjectWithName:@"填空题" withCourse:sonCourse children:nil];
                RADataObject *seven = [RADataObject dataObjectWithName:@"简答题" withCourse:sonCourse children:nil];
                RADataObject *eighth = [RADataObject dataObjectWithName:@"课件" withCourse:sonCourse children:nil];
                RADataObject *ninth = [RADataObject dataObjectWithName:@"排行榜" withCourse:sonCourse children:nil];
                RADataObject *tenth = [RADataObject dataObjectWithName:@"视频" withCourse:sonCourse children:nil];
                Course *course = [[Course alloc] initWithDictionary:dic children:@[first, second, third, fourth, fifth, six, seven, eighth, tenth, ninth]];
                
                [self.datasource addObject:course];
            }
            [self.treeView reloadData];
        } else {
            [JKAlert alertWaitingText:@"正在努力加载课程"];
        }
    } else {
        [JKAlert alertWaitingText:@"正在努力加载课程"];
    }
    
    [SANetWorkingTask requestWithPost:[SAURLManager queryCourseInfo] parmater:@{ORGANIZATIONCODE: onceLogin.organizationCode, STUDENTID:onceLogin.studentID}blockOrError:^(id result, NSError *error) {
        
        [JK_M dismissElast];
        
        if (error) {
            if (!self.datasource.count || !self.datasource) {
                [self hiddenHint];
            } else {
                [self.treeView reloadData];
                [self noHiddenHint];
            }
            return ;
        }
        
        if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
            
            [self.datasource removeAllObjects];
            [UMessage removeAllTags:^(id responseObject, NSInteger remain, NSError *error) {
            }];
            
            NSDictionary *resDic = result;
            [resDic writeToFile:path atomically:YES];
            
            NSArray *array = result[RESULT][@"lists"];
            
            for (NSDictionary *dic in array) {
                
                Course *sonCourse = [[Course alloc] initWithDictionary:dic children:nil];
                
                RADataObject *first = [RADataObject dataObjectWithName:@"全真模拟" withCourse:sonCourse children:nil];
                RADataObject *second = [RADataObject dataObjectWithName:@"我的收藏" withCourse:sonCourse children:nil];
                RADataObject *third = [RADataObject dataObjectWithName:@"单选题" withCourse:sonCourse children:nil];
                RADataObject *fourth = [RADataObject dataObjectWithName:@"多选题" withCourse:sonCourse children:nil];
                RADataObject *fifth = [RADataObject dataObjectWithName:@"判断题" withCourse:sonCourse children:nil];
                RADataObject *six = [RADataObject dataObjectWithName:@"填空题" withCourse:sonCourse children:nil];
                RADataObject *seven = [RADataObject dataObjectWithName:@"简答题" withCourse:sonCourse children:nil];
                RADataObject *eighth = [RADataObject dataObjectWithName:@"课件" withCourse:sonCourse children:nil];
                RADataObject *ninth = [RADataObject dataObjectWithName:@"排行榜" withCourse:sonCourse children:nil];
                 RADataObject *tenth = [RADataObject dataObjectWithName:@"视频" withCourse:sonCourse children:nil];
                
                Course *course = [[Course alloc] initWithDictionary:dic children:@[first, second, third, fourth, fifth, six, seven, eighth, tenth, ninth]];
                [self.datasource addObject:course];
                [UMessage addTag:[NSString stringWithFormat:@"c%@%@", course.courseId,course.teachingId]
                        response:^(id responseObject, NSInteger remain, NSError *error) {
                            //add your codes
                        }];
                [UMessage addTag:[NSString stringWithFormat:@"o%@", onceLogin.organizationCode]
                        response:^(id responseObject, NSInteger remain, NSError *error) {
                            //add your codes
                        }];
            }
        
     
        } else if ([result[RESULT_STATUS] isEqualToString:RESULT_LOGIN]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            return;
        }
        
        if (!self.datasource.count || !self.datasource) {
            [self.treeView reloadData];
            [self hiddenHint];
        } else {
            [self.treeView reloadData];
            [self noHiddenHint];
        }
    }];
}

- (void)getExercise {
    
    self.allResult = [[AllResult alloc] initWithCourseName:self.course.courseName];
    
    NSDictionary *dic = @{TEACHERID : self.course.teacherId, COURSEID : self.course.courseId};
    if (!self.allResult) {
        [JKAlert alertWaitingText:@"正在获取试题"];
    
        [SANetWorkingTask requestWithPost:[SAURLManager downloadQuestion] parmater:dic block:^(id result) {
            
            [JK_M dismissElast];

            if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
                self.allResult = [[AllResult alloc] initWithDictionary:result];
                [self.allResult writeToLocal:self.course.courseName];
            } else {
                [JKAlert alertCrossText:result[ERRORMESSAGE]];
            }
        }];
    }
    if ([SAReachabilityManager sharedReachabilityManager].currentReachabilityStatus == ReachableViaWiFi) {
        [SANetWorkingTask requestWithPost:[SAURLManager downloadQuestion] parmater:dic block:^(id result) {
             [JKAlert alertWaiting:NO];
            AllResult *allResult = [[AllResult alloc] initWithDictionary:result];
            [allResult writeToLocal:self.course.courseName];
        }];
    }
}

//- (NSMutableArray *)datasource {
//    if (!_datasource) {
//        self.datasource = [NSMutableArray arrayWithObjects:@"在线考试", @"全真模拟", @"我的收藏", @"单选题练习", @"多选题练习", @"判断题练习", @"填空题练习", @"简答题练习", nil];
//    }
//    return _datasource;
//}
//
//- (NSArray *)iconArray {
//    if (!_iconArray) {
//        self.iconArray = @[@"OnlineTest", @"Imitate", @"CollectIcon", @"SingleSelection", @"MultipleChoice", @"TrueOrFalse", @"FillBlanks", @"ShortAnswer"];
//    }
//    return _iconArray;
//}

- (RATreeView *)treeView {
    if (!_treeView) {
        self.treeView = [[RATreeView alloc] initWithFrame:self.view.bounds];
        _treeView.delegate = self;
        _treeView.dataSource = self;
        _treeView.treeFooterView = [UIView new];
        _treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
        _treeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_treeView registerNib:[UINib nibWithNibName:NSStringFromClass([CourseTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CourseTableViewCell class])];
        [_treeView registerNib:[UINib nibWithNibName:NSStringFromClass([ExerciseTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ExerciseTableViewCell class])];
    }
    return _treeView;
}

//- (UITableView *)tableView {
//    if (!_tableView) {
//        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//        self.tableView.height += 44;
//        _tableView.backgroundColor = [UIColor whiteColor];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        self.exerciseTableViewCell = [UINib nibWithNibName:@"ExerciseTableViewCell" bundle:nil];
//        [_tableView registerNib:self.exerciseTableViewCell forCellReuseIdentifier:@"exerciseTableViewCell"];
//    }
//    return _tableView;
//}

//#pragma mark - UITableViewDelegate
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return CGFLOAT_MIN;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return CGFLOAT_MIN;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([tableView isKindOfClass:[YALContextMenuTableView class]]) {
//        return 65;
//    }
//    return 50;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    
//    if ([tableView isKindOfClass:[YALContextMenuTableView class]]) {
//        ContextMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier forIndexPath:indexPath];
//        
//        if (cell) {
//            cell.backgroundColor = [UIColor clearColor];
//            cell.menuTitleLabel.text = [self.menuTitles objectAtIndex:indexPath.row];
//            cell.menuImageView.image = [self.menuIcons objectAtIndex:indexPath.row];
//        }
//        
//        return cell;
//    }
//    
//    ExerciseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"exerciseTableViewCell"];
//    if (self.datasource.count > indexPath.row) {
//        cell.optionLabel.text = self.datasource[indexPath.row];
//        [cell.iconImageView setImage:[UIImage imageNamed:self.iconArray[indexPath.row]]];
//    }
//    return cell;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//    if ([tableView isKindOfClass:[YALContextMenuTableView class]]) {
//        return self.menuTitles.count;
//    }
//    
//    return self.datasource.count;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if ([tableView isKindOfClass:[YALContextMenuTableView class]]) {
//        YALContextMenuTableView *yalTB = (YALContextMenuTableView*)tableView;
//        [yalTB dismisWithIndexPath:indexPath];
//        return;
//    }
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    CollectionViewType collectionViewType = SelectOrder;
//    NSArray *dataSource;
//    
//    if (indexPath.row == OnlineExam) {
//        
//        OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
//        NSDictionary *dic = @{TEACHINGID : self.course.teachingId, STUDENTID : onceLogin.studentID};
//        [KVNProgress showWithStatus:@"正在查询考试是否开通"];
//        
//        [SANetWorkingTask requestWithPost:[SAURLManager isOpenExam] parmater:dic block:^(id result) {
//
//            [KVNProgress dismiss];
//            
//            if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
//                ExamModel *examModel = [[ExamModel alloc] initWithDictionary:result];
//                [KVNProgress dismiss];
//                if (examModel.examId.length) {
//                    SCLAlertView *alert = [[SCLAlertView alloc] init];
//                    [alert addButton:@"确定" actionBlock:^(void) {
//                        ExamViewController *examViewController = [[ExamViewController alloc] initWithCouse:self.course withExam:examModel];
//                        [self.navigationController pushViewController:examViewController animated:YES];
//                    }];
//                    [alert addButton:@"取消" actionBlock:^(void) {
//                    }];
//                    
//                    [alert showWarning:self title:@"警告" subTitle:[NSString stringWithFormat:@"本次考试时长为%@分钟\n考试过程中请勿退出考试页面，否则系统会自动交卷，祝您取得好成绩！", examModel.timeLength] closeButtonTitle:nil duration:0.0f];
//                } else {
//                    [KVNProgress showErrorWithStatus:@"暂未获取到考试题"];
//                }
//            } else {
//                [KVNProgress showErrorWithStatus:result[ERRORMESSAGE]];
//            }
//        }];
//    } else if (indexPath.row == ExamText) {
//        
//        ExamViewController *examViewController = [[ExamViewController alloc] initWithAllCouse:self.allResult withCourse:self.course];
//        [KVNProgress dismiss];
//        SCLAlertView *alert = [[SCLAlertView alloc] init];
//        
//        if ((self.allResult.selectQuestion.count + self.allResult.multiSelectQuestion.count + self.allResult.judgeQuestion.count) < 50) {
//            [KVNProgress showErrorWithStatus:@"习题数量未达到50道\n不符合全真模拟要求"];
//            return;
//        }
//
//        
//        [alert addButton:@"确定" actionBlock:^(void) {
//            [self.navigationController pushViewController:examViewController animated:YES];
//        }];
//        [alert addButton:@"取消" actionBlock:^(void) {
//        }];
//        [alert showWarning:self title:@"警告" subTitle:@"是否开启本次考试" closeButtonTitle:nil duration:0.0f];
//
//        
//        
//    } else if (indexPath.row == Collect) {
//        
//        CollectViewController *collectViewController = [[CollectViewController alloc] initWithCourse:self.course];
//        [self.navigationController pushViewController:collectViewController animated:YES];
//        
//    } else {
//    
//        if (indexPath.row == SelectOrder) {
//            collectionViewType = SelectOrder;
//            dataSource = self.allResult.selectQuestion;
//        }
//        if (indexPath.row == MultiSelect) {
//            collectionViewType = MultiSelect;
//            dataSource = self.allResult.multiSelectQuestion;
//        }
//        if (indexPath.row == JudgeMentOrder) {
//            collectionViewType = JudgeMentOrder;
//            dataSource = self.allResult.judgeQuestion;
//        }
//        if (indexPath.row == FillBankOrder) {
//            collectionViewType = FillBankOrder;
//            dataSource = self.allResult.fillBlankQuestion;
//        }
//        if (indexPath.row == ShortAnswerOrder) {
//            collectionViewType = ShortAnswerOrder;
//            dataSource = self.allResult.shortAnswerQuestion;
//        }
//        
//        if (dataSource.count) {
//            TextViewController *textViewController = [[TextViewController alloc] initWithType:collectionViewType withDatasource:dataSource withCourse:self.course];
//            [self.navigationController pushViewController:textViewController animated:YES];
//            return;
//        }
//        
//        [KVNProgress showErrorWithStatus:@"暂时没有本类练习题"];
//    }
//}

#pragma mark TreeView Delegate methods

- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item
{
    NSInteger level = [treeView levelForCellForItem:item];
    if (!level) {
        return 150;
    }
    return 44;
}

- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item
{
    return NO;
}

//- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item
//{
//    RATableViewCell *cell = (RATableViewCell *)[treeView cellForItem:item];
//    [cell setAdditionButtonHidden:NO animated:YES];
//}
//
//- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item
//{
//    RATableViewCell *cell = (RATableViewCell *)[treeView cellForItem:item];
//    [cell setAdditionButtonHidden:YES animated:YES];
//}

//- (void)treeView:(RATreeView *)treeView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowForItem:(id)item
//{
//    if (editingStyle != UITableViewCellEditingStyleDelete) {
//        return;
//    }
//    
//    RADataObject *parent = [self.treeView parentForItem:item];
//    NSInteger index = 0;
//    
//    if (parent == nil) {
//        index = [self.data indexOfObject:item];
//        NSMutableArray *children = [self.data mutableCopy];
//        [children removeObject:item];
//        self.data = [children copy];
//        
//    } else {
//        index = [parent.children indexOfObject:item];
//        [parent removeChild:item];
//    }
//    
//    [self.treeView deleteItemsAtIndexes:[NSIndexSet indexSetWithIndex:index] inParent:parent withAnimation:RATreeViewRowAnimationRight];
//    if (parent) {
//        [self.treeView reloadRowsForItems:@[parent] withRowAnimation:RATreeViewRowAnimationNone];
//    }
//}

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item
{
    
    NSInteger level = [treeView levelForCellForItem:item];
    if (!level) {
        //获取cell
        CourseTableViewCell *cell = [treeView dequeueReusableCellWithIdentifier:NSStringFromClass([CourseTableViewCell class])];
        
        //当前item
        Course *model = item;
        //当前层级
        
        //赋值
        //    [cell setCellBasicInfoWith:model.name level:level children:model.children.count];
        [cell setCourseModel:model];
        
        [cell.hintLabel setText:model.courseName withBackGroundColor:self.colors[[self.datasource indexOfObject:model] % 4]];
        
        return cell;
    } else {
        ExerciseTableViewCell *cell = [treeView dequeueReusableCellWithIdentifier:NSStringFromClass([ExerciseTableViewCell class])];
        RADataObject *model = item;
        
        [cell.optionLabel setText:model.name];
        return cell;
    }

//    RADataObject *dataObject = item;
//    
//    NSInteger level = [self.treeView levelForCellForItem:item];
//    NSInteger numberOfChildren = [dataObject.children count];
//    NSString *detailText = [NSString localizedStringWithFormat:@"Number of children %@", [@(numberOfChildren) stringValue]];
//    BOOL expanded = [self.treeView isCellForItemExpanded:item];
//    
//    RATableViewCell *cell = [self.treeView dequeueReusableCellWithIdentifier:NSStringFromClass([RATableViewCell class])];
//    [cell setupWithTitle:dataObject.name detailText:detailText level:level additionButtonHidden:!expanded];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    __weak typeof(self) weakSelf = self;
//    cell.additionButtonTapAction = ^(id sender){
//        if (![weakSelf.treeView isCellForItemExpanded:dataObject] || weakSelf.treeView.isEditing) {
//            return;
//        }
//        RADataObject *newDataObject = [[RADataObject alloc] initWithName:@"Added value" children:@[]];
//        [dataObject addChild:newDataObject];
//        [weakSelf.treeView insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:0] inParent:dataObject withAnimation:RATreeViewRowAnimationLeft];
//        [weakSelf.treeView reloadRowsForItems:@[dataObject] withRowAnimation:RATreeViewRowAnimationNone];
//    };
//    
//    return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.datasource count];
    }
    
    Course *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    Course *data = item;
    if (item == nil) {
        return [self.datasource objectAtIndex:index];
    }
    
    return data.children[index];
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item {
    [treeView deselectRowForItem:item animated:YES];
    if ([item class] == [RADataObject class]) {
        RADataObject *data = item;
        
        Course *parent = [self.treeView parentForItem:item];
        NSInteger level = [parent.children indexOfObject:data];
        self.course = data.course;
        self.allResult = [[AllResult alloc] initWithCourseName:self.course.courseName];
        
        CollectionViewType collectionViewType = SelectOrder;
        NSArray *dataSource;
        
        switch (level) {
            case 0:
            {
                ExamViewController *examViewController = [[ExamViewController alloc] initWithAllCouse:self.allResult withCourse:data.course];
                [KVNProgress dismiss];
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                
                if ((self.allResult.selectQuestion.count + self.allResult.multiSelectQuestion.count + self.allResult.judgeQuestion.count) < 50) {
                    [JKAlert alertCrossText:@"习题数量未达到50道，不符合全真模拟要求"];
                    return;
                }
                
                [alert addButton:@"确定" actionBlock:^(void) {
                    [self.navigationController pushViewController:examViewController animated:YES];
                }];
                [alert addButton:@"取消" actionBlock:^(void) {
                }];
                [alert showWarning:self title:@"警告" subTitle:@"是否开启本次考试" closeButtonTitle:nil duration:0.0f];
                
                return ;
                break;
            }
            case 1:
            {
                CollectViewController *collectViewController = [[CollectViewController alloc] initWithCourse:self.course];
                [self.navigationController pushViewController:collectViewController animated:YES];
                return ;
                break;
            }
            case 2:
            {
                collectionViewType = SelectOrder;
                dataSource = self.allResult.selectQuestion;
                break;
            }
            case 3:
            {
                collectionViewType = MultiSelect;
                dataSource = self.allResult.multiSelectQuestion;
                break;
            }
            
            case 4:
            {
                collectionViewType = JudgeMentOrder;
                dataSource = self.allResult.judgeQuestion;
                break;
            }
            case 5:
            {
                collectionViewType = FillBankOrder;
                dataSource = self.allResult.fillBlankQuestion;
                break;
            }
            case 6:
            {
                collectionViewType = ShortAnswerOrder;
                dataSource = self.allResult.shortAnswerQuestion;
                break;
            }
            case 7: {
                PPTViewController *pptVC = [[PPTViewController alloc] initWithCourse:self.course];
                [self.navigationController pushViewController:pptVC animated:YES];
                return ;
                break;
            }
            case 8: {
                
                CourseVideoViewController *courseVideoViewController = [[CourseVideoViewController alloc] initWithCourse:self.course];
                [self.navigationController pushViewController:courseVideoViewController animated:YES];
                return ;
                break;
            }
            case 9: {
                RankViewController *rankViewController = [[RankViewController alloc] initWithCourse:self.course];
                [self.navigationController pushViewController:rankViewController animated:YES];
                return ;
                break;
            }
            default:
                break;
        }
        
        if (dataSource.count && level > 1) {
            TextViewController *textViewController = [[TextViewController alloc] initWithType:collectionViewType withDatasource:dataSource withCourse:self.course];
            [self.navigationController pushViewController:textViewController animated:YES];
            return;
        }
        
        [JKAlert alertCrossText:@"暂时没有本类练习题"];
    } else {
        self.course = item;
        [self getExercise];
    }
    
}

#pragma mark - rightButton

//- (void)rightButtonDidPress {
////    [self.navigationController popViewControllerAnimated:YES];
//   /// if (self.updateView.show) {
//    ///    [UIView animateWithDuration:0.5 animations:^{
//     ///       self.updateView.frame = CGRectMake(self.view.width - 138, -50, 128, 105);
//    ///    }];
////        [self.updateView removeFromSuperview];
//    ///    self.updateView.show = NO;
//   /// } else {
////        [self.view addSubview:self.updateView];
//    ///    [UIView animateWithDuration:0.5 animations:^{
//    ///       self.updateView.frame = CGRectMake(self.view.width - 138, 52, 128, 105);
//     ///   }];
//     ///   self.updateView.show = YES;
//  ///  }
//    if (!self.contextMenuTableView) {
//        self.contextMenuTableView = [[YALContextMenuTableView alloc]initWithTableViewDelegateDataSource:self];
//        self.contextMenuTableView.animationDuration = 0.15;
//        //optional - implement custom YALContextMenuTableView custom protocol
//        self.contextMenuTableView.yalDelegate = self;
//        //optional - implement menu items layout
//        self.contextMenuTableView.menuItemsSide = Right;
//        self.contextMenuTableView.menuItemsAppearanceDirection = FromTopToBottom;
//        
//        //register nib
//        UINib *cellNib = [UINib nibWithNibName:@"ContextMenuCell" bundle:nil];
//        [self.contextMenuTableView registerNib:cellNib forCellReuseIdentifier:menuCellIdentifier];
//    }
//    
//    // it is better to use this method only for proper animation
//    [self.contextMenuTableView showInView:self.navigationController.view withEdgeInsets:UIEdgeInsetsZero animated:YES];
//
//}

#pragma mark - UpdateViewDelegate

- (void)updateDatasource {
   NSDictionary *dic = @{TEACHERID : self.course.teacherId, COURSEID : self.course.courseId};
        [KVNProgress showWithStatus:@"正在更新试题"];
        [SANetWorkingTask requestWithPost:[SAURLManager downloadQuestion] parmater:dic block:^(id result) {
            [KVNProgress dismiss];
            
            if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
                self.allResult = [[AllResult alloc] initWithDictionary:result];
                [self.allResult writeToLocal:self.course.courseName];
                [KVNProgress showSuccessWithStatus:@"更新成功"];
            } else {
                [KVNProgress showErrorWithStatus:result[ERRORMESSAGE]];
            }
            
            
            
        }];
//    if (self.updateView.show) {
//        [UIView animateWithDuration:0.5 animations:^{
//            self.updateView.frame = CGRectMake(self.view.width - 138, -50, 128, 105);
//        }];
//        //        [self.updateView removeFromSuperview];
//        self.updateView.show = NO;
//    } else {
//        //        [self.view addSubview:self.updateView];
//        [UIView animateWithDuration:0.5 animations:^{
//            self.updateView.frame = CGRectMake(self.view.width - 138, 52, 128, 105);
//        }];
//        self.updateView.show = YES;
//    }

}

- (void)removeDatasource {
    
    SAKeyValueStore *store = [[SAKeyValueStore alloc] initDBWithName:@"test.db"];
    for (int i = 0; i < 5; i++) {
        NSString *tableName = [NSString stringWithFormat:@"coursetable%@_%d", self.course.courseId, i];
        [store clearTable:tableName];
    }
    [KVNProgress showSuccessWithStatus:@"已清除全部记录"];
    
//    if (self.updateView.show) {
//        [UIView animateWithDuration:0.5 animations:^{
//            self.updateView.frame = CGRectMake(self.view.width - 138, -50, 128, 105);
//        }];
//        //        [self.updateView removeFromSuperview];
//        self.updateView.show = NO;
//        
//        SAKeyValueStore *store = [[SAKeyValueStore alloc] initDBWithName:@"test.db"];
//        for (int i = 0; i < 5; i++) {
//            NSString *tableName = [NSString stringWithFormat:@"coursetable%@_%d", self.course.courseId, i];
//            [store clearTable:tableName];
//        }
//        [KVNProgress showSuccessWithStatus:@"已清除全部记录"];
//        
//    } else {
//        //        [self.view addSubview:self.updateView];
//        [UIView animateWithDuration:0.5 animations:^{
//            self.updateView.frame = CGRectMake(self.view.width - 138, 52, 128, 105);
//        }];
//        self.updateView.show = YES;
//    }
//
}


#pragma mark ---------------

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    //should be called after rotation animation completed
    [self.contextMenuTableView reloadData];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self.contextMenuTableView updateAlongsideRotation];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        //should be called after rotation animation completed
        [self.contextMenuTableView reloadData];
    }];
    [self.contextMenuTableView updateAlongsideRotation];
    
}

#pragma mark - Local methods

- (void)initiateMenuOptions {
    self.menuTitles = @[@"",
                        @"更新题库",
                        @"清除收藏",
                        ];
    
    self.menuIcons = @[[UIImage imageNamed:@"MainColorcancel"],
                       [UIImage imageNamed:@"MainColorupdate"],
                       [UIImage imageNamed:@"MainColorremove"],
                       ];
}

#pragma mark - YALContextMenuTableViewDelegate

- (void)contextMenuTableView:(YALContextMenuTableView *)contextMenuTableView didDismissWithIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 1:
            [self updateDatasource];
            break;
        case 2:
            [self removeDatasource];
            break;
        default:
            break;
    }
}

#pragma mark - 重载父类方法

- (void)hiddenHint {
    [super hiddenHint];
    self.treeView.hidden = YES;
}

- (void)noHiddenHint {
    [super noHiddenHint];
    self.treeView.hidden = NO;
}

- (void)backBtuDidPress {
    [self getCourse];
}

@end
