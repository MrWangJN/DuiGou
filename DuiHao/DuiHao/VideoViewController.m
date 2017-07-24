//
//  VideoViewController.m
//  DuiHao
//
//  Created by wjn on 2017/7/18.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "VideoViewController.h"
#import "OnceLogin.h"
#import "RATreeView.h"
#import "RADataObject.h"
#import "RATableViewCell.h"
#import "VideoTeacherTableViewCell.h"
#import "VideoTableViewCell.h"
#import "VideoModel.h"
#import "ChildVideoModel.h"
#import "CourseVideoViewController.h"

@interface VideoViewController ()<RATreeViewDelegate, RATreeViewDataSource>

@property (strong, nonatomic) RATreeView *treeView;
@property (strong, nonatomic) NSMutableArray *datasource;
@property (strong, nonatomic) NSArray *colors;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:@"视频"];
    
    // 无数据时显示的提示图片
    [self setHintImage:@"NoCourse" whihHight:65];

    [self getData];
    [self.view addSubview:self.treeView];
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

- (RATreeView *)treeView {
    if (!_treeView) {
        self.treeView = [[RATreeView alloc] initWithFrame:self.view.bounds];
        _treeView.delegate = self;
        _treeView.dataSource = self;
        _treeView.treeFooterView = [UIView new];
        _treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
        _treeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_treeView registerNib:[UINib nibWithNibName:NSStringFromClass([VideoTeacherTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([VideoTeacherTableViewCell class])];
        [_treeView registerNib:[UINib nibWithNibName:NSStringFromClass([VideoTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([VideoTableViewCell class])];
    }
    return _treeView;
}

- (void)getData {
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    
    if (!onceLogin.studentID) {
        return;
    }
    
    [JKAlert alertWaitingText:@"正在加载"];
    
    [SANetWorkingTask requestWithPost:[SAURLManager videoList] parmater:@{STUDENTID: onceLogin.studentID} blockOrError:^(id result, NSError *error) {
        
        [JK_M dismissElast];
        
        if (error) {
            [JKAlert alertText:@"请求失败"];
            [self hiddenHint];
            return ;
        }
        
        if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
          
            [self.datasource removeAllObjects];
            
            
            result = result[RESULT][LISTS];
            
            for (NSDictionary *dic in result) {
                
                NSArray *array = dic[@"course"];
                NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:0];
                for (NSDictionary * course in array) {
                    
                    ChildVideoModel *childModel = [[ChildVideoModel alloc] initWithDic:course children:nil];
                    [mutableArr addObject:childModel];
                }
                VideoModel *videoModel = [[VideoModel alloc] initWithDictionary:dic children:mutableArr];
                [self.datasource addObject:videoModel];
            }
            
            
            if (!self.datasource.count) {
                [self hiddenHint];
            } else {
                [self noHiddenHint];
                [self.treeView reloadData];
            }
        } else {
            [self hiddenHint];
        }
        
    }];
    
}

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
        VideoTableViewCell *cell = [treeView dequeueReusableCellWithIdentifier:NSStringFromClass([VideoTableViewCell class])];

        VideoModel *model = item;
//        //赋值
        [cell setVideoModel:model];
        
        [cell.backView setBackgroundColor:self.colors[[self.datasource indexOfObject:model] % 4]];
        
        return cell;
    } else {
        VideoTeacherTableViewCell *cell = [treeView dequeueReusableCellWithIdentifier:NSStringFromClass([VideoTeacherTableViewCell class])];
        ChildVideoModel *model = item;
        [cell setChildVieoModel:model];
        
        VideoModel *videoModel = [treeView parentForItem:item];
        [cell.ColorView setBackgroundColor:self.colors[[self.datasource indexOfObject:videoModel] % 4]];
        return cell;
    }
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
    
    if ([item class] == [ChildVideoModel class]) {
        
        ChildVideoModel *childVieoModel = item;
        
        Course *course = [[Course alloc] init];
        course.teacherId = childVieoModel.teacher_id.stringValue;
        course.courseId = childVieoModel.course_id.stringValue;
        course.courseName = childVieoModel.courseName;
        
        CourseVideoViewController *courseVideoViewController = [[CourseVideoViewController alloc] initWithCourse:course];
        [self.navigationController pushViewController:courseVideoViewController animated:YES];
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
    [self getData];
}

@end
