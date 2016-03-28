//
//  MainViewController.h
//  StudyAssisTant
//
//  Created by wjn on 15/8/25.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAKit.h"
#import "ImageHeadTableViewCell.h"
#import "MineUITableViewCell.h"
#import "OnceLogin.h"
#import "MineSetViewController.h"
#import "NewsViewController.h"

@interface MainViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UINib *imageHeadTableViewCell;
@property (strong, nonatomic) UINib *mineUITableViewCell;

@end
