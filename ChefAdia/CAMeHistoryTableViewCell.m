//
//  CAMeHistoryTableViewCell.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/9.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAMeHistoryTableViewCell.h"
#import "Utilities.h"

@implementation CAMeHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    NSString *fontName = [Utilities getFont];
    
    [self.timeLabel setFont:[UIFont fontWithName:fontName size:20]];
    [self.priceLabel setFont:[UIFont fontWithName:fontName size:30]];
    [self.nameLabel setFont:[UIFont fontWithName:fontName size:20]];
    [self.numberLabel setFont:[UIFont fontWithName:fontName size:15]];
    
    _easyOrderButton.titleLabel.font = [UIFont fontWithName:fontName size:15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
