//
//  CAMeHistoryTableViewCell.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/9.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAMeHistoryTableViewCell : UITableViewCell

@property (nonnull, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *numberLabel;

@property (nonnull, nonatomic) IBOutlet UIButton *badButton;
@property (nonnull, nonatomic) IBOutlet UIButton *goodButton;
@property (nonnull, nonatomic) IBOutlet UIButton *repeatButton;

@end
