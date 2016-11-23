//
//  SAHeightenLabel.m
//  SAFramework
//
//  Created by 王建男 on 15/3/10.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "SAHeightenLabel.h"

@implementation SAHeightenLabel

- (void)setTitle:(NSString *)title withSize:(CGFloat )textSize{
    
//    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[title dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//    self.text = attrStr.string;
    
//    title = [title stringByReplacingOccurrencesOfString:@"#00000001" withString:@"\""];
//    title = [title stringByReplacingOccurrencesOfString:@"#00000002" withString:@"\\"];
//    title = [title stringByReplacingOccurrencesOfString:@"#00000003" withString:@"\n\r"];
//    title = [title stringByReplacingOccurrencesOfString:@"#00000004" withString:@"\n"];
    
	self.text = title;
    self.numberOfLines = 0;
//	NSDictionary *fontDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:textSize],NSFontAttributeName, nil];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *fontDic = @{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
//    NSDictionary *fontDic = [NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName];
	CGSize size = [title boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:fontDic context:nil].size;
	[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height + 20)];
//    [self sizeToFit];
}

- (void)setOtherTitle:(NSString *)title withSize:(CGFloat)textSize {
    //    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[title dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    //    self.text = attrStr.string;
    
//    title = [title stringByReplacingOccurrencesOfString:@"#00000001" withString:@"\""];
//    title = [title stringByReplacingOccurrencesOfString:@"#00000002" withString:@"\\"];
//    title = [title stringByReplacingOccurrencesOfString:@"#00000003" withString:@"\n\r"];
//    title = [title stringByReplacingOccurrencesOfString:@"#00000004" withString:@"\n"];
    
    self.text = title;
    self.numberOfLines = 0;
    
    //	NSDictionary *fontDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:textSize],NSFontAttributeName, nil];
    NSDictionary *fontDic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:textSize] forKey:NSFontAttributeName];
    
    CGSize size = [title boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 43, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:fontDic context:nil].size;
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height)];
}

@end
