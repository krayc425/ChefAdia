//
//  CAFoodDetailTableViewCell.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/8.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailDelegate<NSObject>

- (void)addNum:(_Nonnull id)sender;
- (void)minusNum:(_Nonnull id)sender;
- (void)selectExtra:(_Nonnull id)sender;

@end

@interface CAFoodDetailTableViewCell : UITableViewCell

@property (nonatomic, nonnull) id<DetailDelegate> delegate;

@property (nonnull, nonatomic) IBOutlet UIImageView *picView;

@property (nonnull, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *goodLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *badLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (nonnull, nonatomic) IBOutlet UIButton *minusButton;
@property (nonnull, nonatomic) IBOutlet UILabel *currNumLabel;
@property (nonnull, nonatomic) IBOutlet UIButton *addButton;

@property (nonnull, nonatomic) IBOutlet UIButton *extraButton;

@end
