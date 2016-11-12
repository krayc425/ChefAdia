//
//  CAFindItemTableViewCell.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/5.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAFindItemTableViewCell.h"
#import "Utilities.h"

@implementation CAFindItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _mainLabel.font = [UIFont fontWithName:[Utilities getFont] size:25];
    _subLabel.font = [UIFont fontWithName:[Utilities getFont] size:15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
