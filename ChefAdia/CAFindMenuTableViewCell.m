//
//  CAFindMenuTableViewCell.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/12/13.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAFindMenuTableViewCell.h"
#import "Utilities.h"

@implementation CAFindMenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.nameLabel setFont:[UIFont fontWithName:[Utilities getFont] size:20]];
    [self.priceLabel setFont:[UIFont fontWithName:[Utilities getBoldFont] size:30]];
    [self.priceLabel setTextColor:[Utilities getColor]];
}

@end
