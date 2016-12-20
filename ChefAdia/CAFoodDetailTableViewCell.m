//
//  CAFoodDetailTableViewCell.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/8.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAFoodDetailTableViewCell.h"
#import "Utilities.h"

@implementation CAFoodDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSString *fontName = [Utilities getFont];
    UIColor *color = [Utilities getColor];
    
    [self.currNumLabel setFont:[UIFont fontWithName:fontName size:20]];
    [self.nameLabel setFont:[UIFont fontWithName:fontName size:15]];
    [self.priceLabel setFont:[UIFont fontWithName:fontName size:25]];
    [self.goodLabel setFont:[UIFont fontWithName:fontName size:12]];
    [self.badLabel setFont:[UIFont fontWithName:fontName size:12]];
    [self.descriptionLabel setFont:[UIFont fontWithName:fontName size:12]];
    
    [self.descriptionLabel setTextColor:[UIColor grayColor]];
    
    [self.extraButton.titleLabel setFont:[UIFont fontWithName:fontName size:15]];
    
    [self.currNumLabel setTextColor:color];
    [self.goodLabel setTextColor:color];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)addAction:(id)sender{
    int i = [[_currNumLabel text] intValue];
    i = i + 1;
    [self.currNumLabel setText:[NSString stringWithFormat:@"%d",i]];
    [self.delegate addNum:self];
}

- (IBAction)minusAction:(id)sender{
    int i = [[_currNumLabel text] intValue];
    if(i > 0){
        i = i - 1;
        [self.currNumLabel setText:[NSString stringWithFormat:@"%d",i]];
        [self.delegate minusNum:self];
    }
}

- (IBAction)selectExtra:(id)sender{
    [self.delegate selectExtra:self];
}

@end
