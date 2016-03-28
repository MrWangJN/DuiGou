//
//  MultiSelCollectionViewCell.m
//  StudyAssisTant
//
//  Created by wjn on 15/9/20.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "MultiSelCollectionViewCell.h"
#import "MutiSelFooterView.h"

@implementation MultiSelCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    //	[self.selectA.titleLabel setNumberOfLines:0];
    //	[self.selectB.titleLabel setNumberOfLines:0];
    //	[self.selectC.titleLabel setNumberOfLines:0];
    //	[self.selectD.titleLabel setNumberOfLines:0];
    [self addSubview:self.tableView];
}

- (void)setItemModel:(ItemModel *)itemModel {
    
    _itemModel = itemModel;
    [self.datasource removeAllObjects];
    [self.answers removeAllObjects];
    
    [self.datasource addObject:itemModel.question];
    if (itemModel.answerA.length) {
        [self.datasource addObject:itemModel.answerA];
    }
    if (itemModel.answerB.length) {
        [self.datasource addObject:itemModel.answerB];
    }
    if (itemModel.answerC.length) {
        [self.datasource addObject:itemModel.answerC];
    }
    if (itemModel.answerD.length) {
        [self.datasource addObject:itemModel.answerD];
    }
    if (itemModel.answerE.length) {
        [self.datasource addObject:itemModel.answerE];
    }
    if (itemModel.answerF.length) {
        [self.datasource addObject:itemModel.answerF];
    }
    if (itemModel.answerG.length) {
        [self.datasource addObject:itemModel.answerG];
    }
    if (itemModel.answerH.length) {
        [self.datasource addObject:itemModel.answerH];
    }
    if (itemModel.answerI.length) {
        [self.datasource addObject:itemModel.answerI];
    }
    
    if ([itemModel.answer hasPrefix:@"本题答案"] && !self.isExam) {
        [self.datasource addObject:itemModel.answer];
    }
    
    self.answers = [NSMutableArray arrayWithArray:self.itemModel.answers];
    
    [self.tableView reloadData];
}

- (void)layoutSubviews {
    self.tableView.frame = self.bounds;
    self.tableView.height -= 64;
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

- (void)sort {
    if (self.answers.count < 2) {
        return;
    }
    for (int i = 0; i < self.answers.count - 1; i++) {
        for (int j = 0; j < self.answers.count - 1 - i; j++) {
            NSIndexPath *onePath = self.answers[j];
            NSIndexPath *twoPath = self.answers[j + 1];
            if (onePath.row > twoPath.row) {
                NSIndexPath *path = self.answers[j];
                self.answers[j] = self.answers[j + 1];
                self.answers[j + 1] = path;
            }
        }
    }
}

- (void)cerTainButtonDidPress {
    
    NSMutableString *string = [NSMutableString string];
    
    for (NSIndexPath *indexPath in self.answers) {
            if (indexPath.row == 1) {
                [string appendString:@"/A"];
            } else if (indexPath.row == 2) {
                [string appendString:@"/B"];
            } else if (indexPath.row == 3 ) {
                [string appendString:@"/C"];
            } else if (indexPath.row == 4 ) {
                [string appendString:@"/D"];
            } else if (indexPath.row == 5 ) {
                [string appendString:@"/E"];
            } else if (indexPath.row == 6 ) {
                [string appendString:@"/F"];
            } else if (indexPath.row == 7 ) {
                [string appendString:@"/G"];
            } else if (indexPath.row == 8 ) {
                [string appendString:@"/H"];
            } else if (indexPath.row == 9 ) {
                [string appendString:@"/I"];
            }
    }
    if (string.length) {
        NSRange range = {0, 1};
        [string deleteCharactersInRange:range];
    }
    
    if ([string isEqualToString:self.itemModel.answer] || [[NSString stringWithFormat:@"%@%@", @"本题答案：", string] isEqualToString:self.itemModel.answer]) {
        
        if ([self.delegate respondsToSelector:@selector(selectCorrectAnswer)]) {
            [self.delegate selectCorrectAnswer];
        }
    } else {
        [self.delegate selectWrongAnswer];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.optionTableViewCell = [UINib nibWithNibName:@"OptionTableViewCell" bundle:nil];
        self.itemTitleTableViewCell = [UINib nibWithNibName:@"ItemTitleTableViewCell" bundle:nil];
        [_tableView registerNib:self.optionTableViewCell forCellReuseIdentifier:@"optionTableViewCell"];
        [_tableView registerNib:self.itemTitleTableViewCell forCellReuseIdentifier:@"itemTitleTableViewCell"];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.isExam) {
        return CGFLOAT_MIN;
    } else {
        return 60;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (self.isExam) {
        return nil;
    }
    MutiSelFooterView *footer = [[NSBundle mainBundle] loadNibNamed:@"MutiSelFooterView" owner:self options:nil][0];
    [footer.cerTainButton addTarget:self action:@selector(cerTainButtonDidPress) forControlEvents:UIControlEventTouchUpInside];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ItemTitleTableViewCell *cell = (ItemTitleTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        [cell layoutIfNeeded];
        [cell setNeedsLayout];
        return [cell textHeight];
    } else {
        OptionTableViewCell *cell = (OptionTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        [cell layoutIfNeeded];
        [cell setNeedsLayout];
        return [cell textHeight];
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
    }
    else {
        OptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"optionTableViewCell"];
        if (self.datasource.count > indexPath.row) {
            [cell.option setOtherTitle:self.datasource[indexPath.row] withSize:17];
      
            if ([self.answers containsObject:indexPath]) {
                [cell.icon setImage:[UIImage imageNamed:@"Select"]];
            } else if ([self.datasource.lastObject isEqualToString:self.itemModel.answer] && (self.datasource.count == (indexPath.row + 1))) {
                [cell.icon setImage:[UIImage imageNamed:@"OurAnswer"]];
            } else {
                [cell.icon setImage:[UIImage imageNamed:@"Unselect"]];
            }
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
    if (indexPath.row > 0) {
        if ([self.datasource.lastObject isEqualToString:self.itemModel.answer] && (self.datasource.count == (indexPath.row + 1))) {
            return;
        }

        if ([self.answers containsObject:indexPath]) {
            [self.answers removeObject:indexPath];
        } else {
            [self.answers addObject:indexPath];
        }
        [self sort];
        self.itemModel.answers = [NSMutableArray arrayWithArray:self.answers];
        [tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)didSelect:(NSIndexPath *)indexPath {
    //
    //    if ([self.delegate respondsToSelector:@selector(selectWrongAnswer)]) {
    //        [self.delegate selectWrongAnswer];
    //    }
    //    NSString *string = [self.itemModel.answer substringFromIndex:self.itemModel.answer.length - 1];
    //    if (indexPath.row == 1) {
    //        //		_itemModel.my_Answer = @"A";
    //        if ([string isEqualToString:@"A"]) {
    //            if ([self.delegate respondsToSelector:@selector(selectCorrectAnswer)]) {
    //                [self.delegate selectCorrectAnswer];
    //            }
    //        }
    //    } else if (indexPath.row == 2) {
    //        //		_itemModel.my_Answer = @"B";
    //        if ([string isEqualToString:@"B"]) {
    //            if ([self.delegate respondsToSelector:@selector(selectCorrectAnswer)]) {
    //                [self.delegate selectCorrectAnswer];
    //            }
    //        }
    //    } else if (indexPath.row == 3 ) {
    //        //		_itemModel.my_Answer = @"C";
    //        if ([string isEqualToString:@"C"]) {
    //            if ([self.delegate respondsToSelector:@selector(selectCorrectAnswer)]) {
    //                [self.delegate selectCorrectAnswer];
    //            }
    //        }
    //    } else if (indexPath.row == 4 ) {
    //        //		_itemModel.my_Answer = @"D";
    //        if ([string isEqualToString:@"D"]) {
    //            if ([self.delegate respondsToSelector:@selector(selectCorrectAnswer)]) {
    //                [self.delegate selectCorrectAnswer];
    //            }
    //        }
    //    }
    //
    //    if (self.isExam) {
    //        if ([self.delegate respondsToSelector:@selector(selectCorrectAnswer)]) {
    //            [self.delegate selectCorrectAnswer];
    //        }
    //    }
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


@end
