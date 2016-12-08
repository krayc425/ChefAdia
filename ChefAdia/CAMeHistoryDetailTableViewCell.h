//
//  CAMeHistoryDetailTableViewCell.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/12/8.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentDelegate<NSObject>

- (void)goodComment:(_Nonnull id)sender;
- (void)badComment:(_Nonnull id)sender;

@end

@interface CAMeHistoryDetailTableViewCell : UITableViewCell

@property (nonatomic, nonnull) id<CommentDelegate> delegate;

@property (nonnull, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *numLabel;

@end
