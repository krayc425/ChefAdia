//
//  CAFoodDetailExtraView.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/12/11.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAFoodDetailTableViewCell.h"

@protocol ExtraDelegate <NSObject>

- (void)updatePrice;

@end

@interface CAFoodDetailExtraView : UIView <UITableViewDataSource,UITableViewDelegate,DetailDelegate>

@property (nonatomic, nonnull) id<ExtraDelegate> delegate;

@property (nonnull, nonatomic) UIButton *containerButton;
@property (nonnull, nonatomic) UIButton *okButton;

@property (nonnull, nonatomic) UITableView *tableView;

@property (nonatomic) int extraNum;
@property (nonatomic, nonnull) NSMutableArray *extraArr;

- (_Nonnull id)initWithFrame:(CGRect)frame withExtra:(NSArray *_Nonnull)extraArr;
- (void)showInView:(UIView *_Nonnull)view;

@end
