//
//  CAMeHistoryDetailTableViewController.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/11.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAMeHistoryDetailTableViewCell.h"

@interface CAMeHistoryDetailTableViewController : UITableViewController <CommentDelegate>

@property (nonatomic, nonnull) NSString *orderID;

@property (nonatomic, nonnull) IBOutlet UILabel *dateInstructionLabel;
@property (nonatomic, nonnull) IBOutlet UILabel *priceInstructionLabel;
@property (nonatomic, nonnull) IBOutlet UILabel *dateLabel;
@property (nonatomic, nonnull) IBOutlet UILabel *priceLabel;

@property (nonatomic, nonnull) NSMutableArray *foodArr;

@property (nonatomic, nonnull) NSMutableArray *commentArr;

@end
