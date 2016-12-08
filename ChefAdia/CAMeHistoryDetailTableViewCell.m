
//
//  CAMeHistoryDetailTableViewCell.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/12/8.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAMeHistoryDetailTableViewCell.h"
#import "Utilities.h"

@implementation CAMeHistoryDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSString *fontName = [Utilities getFont];
    
    [self.nameLabel setFont:[UIFont fontWithName:fontName size:25]];
    [self.priceLabel setFont:[UIFont fontWithName:fontName size:20]];
    [self.numLabel setFont:[UIFont fontWithName:fontName size:20]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)goodComment:(id)sender{
    [self.delegate goodComment:self];
}

- (IBAction)badComment:(id)sender{
    [self.delegate badComment:self];
}

@end
