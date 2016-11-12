//
//  CAFoodTableViewCell.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/8.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAFoodTableViewCell.h"
#import "Utilities.h"

@implementation CAFoodTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _nameLabel.font = [UIFont fontWithName:[Utilities getBoldFont] size:30];
    _numberLabel.font = [UIFont fontWithName:[Utilities getFont] size:20];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
