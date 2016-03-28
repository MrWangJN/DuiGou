//
//  FillBankOrderCollectionViewCell.m
//  StudyAssisTant
//
//  Created by 王建男 on 15/4/8.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "FillBankOrderCollectionViewCell.h"
#import "MutiSelFooterView.h"

@implementation FillBankOrderCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [self addSubview:self.tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.keyBoardHight = 253;
}

- (void)setItemModel:(ItemModel *)itemModel {
    
    _itemModel = itemModel;
    
    NSArray *array = [itemModel.answer componentsSeparatedByString:@"/"];
    [self.answers removeAllObjects];
    for (NSString *string in array) {
        [self.answers addObject:@""];
    }
    
    [self.datasource removeAllObjects];
    
    [self.datasource addObject:itemModel.question];
    [self.datasource addObjectsFromArray:self.answers];
    if ([itemModel.answer hasPrefix:@"本题答案"] && !self.isExam) {
        [self.datasource addObject:itemModel.answer];
    }
    
    [self.tableView reloadData];
}

- (void)layoutSubviews {
    self.tableView.frame = self.bounds;
    self.tableView.height -= 64.0;
}

- (NSMutableArray *)answers {
    if (!_answers) {
        self.answers = [NSMutableArray arrayWithCapacity:0];
    }
    return _answers;
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
        self.fillBankOrderTableViewCell = [UINib nibWithNibName:@"FillBankOrderTableViewCell" bundle:nil];
        self.itemTitleTableViewCell = [UINib nibWithNibName:@"ItemTitleTableViewCell" bundle:nil];
        self.optionTableViewCell = [UINib nibWithNibName:@"OptionTableViewCell" bundle:nil];
        [_tableView registerNib:self.fillBankOrderTableViewCell forCellReuseIdentifier:@"FillBankOrderTableViewCell"];
        [_tableView registerNib:self.itemTitleTableViewCell forCellReuseIdentifier:@"itemTitleTableViewCell"];
        [_tableView registerNib:self.optionTableViewCell forCellReuseIdentifier:@"optionTableViewCell"];
    }
    return _tableView;
}

- (void)cerTainButtonDidPress {
    
    for (FillBankOrderTableViewCell *cell in self.tableView.visibleCells) {
        if ([cell isKindOfClass:[FillBankOrderTableViewCell class]]) {
            [cell.inPutText resignFirstResponder];
        }
    }
    
    NSString *string = [self.answers componentsJoinedByString:@"/"];
    
    if ([string isEqualToString:self.itemModel.answer] || [[NSString stringWithFormat:@"%@%@", @"本题答案：", string] isEqualToString:self.itemModel.answer]) {
        
        if ([self.delegate respondsToSelector:@selector(selectCorrectAnswer)]) {
            [self.delegate selectCorrectAnswer];
        }
    } else {
        [self.delegate selectWrongAnswer];
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    MutiSelFooterView *footer = [[NSBundle mainBundle] loadNibNamed:@"MutiSelFooterView" owner:self options:nil][0];
    [footer.cerTainButton addTarget:self action:@selector(cerTainButtonDidPress) forControlEvents:UIControlEventTouchUpInside];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ItemTitleTableViewCell *cell = (ItemTitleTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        [cell layoutIfNeeded];
        [cell setNeedsLayout];
        return [cell textHeight];
    } else if ([self.datasource.lastObject hasPrefix:@"本题答案："] && indexPath.row == (self.datasource.count - 1)) {
        OptionTableViewCell *cell = (OptionTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        [cell layoutIfNeeded];
        [cell setNeedsLayout];
        return [cell textHeight];
    } else {
        return 50;
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
            [cell.titleLabel setTitle:self.datasource[indexPath.row] withSize:17];
            cell.section.text = [NSString stringWithFormat:@"第%@章 第%@节", self.itemModel.chapter, self.itemModel.section];
        }
        return cell;
    } else if ([self.datasource.lastObject hasPrefix:@"本题答案："] && indexPath.row == (self.datasource.count - 1)) {
        OptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"optionTableViewCell"];
        if (self.datasource.count > indexPath.row) {
            [cell.option setOtherTitle:self.datasource[indexPath.row] withSize:17];
            [cell.icon setImage:[UIImage imageNamed:@"OurAnswer"]];
        }
        return cell;
    }
    else {
        FillBankOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FillBankOrderTableViewCell"];
        cell.delegate = self;
        if (self.datasource.count > indexPath.row) {
            [cell.numberLabel setText:[NSString stringWithFormat:@"%ld.", (long)indexPath.row]];
            [cell settextWith:indexPath.row withArray:self.answers];
        }
        return cell;
    }
    //    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (void)textFieldDidSelect:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
        CGRect rectInSuperview = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
//    NSLog(@"AAA  %f", self.bottom - rectInSuperview.origin.y);
//    if (self.bottom - rectInSuperview.origin.y < 357) {
//        [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y + self.bottom - rectInSuperview.origin.y - 307)];
//    }
    
    int offset =  rectInSuperview.origin.y + 110 - (self.height - self.keyBoardHight);
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
