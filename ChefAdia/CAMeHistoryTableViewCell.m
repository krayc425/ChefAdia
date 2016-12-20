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
    [self.priceLabel setFont:[UIFont fontWithName:fontName size:25]];
    [self.orderIDLabel setFont:[UIFont fontWithName:fontName size:13]];
    [self.custLabel setFont:[UIFont fontWithName:fontName size:13]];
    
    _easyOrderButton.titleLabel.font = [UIFont fontWithName:[Utilities getBoldFont] size:15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)easyorderAction:(id)sender{
    [[NSUserDefaults standardUserDefaults] setValue:[self.orderIDLabel text] forKey:@"easy_order_id"];
    [self.delegate setEasyOrder:self];
}

- (void)setIsEasyOrder:(Boolean)isEasyOrder{
    if(isEasyOrder){
        [self.easyOrderButton setBackgroundImage:[UIImage imageNamed:@"BUTTON_BG_DEFAULT_SHORT"] forState:UIControlStateNormal];
        [self.easyOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [self.easyOrderButton setBackgroundImage:[UIImage imageNamed:@"BUTTON_BG_GRAY_SHORT"] forState:UIControlStateNormal];
        [self.easyOrderButton setTitleColor:[Utilities getColor] forState:UIControlStateNormal];
    }
}

@end
