//
//  CAMeHistoryTableViewController.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/9.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAMeHistoryTableViewCell.h"

@interface CAMeHistoryTableViewController : UITableViewController <EasyOrderDelegate>

@property (nonatomic, nonnull) NSString *userID;

@property (nonatomic, nonnull) NSMutableArray *orderArr;

//@property (nonatomic, nonnull) NSString *orderID;
//@property (nonatomic) double price;
//@property (nonatomic, nonnull) NSString *time;

@end
