//
//  CollectViewController.m
//  StudyAssisTant
//
//  Created by wjn on 15/10/7.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "CollectViewController.h"

@interface CollectViewController ()

@end

@implementation CollectViewController

- (instancetype)initWithCourse:(Course *)course {
    self = [super init];
    if (self) {
        self.course = course;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTranslucent:NO];
//    [self.tabBarController.tabBar setHidden:YES];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"本地收藏"];
    
    [self.view addSubview:self.tableView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)datasource {
    if (!_datasource) {
        self.datasource = [NSMutableArray arrayWithObjects: @"单选题", @"多选题", @"判断题", @"填空题", @"简答题", nil];
    }
    return _datasource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//        self.tableView.height += 44;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        self.exerciseTableViewCell = [UINib nibWithNibName:@"ExerciseTableViewCell" bundle:nil];
        [_tableView registerNib:self.exerciseTableViewCell forCellReuseIdentifier:@"exerciseTableViewCell"];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ExerciseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"exerciseTableViewCell"];
    if (self.datasource.count > indexPath.row) {
        cell.optionLabel.text = self.datasource[indexPath.row];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CollectionViewType collectionViewType = SelectOrder;
    NSArray *dataSource;
    if (indexPath.row == 0) {
        collectionViewType = SelectOrder;
        NSString *tableName = [NSString stringWithFormat:@"coursetable%@_%lu", self.course.courseId, (long)indexPath.row];
        SAKeyValueStore *store = [[SAKeyValueStore alloc] initDBWithName:@"test.db"];
        [store createTableWithName:tableName];
        
        //    NSDictionary *queryUser = [store getObjectById:@"2" fromTable:tableName];
        dataSource = [store getAllItemsFromTable:tableName];
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        for (SAKeyValueItem *dic in dataSource) {
            ItemModel *itemModel = [[ItemModel alloc] initWithrawDictionary:dic.itemObject];
            [arr addObject:itemModel];
        }
        dataSource = [NSArray arrayWithArray:arr];
    }
    if (indexPath.row == 1) {
        collectionViewType = MultiSelect;
        NSString *tableName = [NSString stringWithFormat:@"coursetable%@_%lu", self.course.courseId, (long)indexPath.row];
        SAKeyValueStore *store = [[SAKeyValueStore alloc] initDBWithName:@"test.db"];
        [store createTableWithName:tableName];
        
        //    NSDictionary *queryUser = [store getObjectById:@"2" fromTable:tableName];
        dataSource = [store getAllItemsFromTable:tableName];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        for (SAKeyValueItem *dic in dataSource) {
            ItemModel *itemModel = [[ItemModel alloc] initWithrawDictionary:dic.itemObject];
            [arr addObject:itemModel];
        }
        dataSource = [NSArray arrayWithArray:arr];
    }
    if (indexPath.row == 2) {
        collectionViewType = JudgeMentOrder;
        NSString *tableName = [NSString stringWithFormat:@"coursetable%@_%lu", self.course.courseId, (long)indexPath.row];
        SAKeyValueStore *store = [[SAKeyValueStore alloc] initDBWithName:@"test.db"];
        [store createTableWithName:tableName];
        
        //    NSDictionary *queryUser = [store getObjectById:@"2" fromTable:tableName];
        dataSource = [store getAllItemsFromTable:tableName];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        for (SAKeyValueItem *dic in dataSource) {
            ItemModel *itemModel = [[ItemModel alloc] initWithrawDictionary:dic.itemObject];
            [arr addObject:itemModel];
        }
        dataSource = [NSArray arrayWithArray:arr];
    }
    if (indexPath.row == 3) {
        collectionViewType = FillBankOrder;
        NSString *tableName = [NSString stringWithFormat:@"coursetable%@_%lu", self.course.courseId, (long)indexPath.row];
        SAKeyValueStore *store = [[SAKeyValueStore alloc] initDBWithName:@"test.db"];
        [store createTableWithName:tableName];
        
        //    NSDictionary *queryUser = [store getObjectById:@"2" fromTable:tableName];
        dataSource = [store getAllItemsFromTable:tableName];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        for (SAKeyValueItem *dic in dataSource) {
            ItemModel *itemModel = [[ItemModel alloc] initWithrawDictionary:dic.itemObject];
            [arr addObject:itemModel];
        }
        dataSource = [NSArray arrayWithArray:arr];
    }
    if (indexPath.row == 4) {
        collectionViewType = ShortAnswerOrder;
        NSString *tableName = [NSString stringWithFormat:@"coursetable%@_%lu", self.course.courseId, (long)indexPath.row];
        SAKeyValueStore *store = [[SAKeyValueStore alloc] initDBWithName:@"test.db"];
        [store createTableWithName:tableName];
        
        //    NSDictionary *queryUser = [store getObjectById:@"2" fromTable:tableName];
        dataSource = [store getAllItemsFromTable:tableName];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        for (SAKeyValueItem *dic in dataSource) {
            ItemModel *itemModel = [[ItemModel alloc] initWithrawDictionary:dic.itemObject];
            [arr addObject:itemModel];
        }
        dataSource = [NSArray arrayWithArray:arr];
    }
    if (dataSource.count) {
        TextViewController *textViewController = [[TextViewController alloc] initWithType:collectionViewType withDatasource:dataSource withCollect:YES withCourse:self.course];
        [self.navigationController pushViewController:textViewController animated:YES];
                
        return;
    }
    [JKAlert alertCrossText:@"暂时没有本类型收藏"];
}

#pragma mark - rightButton

- (void)rightButtonDidPress {
//    //    [self.navigationController popViewControllerAnimated:YES];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
