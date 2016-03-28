//
//  ShortAnswerCollectionViewCell.m
//  StudyAssisTant
//
//  Created by wjn on 15/9/29.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "ShortAnswerCollectionViewCell.h"

@implementation ShortAnswerCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [self addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.keyBoardHight = 253;
}

- (void)setItemModel:(ItemModel *)itemModel {
    
    _itemModel = itemModel;
    [self.datasource removeAllObjects];
    
    [self.datasource addObject:itemModel.question];
    
    if (!itemModel.my_Answer) {
       itemModel.my_Answer =  @"作答区";
    }
    [self.datasource addObject:itemModel.my_Answer];
    if ([itemModel.answer hasPrefix:@"本题答案"] && !self.isExam) {
        [self.datasource addObject:itemModel.answer];
    }
    
    [self.tableView reloadData];
}

- (void)layoutSubviews {
    self.tableView.frame = self.bounds;
    self.tableView.height -= 64.0;
}

- (NSMutableArray *)datasource {
    if (!_datasource) {
        self.datasource = [NSMutableArray arrayWithCapacity:0];
    }
    return _datasource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.shortAnswerTableViewCell = [UINib nibWithNibName:@"ShortAnswerTableViewCell" bundle:nil];
        self.itemTitleTableViewCell = [UINib nibWithNibName:@"ItemTitleTableViewCell" bundle:nil];
        self.optionTableViewCell = [UINib nibWithNibName:@"OptionTableViewCell" bundle:nil];
        [_tableView registerNib:self.optionTableViewCell forCellReuseIdentifier:@"OptionTableViewCell"];
        [_tableView registerNib:self.shortAnswerTableViewCell forCellReuseIdentifier:@"ShortAnswerTableViewCell"];
        [_tableView registerNib:self.itemTitleTableViewCell forCellReuseIdentifier:@"itemTitleTableViewCell"];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ItemTitleTableViewCell *cell = (ItemTitleTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        [cell layoutIfNeeded];
        [cell setNeedsLayout];
        return [cell textHeight];
    } else if ([self.datasource.lastObject isEqualToString:self.itemModel.answer] && indexPath.row == (self.datasource.count - 1)) {
        OptionTableViewCell *cell = (OptionTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        [cell layoutIfNeeded];
        [cell setNeedsLayout];
        return [cell textHeight];
    } else {
        return 100;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        ItemTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemTitleTableViewCell"];
        cell.delegate = self;
        if (self.isExam) {
            [cell.answerButton setHidden:YES];
            [cell.answerImage setHidden:YES];
        }
        if (self.datasource.count > indexPath.row) {
            NSString *string = [NSString stringWithFormat:@"%@", self.datasource[indexPath.row]];
            [cell.titleLabel setTitle:string withSize:17];
            cell.section.text = [NSString stringWithFormat:@"第%@章 第%@节", self.itemModel.chapter, self.itemModel.section];
        }
        return cell;
    }else if ([self.datasource.lastObject isEqualToString:self.itemModel.answer] && indexPath.row == (self.datasource.count - 1)) {
        OptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OptionTableViewCell"];
        if (self.datasource.count > indexPath.row) {
            [cell.option setOtherTitle:self.datasource[indexPath.row] withSize:17];
            [cell.icon setImage:[UIImage imageNamed:@"OurAnswer"]];
        }
        return cell;
    } else {
        ShortAnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShortAnswerTableViewCell"];
        cell.delegate = self;
//        cell.textField.text = self.datasource[indexPath.row];
        cell.array = self.datasource;
//        [cell clear];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didSelect:(NSIndexPath *)indexPath {
    
    if (self.isExam) {
        if ([self.delegate respondsToSelector:@selector(selectCorrectAnswer)]) {
            [self.delegate selectCorrectAnswer];
        }
    }
}

#pragma mark - SelectCollectionViewCellDelegate

- (void)answerPress {
    
    NSString *string = self.datasource.lastObject;
    if (![string isEqualToString:[NSString stringWithFormat:@"本题答案：%@", self.itemModel.answer]]&&![string isEqualToString:self.itemModel.answer]) {
        self.itemModel.answer = [NSString stringWithFormat:@"本题答案：%@", self.itemModel.answer];
        [self.datasource addObject:self.itemModel.answer];
        [self.tableView reloadData];
    }
}

#pragma mark - FillBankOrderTableViewCellDelegate

- (void)textFieldDidSelect {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
    CGRect rectInSuperview = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
    
    int offset =  rectInSuperview.origin.y + 160 - (self.height - self.keyBoardHight);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    if(offset > 0)
        self.tableView.top = -offset;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    self.tableView.top = 0;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect rect = [notification.userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    self.keyBoardHight = rect.size.height;
}

@end
