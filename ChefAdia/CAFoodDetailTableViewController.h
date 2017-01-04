//
//  CAFoodDetailTableViewController.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/8.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAFoodDetailTableViewCell.h"
#import "CAFoodDetailExtraView.h"
#import "CAFoodCart.h"
#import "CAFoodMenu.h"

@interface CAFoodDetailTableViewController : UITableViewController <DetailDelegate, ExtraDelegate>

@property (nonnull, nonatomic) UIView *containerView;

@property (nonnull, nonatomic) IBOutlet UIImageView *titleImgView;

@property (nonnull, nonatomic) IBOutlet UINavigationItem *naviItem;
@property (nonnull, nonatomic) IBOutlet UILabel *numberLabel;

@property (nonnull, nonatomic) IBOutlet UIBarButtonItem *billCountItem;
@property (nonnull, nonatomic) IBOutlet UIBarButtonItem *buyItem;

@property (nonnull, nonatomic) CAFoodMenu *foodType;
@property (nonatomic) int foodNum;
//所有该类型食物的信息
@property (nonnull, nonatomic) NSMutableArray *foodArr;

@property (nonnull, nonatomic) CAFoodCart *foodCart;

- (void)loadFood;

@end
