//
//  CAFoodTableViewCell.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/8.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAFoodTableViewCell : UITableViewCell

@property (nonatomic, nonnull) IBOutlet UIImageView *bgView;
@property (nonatomic, nonnull) IBOutlet UILabel *nameLabel;
@property (nonatomic, nonnull) IBOutlet UILabel *numberLabel;

@end
