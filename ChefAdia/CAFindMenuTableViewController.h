//
//  CAFindMenuTableViewController.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/12/13.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAFindMenuTableViewController : UITableViewController

@property (nonnull, nonatomic) IBOutlet UIImageView *backgroundView;
@property (nonnull, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonnull, nonatomic) NSMutableArray *menuArr;

- (void)loadMMenu;

@end
