//
//  CAFindMenuListViewController.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/12/16.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAFindMenuListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonnull, nonatomic) IBOutlet UILabel *submitLabel;

@property (nonnull, nonatomic) IBOutlet UILabel *priceInstructionLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (nonnull, nonatomic) IBOutlet UIStackView *nameStackView;
@property (nonnull, nonatomic) IBOutlet UITextField *nameText;

@property (nonnull, nonatomic) IBOutlet UITableView *menuTableView;
@property (nonnull, nonatomic) IBOutlet UIButton *submitButton;

@property (nonnull, nonatomic) NSMutableArray *typeArr;
@property (nonnull, nonatomic) NSMutableArray *numArr;
@property (nonnull, nonatomic) NSMutableArray *foodArr;
@property (nonatomic) double totalPrice;

@end
