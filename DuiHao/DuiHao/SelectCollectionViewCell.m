//
//  SelectCollectionViewCell.m
//  StudyAssisTant
//
//  Created by 王建男 on 15/3/20.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SelectCollectionViewCell.h"
#import "ItemTitleStatusLayout.h"
#import "OptionStatusLayout.h"

@implementation SelectCollectionViewCell

- (void)awakeFromNib {
    [self addSubview:self.tableView];
}

- (void)setItemModel:(ItemModel *)itemModel {
    
    if (!itemModel) {
        return ;
    }
    
    _itemModel = itemModel;
    
    [self.datasource removeAllObjects];
    
    ItemTitleStatusLayout *itemTitleStatusLayout = [[ItemTitleStatusLayout alloc] initWithStatus:_itemModel];
    [self.datasource addObject:itemTitleStatusLayout];
    
    for (OptionModel *optionModel in _itemModel.optionArray) {
        OptionStatusLayout *optionStatusLayout = [[OptionStatusLayout alloc] initWithStatus:optionModel];
        [self.datasource addObject:optionStatusLayout];
    }
    
    if ([self.itemModel.answer hasPrefix:@"答案："]) {
        [self answerPress];
    } else {
        [self footerViewReset];
    }
    
    self.select = _itemModel.select;
    self.otherSelect = _itemModel.select;
    
    [self.tableView reloadData];
}

- (void)layoutSubviews {
//    self.tableView.width = self.width;
//    self.tableView.height = self.height;
    self.tableView.frame = self.bounds;
//    self.tableView.height -= 64;
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

- (MutiSelFooterView *)footerView {
    if (!_footerView) {
        self.footerView = [[NSBundle mainBundle] loadNibNamed:@"MutiSelFooterView" owner:self options:nil][0];
        _footerView.cerTainButton.hidden = YES;
        _footerView.delegate = self;
        [_footerView.answerBtu addTarget:self action:@selector(answerPress) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

- (void)footerViewReset {
    [self.footerView setanswer:@"答案：" withAnalysis:@"解析：" withImageURL:nil];
    self.tableView.sectionFooterHeight = [self.footerView getFooterHeight];
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
    
//    if (!self.datasource || !self.datasource.count) {
//        return 0;
//    }
    
    if (indexPath.row == 0) {
        return ((ItemTitleStatusLayout *)self.datasource[indexPath.row]).height;
    } else {
        return ((OptionStatusLayout *)self.datasource[indexPath.row]).height;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        ItemTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemTitleTableViewCell"];
        cell.delegate = self;
        if (self.isExam) {
            [cell.section setHidden:YES];
            [cell.fromLabel setHidden:YES];
        }
        if (self.datasource.count > indexPath.row && self.datasource.count) {
//            [cell.titleLabel setTitle:self.datasource[indexPath.row] withSize:17];
//            cell.section.text = [NSString stringWithFormat:@"第%@章 第%@节", self.itemModel.chapter, self.itemModel.section];
            
            [cell setLayout:[self.datasource firstObject]];
        }
        return cell;
    } else {
        OptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"optionTableViewCell"];
        cell.delegate = self;
        if (self.datasource.count > indexPath.row) {
            [cell setLayout:self.datasource[indexPath.row]];
            [cell.selectLabel setSelectText:[NSString stringWithFormat:@"%c", (char)('@' + indexPath.row)]];
            if (self.select == indexPath.row) {
                [cell.selectLabel select];
            } else {
                [cell.selectLabel unSelect];
            }
        }
        
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row > 0) {
//        if ([self.datasource.lastObject isEqualToString:self.itemModel.answer] && (self.datasource.count == (indexPath.row + 1))) {
//            return;
//        }
        NSIndexPath *otherIndexpath = [NSIndexPath indexPathForRow:self.otherSelect inSection:indexPath.section];
        self.select = indexPath.row;
        
        [tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, otherIndexpath, nil] withRowAnimation:UITableViewRowAnimationNone];
        self.itemModel.select = self.select;
        self.otherSelect = indexPath.row;
        [self didSelect:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return NO;
    } else {
        return YES;
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

#pragma mark - ItemTitleCellDelegate

-(void)cell:(UIView *)imgView didClickImageAtImageUrl:(NSString *)imageurl {
    
    if ([self.delegate respondsToSelector:@selector(textCell:didClickImageAtImageUrl:)]) {
        [self.delegate textCell:imgView didClickImageAtImageUrl:imageurl];
    }
}

@end
