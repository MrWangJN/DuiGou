//
//  TodayHistoryTableViewCell.m
//  DuiHao
//
//  Created by wjn on 2016/12/29.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "TodayHistoryTableViewCell.h"
#import "CircleScrollView.h"


@interface TodayHistoryTableViewCell()<CircleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *typeImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet CircleScrollView *circleSV;

@property (strong, nonatomic) NSArray *titles;

@end

@implementation TodayHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.circleSV.delegate = self;
    self.circleSV.duringTime = 4;
    
    [self.timeL setText:[self getNowTime]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)getNowTime {
    NSDate *senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}

- (void)setTodayHistoryLayout:(TodayHistoryLayout *)todayHistoryLayout {
    if (!todayHistoryLayout) {
        return;
    }
    
    _todayHistoryLayout = todayHistoryLayout;
    
    self.height = todayHistoryLayout.height;
    [self.circleSV textes:todayHistoryLayout.titles];
}

- (void)didClickImageAtIndex:(NSInteger)index scrollView:(CircleScrollView *)scrollView {
    
    if ([self.delegate respondsToSelector:@selector(didClickTodayHistory:)]) {
        if (_todayHistoryLayout && _todayHistoryLayout.titles.count > index) {
            [self.delegate didClickTodayHistory:_todayHistoryLayout.titles[index]];
        }
    }
    
}

@end
