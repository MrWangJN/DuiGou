//
//  SelectCollectionViewCell.m
//  StudyAssisTant
//
//  Created by 王建男 on 15/3/20.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SelectCollectionViewCell.h"

@implementation SelectCollectionViewCell

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
    if (itemModel.question) {
        [self.datasource addObject:itemModel.question];
    }
    if (itemModel.answerA) {
        [self.datasource addObject:itemModel.answerA];
    }
    if (itemModel.answerB) {
        [self.datasource addObject:itemModel.answerB];
    }
    if (itemModel.answerC) {
        [self.datasource addObject:itemModel.answerC];
    }
    if (itemModel.answerD) {
        [self.datasource addObject:itemModel.answerD];
    }
    if ([itemModel.answer hasPrefix:@"本题答案"] && !self.isExam) {
        [self.datasource addObject:itemModel.answer];
    }
    
    self.select = itemModel.select;
    self.otherSelect = itemModel.select;
    
    [self.tableView reloadData];
}

- (void)layoutSubviews {
//    self.tableView.width = self.width;
//    self.tableView.height = self.height;
    self.tableView.frame = self.bounds;
    self.tableView.height -= 64;
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
    } else {
        OptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"optionTableViewCell"];
        if (self.datasource.count > indexPath.row) {
            [cell.option setOtherTitle:self.datasource[indexPath.row] withSize:17];
            if (self.select == indexPath.row) {
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
        NSIndexPath *otherIndexpath = [NSIndexPath indexPathForRow:self.otherSelect inSection:indexPath.section];
        self.select = indexPath.row;
        
        [tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, otherIndexpath, nil] withRowAnimation:UITableViewRowAnimationNone];
        self.itemModel.select = self.select;
        self.otherSelect = indexPath.row;
        [self didSelect:indexPath];
    }
}

- (void)didSelect:(NSIndexPath *)indexPath {
	
    if ([self.delegate respondsToSelector:@selector(selectWrongAnswer)]) {
        [self.delegate selectWrongAnswer];
    }
    NSString *string = [self.itemModel.answer substringFromIndex:self.itemModel.answer.length - 1];
	if (indexPath.row == 1) {
		_itemModel.my_Answer = @"A";
		if ([string isEqualToString:@"A"]) {
			if ([self.delegate respondsToSelector:@selector(selectCorrectAnswer)]) {
				[self.delegate selectCorrectAnswer];
			}
		}
	} else if (indexPath.row == 2) {
		_itemModel.my_Answer = @"B";
		if ([string isEqualToString:@"B"]) {
			if ([self.delegate respondsToSelector:@selector(selectCorrectAnswer)]) {
				[self.delegate selectCorrectAnswer];
			}
		}
	} else if (indexPath.row == 3 ) {
		_itemModel.my_Answer = @"C";
		if ([string isEqualToString:@"C"]) {
			if ([self.delegate respondsToSelector:@selector(selectCorrectAnswer)]) {
				[self.delegate selectCorrectAnswer];
			}
		}
	} else if (indexPath.row == 4 ) {
		_itemModel.my_Answer = @"D";
		if ([string isEqualToString:@"D"]) {
			if ([self.delegate respondsToSelector:@selector(selectCorrectAnswer)]) {
				[self.delegate selectCorrectAnswer];
			}
		}
    }
    
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

@end
