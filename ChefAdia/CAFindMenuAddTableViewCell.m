//
//  CAFindMenuAddTableViewCell.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/12/15.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAFindMenuAddTableViewCell.h"
#import "Utilities.h"

@implementation CAFindMenuAddTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self.nameLabel setFont:[UIFont fontWithName:[Utilities getFont] size:20]];
}

@end
