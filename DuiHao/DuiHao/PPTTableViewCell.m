//
//  PPTTableViewCell.m
//  DuiHao
//
//  Created by wjn on 2017/3/14.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "PPTTableViewCell.h"

@implementation PPTTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPptModel:(PPTModel *)pptModel {
    _pptModel = pptModel;
    [self.titleL setText:pptModel.title];
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    filePath = [NSString stringWithFormat:@"%@/%ld.pdf", filePath, [pptModel.downloadurl hash]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [self.downloadB setImage:[UIImage imageNamed:@"DownloadSuccess"] forState:UIControlStateNormal];
        self.downloadB.userInteractionEnabled = NO;

    } else {
        [self.downloadB setImage:[UIImage imageNamed:@"Download"] forState:UIControlStateNormal];
        self.downloadB.userInteractionEnabled = YES;

    }
}

- (void)setCvModel:(CourseVideoModel *)cvModel {
    _cvModel = cvModel;
    [self.titleL setText:cvModel.title];
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    filePath = [NSString stringWithFormat:@"%@/%@", filePath, cvModel.downloadurl];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [self.downloadB setImage:[UIImage imageNamed:@"DownloadSuccess"] forState:UIControlStateNormal];
        self.downloadB.userInteractionEnabled = NO;
        
    } else {
        [self.downloadB setImage:[UIImage imageNamed:@"Download"] forState:UIControlStateNormal];
        self.downloadB.userInteractionEnabled = YES;
        
    }
}

- (IBAction)downloadSender:(id)sender {
    
    if (self.pptModel || self.pptModel.downloadurl) {
        [SANetWorkingTask downloadWithPost:self.pptModel.downloadurl parmater:nil block:^(id result) {
            
            if ([result isEqualToString:@"success"]) {
                [self.downloadB setImage:[UIImage imageNamed:@"DownloadSuccess"] forState:UIControlStateNormal];
                self.downloadB.userInteractionEnabled = NO;
            }
        }];
    }

    if (self.cvModel || self.cvModel.downloadurl) {
        [SANetWorkingTask downloadWithPost:self.cvModel.downloadurl parmater:nil block:^(id result) {
            if ([result isEqualToString:@"success"]) {
                [self.downloadB setImage:[UIImage imageNamed:@"DownloadSuccess"] forState:UIControlStateNormal];
                self.downloadB.userInteractionEnabled = NO;
            }
        }];
    }
}

@end
