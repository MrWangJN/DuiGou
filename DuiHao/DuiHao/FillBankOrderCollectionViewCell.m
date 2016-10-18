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
    
    if (!itemModel) {
        return ;
    }
    
    _itemModel = itemModel;
    [self.datasource removeAllObjects];
    if (itemModel.question) {
        ItemTitleStatusLayout *itemTitleStatusLayout = [[ItemTitleStatusLayout alloc] initWithStatus:itemModel];
        [self.datasource addObject:itemTitleStatusLayout];
    }
    
    NSArray *array = [itemModel.answer componentsSeparatedByString:@"/"];
    [self.answers removeAllObjects];
    for (NSString *string in array) {
        [self.answers addObject:@""];
    }
    
    if ([self.itemModel.answer hasPrefix:@"答案："]) {
        [self answerPress];
    } else {
        [self footerViewReset];
    }
    
    [self.tableView reloadData];
    
//    _itemModel = itemModel;
//    
//    NSArray *array = [itemModel.answer componentsSeparatedByString:@"/"];
//    [self.answers removeAllObjects];
//    for (NSString *string in array) {
//        [self.answers addObject:@""];
//    }
//    
//    [self.datasource removeAllObjects];
//    
//    [self.datasource addObject:itemModel.question];
//    [self.datasource addObjectsFromArray:self.answers];
//    if ([itemModel.answer hasPrefix:@"本题答案"] && !self.isExam) {
//        [self.datasource addObject:itemModel.answer];
//    }
//    
//    [self.tableView reloadData];
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
    
    NSString *string = [self.answers componentsJoinedByString:@"`"];
    
    if ([string isEqualToString:self.itemModel.answer] || [[NSString stringWithFormat:@"%@%@", @"答案：", string] isEqualToString:self.itemModel.answer]) {
        
        if ([self.delegate respondsToSelector:@selector(selectCorrectAnswer)]) {
            [self.delegate selectCorrectAnswer];
        }
    } else {
        [self.delegate selectWrongAnswer];
    }
}

- (MutiSelFooterView *)footerView {
    if (!_footerView) {
        self.footerView = [[NSBundle mainBundle] loadNibNamed:@"MutiSelFooterView" owner:self options:nil][0];
        _footerView.delegate = self;
        [_footerView.cerTainButton addTarget:self action:@selector(cerTainButtonDidPress) forControlEvents:UIControlEventTouchUpInside];
        [_footerView.answerBtu addTarget:self action:@selector(answerPress) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

- (void)footerViewReset {
    self.footerView.answerLabel.text = @"答案：";
    self.footerView.analysis.text = @"解析：";
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.isExam) {
        return CGFLOAT_MIN;
    } else {
        return [self.footerView getFooterHeight];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (self.isExam) {
        return nil;
    }
    return self.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return ((ItemTitleStatusLayout *)self.datasource[indexPath.row]).height;
    } else {
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        ItemTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemTitleTableViewCell"];
        cell.delegate = self;
//        if (self.isExam) {
//            [cell.answerButton setHidden:YES];
//            [cell.answerImage setHidden:YES];
//        }
        if (self.datasource.count > indexPath.row) {
//            [cell.titleLabel setTitle:self.datasource[indexPath.row] withSize:17];
//            cell.section.text = [NSString stringWithFormat:@"第%@章 第%@节", self.itemModel.chapter, self.itemModel.section];
            [cell setLayout:[_datasource firstObject]];
        }
        return cell;
    } else {
        FillBankOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FillBankOrderTableViewCell"];
        cell.delegate = self;
        if (self.datasource.count > indexPath.row) {
            [cell.numberLabel setText:[NSString stringWithFormat:@"%ld.", (long)indexPath.row]];
            [cell settextWith:indexPath.row withArray:self.answers];
        }
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return NO;
    } else {
        return YES;
    }
    
}

#pragma mark - SelectCollectionViewCellDelegate

- (void)answerPress {
    
    if ([self.itemModel.answer hasPrefix:@"答案："] || [self.itemModel.answerAnalysis hasPrefix:@"解析："]) {
        [self.footerView setanswer:_itemModel.answer withAnalysis:_itemModel.answerAnalysis withImageURL:_itemModel.answerAnalysisUrl];
    } else {
        self.itemModel.answer = [NSString stringWithFormat:@"答案：%@", self.itemModel.answer];
        self.itemModel.answerAnalysis = [NSString stringWithFormat:@"解析：%@", self.itemModel.answerAnalysis];
        [self.footerView setanswer:self.itemModel.answer withAnalysis:self.itemModel.answerAnalysis withImageURL:self.itemModel.answerAnalysisUrl];
    }
    
    self.tableView.sectionFooterHeight = [self.footerView getFooterHeight];
    [self.tableView reloadData];
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

#pragma mark - ItemTitleCellDelegate

-(void)cell:(UIView *)imgView didClickImageAtImageUrl:(NSString *)imageurl {
    
    if ([self.delegate respondsToSelector:@selector(textCell:didClickImageAtImageUrl:)]) {
        [self.delegate textCell:imgView didClickImageAtImageUrl:imageurl];
    }
    
}

@end
