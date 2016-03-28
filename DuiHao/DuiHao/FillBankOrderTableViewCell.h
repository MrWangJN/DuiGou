//
//  FillBankOrderTableViewCell.h
//  StudyAssisTant
//
//  Created by wjn on 15/9/29.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FillBankOrderTableViewCellDelegate;

@interface FillBankOrderTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inPutText;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (strong, nonatomic) NSMutableArray *answers;
@property (assign, nonatomic) NSInteger index;

@property (assign, nonatomic) id<FillBankOrderTableViewCellDelegate>delegate;

- (void)settextWith:(NSInteger)index withArray:(NSMutableArray *)array;

@end

@protocol FillBankOrderTableViewCellDelegate <NSObject>

- (void)textFieldDidSelect:(NSInteger )index;

@end