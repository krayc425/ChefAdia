//
//  CAFoodTableViewController.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/8.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAFoodTableViewController : UITableViewController

@property (nonnull, nonatomic) IBOutlet UIImageView *backgroundView;
@property (nonnull, nonatomic) IBOutlet UILabel *name1Label;
@property (nonnull, nonatomic) IBOutlet UILabel *name2Label;
@property (nonnull, nonatomic) IBOutlet UILabel *contactLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *menuLabel;

@property (nonnull, nonatomic) IBOutlet UIButton *easyOrderButton;

@property (nonnull, nonatomic) NSMutableArray *menuArr;

- (void)loadMenu;

@end
