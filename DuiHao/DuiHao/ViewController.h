//
//  ViewController.h
//  StudyAssisTant
//
//  Created by 王建男 on 15/3/8.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"
#import "CourseCollectionViewCell.h"
#import "LoginViewController.h"
#import "TextViewController.h"
#import "AnswerViewController.h"
#import "ExamViewController.h"
#import "ExerciseViewController.h"
#import "Course.h"
#import "CourseTableViewCell.h"
#import "ADSViewController.h"
#import "AddCourseViewController.h"
#import "QRCodeViewController.h"

@interface ViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datasource;
@property (strong, nonatomic) UINib *courseTableViewCell;
@property (strong, nonatomic) NSString *studentID;
@property (strong, nonatomic) NSString *schoolNum;

@end
