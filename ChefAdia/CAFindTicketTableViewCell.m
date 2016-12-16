//
//  CAFindTicketTableViewCell.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/12/9.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAFindTicketTableViewCell.h"
#import "Utilities.h"

@implementation CAFindTicketTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSString *fontName = [Utilities getFont];
    
    [self.nameLabel setFont:[UIFont fontWithName:fontName size:20]];
    [self.priceLabel setFont:[UIFont fontWithName:fontName size:20]];
    [self.priceLabel setTextColor:[Utilities getColor]];
    [self.IDLabel setFont:[UIFont fontWithName:fontName size:13]];
    [self.descriptionLabel setFont:[UIFont fontWithName:fontName size:13]];
    [self.buyButton.titleLabel setFont:[UIFont fontWithName:fontName size:15]];
    
    [self.expireInstructionLabel setFont:[UIFont fontWithName:fontName size:15]];
    [self.expireInstructionLabel setTextColor:[Utilities getColor]];
    [self.dailyAmountInstructionLabel setFont:[UIFont fontWithName:fontName size:15]];
    [self.dailyAmountInstructionLabel setTextColor:[Utilities getColor]];
    [self.expireLabel setFont:[UIFont fontWithName:fontName size:20]];
    [self.dailyAmountLabel setFont:[UIFont fontWithName:fontName size:20]];
}

- (IBAction)buyTicket:(id)sender{
    [self.delegate buyTicket:self];
}

@end
