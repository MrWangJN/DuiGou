//
//  ExamAndJobTableViewCell.m
//  DuiHao
//
//  Created by wjn on 2017/3/16.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "ExamAndJobTableViewCell.h"

@implementation ExamAndJobTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setExamAndJobLayout:(ExamAndJobStatusLayout *)examAndJobLayout {
    if (!examAndJobLayout) {
        return;
    }
    _examAndJobLayout = examAndJobLayout;
    
    self.height = examAndJobLayout.height;
    
    NSString *string = [NSString stringWithFormat:@"%@-%@", examAndJobLayout.model.name, examAndJobLayout.model.course];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *attrsDictionary = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
    NSDictionary *attrsDictionary1 = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName: SECONDARY};
    
    [attributedString addAttributes:attrsDictionary range:NSMakeRange(0, examAndJobLayout.model.name.length)];
    [attributedString addAttributes:attrsDictionary1 range:NSMakeRange(examAndJobLayout.model.name.length, examAndJobLayout.model.course.length + 1)];
                                    
    [self.titleL setAttributedText:attributedString];
    // [self.titleL setText:examAndJobLayout.model.exam];

    NSString *time;
    
    if (examAndJobLayout.model.close_time) {
        time = [NSString stringWithFormat:@"%@- %@", examAndJobLayout.model.created_at, examAndJobLayout.model.close_time];
    } else {
        time = examAndJobLayout.model.created_at;
    }
    
    [self.timeL setText:time];
    
    [self.teacherNameL setText:examAndJobLayout.model.real_name];
    
   if (examAndJobLayout.model.isOpen.intValue == 0) {
       [self.statusImageV setImage:[UIImage imageNamed:@"Open"]];
   } else if (examAndJobLayout.model.isOpen.intValue == 1) {
       [self.statusImageV setImage:[UIImage imageNamed:@"Closed"]];
   } else {
       [self.statusImageV setImage:[UIImage imageNamed:@"HaveNot"]];
   }
    
}

@end
