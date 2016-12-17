//
//  CAFindMenuListTableViewCell.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/12/16.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAFindMenuListTableViewCell : UITableViewCell

@property (nonnull, nonatomic) IBOutlet UILabel *typeLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *numLabel;

@property (nonnull, nonatomic) IBOutlet UIImageView *picView;

@end
