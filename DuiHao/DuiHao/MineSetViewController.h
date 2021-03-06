//
//  MineSetViewController.h
//  StudyAssisTant
//
//  Created by wjn on 15/8/28.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"
#import "MineTableViewCell.h"
#import "MineControlTableViewCell.h"
#import "LoginViewController.h"
#import "CGPasswordViewController.h"
#import "ExitTableViewCell.h"

typedef enum {
    Rubbish,
    SecretCode,
    Exit
    
}IndexPath;

@interface MineSetViewController : SAViewController<UITableViewDataSource, UITableViewDelegate, CGPasswordViewControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *datasource;
@property (strong, nonatomic) UINib *mineTableViewCell;
@property (strong, nonatomic) UINib *mineControlTableViewCell;
@property (strong, nonatomic) UINib *exitTableViewCell;

@end
