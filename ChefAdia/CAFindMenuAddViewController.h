//
//  CAFindMenuAddViewController.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/12/15.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAFindMenuAddViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonnull, nonatomic) IBOutlet UILabel *stepLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *priceInstructionLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *numLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (nonnull, nonatomic) IBOutlet UIButton *prevButton;
@property (nonnull, nonatomic) IBOutlet UIButton *nextButton;
@property (nonnull, nonatomic) IBOutlet UITableView *menuTableView;
@property (nonnull, nonatomic) IBOutlet UIStackView *menuStackView;

@property (nonnull, nonatomic) NSArray *typeArr;

//all food
@property (nonnull, nonatomic) NSMutableArray *typeFoodArr;
//current type food
@property (nonnull, nonatomic) NSMutableArray *filteredFoodArr;

@property (nonnull, nonatomic) NSMutableArray *chosenNumArr;
@property (nonnull, nonatomic) NSMutableArray *chosenFoodArr;

@property (nonatomic) int currentStep;

@end
