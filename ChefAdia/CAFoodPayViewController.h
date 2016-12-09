//
//  CAFoodPayViewController.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/9.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAFoodPayViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonnull, nonatomic) IBOutlet UILabel *bowlInstructionLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *ticketInstructionLabel;

@property (nonnull, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonnull, nonatomic) NSString *price;
@property (nonnull, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic) int totalNum;
@property (nonnull, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonnull, nonatomic) NSString *time;

@property (nonnull, nonatomic) IBOutlet UITableView *tableView;

@property (nonnull, nonatomic) IBOutlet UIButton *visaButton;
@property (nonnull, nonatomic) IBOutlet UIButton *cashButton;

@property (nonnull, nonatomic) IBOutlet UISwitch *bowlSwitch;
@property (nonnull, nonatomic) IBOutlet UISwitch *ticketSwitch;

@property (nonnull, nonatomic) NSArray *payFoodArr;

@end
