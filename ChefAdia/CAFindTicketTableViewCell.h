//
//  CAFindTicketTableViewCell.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/12/9.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BuyTicketDelegate<NSObject>

- (void)buyTicket:(_Nonnull id)sender;

@end

@interface CAFindTicketTableViewCell : UITableViewCell

@property (nonatomic, nonnull) id<BuyTicketDelegate> delegate;

@property (nonnull, nonatomic) IBOutlet UILabel *IDLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonnull, nonatomic) IBOutlet UIButton *buyButton;
@property (nonnull, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (nonnull, nonatomic) IBOutlet UILabel *expireInstructionLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *expireLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *dailyAmountInstructionLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *dailyAmountLabel;

@end
