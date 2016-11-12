//
//  CAMeConfigureTableViewController.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/8.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAMeConfigureTableViewController : UITableViewController

@property (nonnull, nonatomic) IBOutlet UILabel *destinationInstructionLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *destinationLabel;

@property (nonnull, nonatomic) IBOutlet UILabel *phoneInstructionLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *phoneLabel;

- (void)editDestination;
- (void)editPhone;
    
@end
