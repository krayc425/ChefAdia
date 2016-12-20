//
//  CAMeHistoryTableViewCell.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/9.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EasyOrderDelegate<NSObject>

- (void)setEasyOrder:(_Nonnull id)sender;

@end

@interface CAMeHistoryTableViewCell : UITableViewCell

@property (nonatomic, nonnull) id<EasyOrderDelegate> delegate;

@property (nonnull, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *orderIDLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *custLabel;

@property (nonnull, nonatomic) IBOutlet UIButton *easyOrderButton;

- (void)setIsEasyOrder:(Boolean)isEasyOrder;

@end
