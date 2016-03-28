//
//  ShortAnswerTableViewCell.h
//  StudyAssisTant
//
//  Created by wjn on 15/10/6.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShortAnswerTableViewDelegate;

@interface ShortAnswerTableViewCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (assign, nonatomic) id<ShortAnswerTableViewDelegate>delegate;
@property (strong, nonatomic) NSString *string;
@property (strong, nonatomic) NSMutableArray *array;
- (void)clear;
@end

@protocol ShortAnswerTableViewDelegate <NSObject>

- (void)textFieldDidSelect;

@end