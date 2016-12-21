//
//  CAFindMenuOrderViewController.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/12/16.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAFindMenuOrderViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonnull, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonnull, nonatomic) IBOutlet UILabel *priceInstructionLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (nonnull, nonatomic) IBOutlet UITableView *menuTableView;

@property (nonnull, nonatomic) NSString *menuid;
@property (nonnull, nonatomic) NSString *menuName;
@property (nonatomic) double menuPrice;

@property (nonnull, nonatomic) NSMutableArray *typeArr;
@property (nonnull, nonatomic) NSMutableArray *numArr;
@property (nonnull, nonatomic) NSMutableArray *foodArr;

@property (nonnull, nonatomic) IBOutlet UIButton *visaButton;
@property (nonnull, nonatomic) IBOutlet UIButton *cashButton;

@end
