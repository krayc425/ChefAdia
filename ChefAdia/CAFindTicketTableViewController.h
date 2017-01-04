//
//  CAFindTicketTableViewController.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/12/9.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAFindTicketTableViewCell.h"

@interface CAFindTicketTableViewController : UITableViewController <BuyTicketDelegate>

@property (nonnull, nonatomic) IBOutlet UIImageView *backgroundView;
@property (nonnull, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonnull, nonatomic) NSMutableArray *ticketArr;
@property (nonnull, nonatomic) NSMutableArray *myTicketArr;

- (void)loadTickets;

@end
