//
//  CAFindMenuListTableViewCell.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/12/16.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAFindMenuListTableViewCell.h"
#import "Utilities.h"

@implementation CAFindMenuListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSString *fontName = [Utilities getFont];
    [self.typeLabel setFont:[UIFont fontWithName:fontName size:15]];
    [self.nameLabel setFont:[UIFont fontWithName:fontName size:20]];
    [self.priceLabel setFont:[UIFont fontWithName:fontName size:20]];
    [self.numLabel setFont:[UIFont fontWithName:fontName size:20]];
}

@end
