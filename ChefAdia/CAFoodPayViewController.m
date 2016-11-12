//
//  CAFoodPayViewController.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/9.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAFoodPayViewController.h"
#import "Utilities.h"
#import "CAFoodPayTableViewCell.h"
#import "CAFoodDetailInCart.h"

@interface CAFoodPayViewController (){
    NSString *fontName;
}

@end

@implementation CAFoodPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    fontName = [Utilities getFont];
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [_priceLabel setFont:[UIFont fontWithName:fontName size:40]];
    [_timeLabel setFont:[UIFont fontWithName:fontName size:15]];
    [_countLabel setFont:[UIFont fontWithName:fontName size:15]];
    
    //price label
    [_priceLabel setText:_price];
    //time label
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateString = [fmt stringFromDate:now];
    [_timeLabel setText:dateString];
    //count label
    [_countLabel setText:[NSString stringWithFormat:@"(%d ITEM%s)",_totalNum, _totalNum <= 1 ? "" : "S"]];
    
    _cashButton.titleLabel.font = [UIFont fontWithName:fontName size:15];
    _visaButton.titleLabel.font = [UIFont fontWithName:fontName size:15];
    
    //GET FOOD FROM CART
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //TODO
    return [_payFoodArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CAFoodPayTableViewCell";
    UINib *nib = [UINib nibWithNibName:@"CAFoodPayTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    CAFoodPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    //TODO
    //配置 cell
    CAFoodDetailInCart *food = _payFoodArr[indexPath.row];
    cell.nameLabel.text = food.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"%.2f",food.price];
    cell.numLabel.text = [NSString stringWithFormat:@"%d",food.number];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 10;
}

@end
