//
//  PPTViewController.m
//  DuiHao
//
//  Created by wjn on 2017/3/14.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "PPTViewController.h"
#import "PPTTableViewCell.h"
#import "PPTModel.h"
#import "ThemePPTView.h"
#import "ReaderViewController.h"


@interface PPTViewController ()<UITableViewDataSource, UITableViewDelegate, ReaderViewControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) Course *course;

@end

@implementation PPTViewController

- (instancetype)initWithCourse:(Course *)course
{
    self = [super init];
    if (self) {
        self.course = course;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"课件"];
    
    [self getData];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        //        self.tableView.height += 44;
        _tableView.backgroundColor = TABLEBACKGROUND;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"PPTTableViewCell" bundle:nil] forCellReuseIdentifier:@"PPTTableViewCell"];
    }
    return _tableView;
}
- (void)getData {
    [SANetWorkingTask requestWithPost:[SAURLManager getPPTList] parmater:@{TEACHERID: self.course.teacherId, COURSEID: self.course.courseId} blockOrError:^(id result, NSError *error) {
        
        if (error) {
            
            return ;
        }
        
        if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
            result = result[RESULT];
            NSMutableSet *set = [NSMutableSet setWithCapacity:0];
            NSMutableArray *ppts = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *dic in result[LISTS]) {
                PPTModel *pptModel = [[PPTModel alloc] initWithDictionary:dic];
                [set addObject:pptModel.theme];
                [ppts addObject:pptModel];
            }
            
            for (NSString *theme in set) {
                
                NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithCapacity:0];
                NSMutableArray *themes = [NSMutableArray arrayWithCapacity:0];
                
                [mutableDic setObject:theme forKey:@"theme"];
                
                for (PPTModel *ppt in ppts) {
                    if ([ppt.theme isEqualToString:theme]) {
                        [themes addObject:ppt];
                    }
                }
                [mutableDic setObject:themes forKey:@"ppt"];
                [self.dataSource addObject:mutableDic];
            }
            
            [self.tableView reloadData];
        }
        
        if (!self.dataSource.count) {
            [JKAlert alertText:@"教师未上传课件"];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ThemePPTView *themeV = [[NSBundle mainBundle] loadNibNamed:@"ThemePPTView" owner:self options:nil][0];
    [themeV.themeL setText:self.dataSource[section][@"theme"]];
    return themeV;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 68;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PPTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PPTTableViewCell"];
    
    NSArray *array = self.dataSource[indexPath.section][@"ppt"];
    PPTModel *pptModel = array[indexPath.row];
    cell.pptModel = pptModel;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *array = self.dataSource[section][@"ppt"];
    return array.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *array = self.dataSource[indexPath.section][@"ppt"];
    PPTModel *pptModel = array[indexPath.row];
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    filePath = [NSString stringWithFormat:@"%@/%ld.pdf", filePath, [pptModel.downloadurl hash]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:nil];
        
        if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
        {
            ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
            
            readerViewController.delegate = self; // Set the ReaderViewController delegate to self
            
            readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            
            [self presentViewController:readerViewController animated:YES completion:NULL];
        }
    } else {
        [JKAlert alertText:@"请点击下载该文件"];
    }
    
}

#pragma mark - ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
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
