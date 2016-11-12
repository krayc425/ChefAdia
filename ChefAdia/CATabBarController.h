//
//  CATabBarController.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/4.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAMeNotLoginViewController.h"
#import "CAMeLoginTableViewController.h"
#import "CAFindTableViewController.h"
#import "CAFoodTableViewController.h"

@interface CATabBarController : UITabBarController <UITabBarControllerDelegate>

@property (nonnull, nonatomic) IBOutlet UINavigationItem *naviItem;

@property (nonnull) CAFoodTableViewController *caFoodTableViewController;
@property (nonnull) CAFindTableViewController *caFindTableViewController;
@property (nonnull) CAMeNotLoginViewController *caMeNotLoginViewController;
@property (nonnull) CAMeLoginTableViewController *caMeLoginTableViewController;

@end
