//
//  CAFoodDetailTableViewController.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/8.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAFoodDetailTableViewController.h"
#import "CAFoodDetailTableViewCell.h"
#import "CAFoodPayViewController.h"
#import "CAFoodCart.h"
#import "CAFoodDetailInCart.h"
#import "CAFoodManager.h"
#import "Utilities.h"

@interface CAFoodDetailTableViewController (){
    NSString *fontName;
    UIColor *color;
}

@end

@implementation CAFoodDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    fontName = [Utilities getFont];
    color = [Utilities getColor];
    
    [self.naviItem setTitle:_foodType];
    _titleImgView.image = [UIImage imageNamed:@"FOOD_TITLE"];
    
    //加载所有食物数组
    _foodArr = [[CAFoodManager shareInstance] getListOfFoodWithType:_foodType];
    //
    _foodNum = 1;
    
    [self.numberLabel setText:[NSString stringWithFormat:@"%d SELECTION%s", _foodNum, _foodNum <= 1 ? "" : "S"]];
    [self.numberLabel setFont:[UIFont fontWithName:fontName size:20]];
    
    [self.billCountItem setTintColor:color];
    [self.buyItem setTintColor:color];
    
    _foodCart = [CAFoodCart shareInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setToolbarHidden:NO];
    [self.billCountItem setTitle:[NSString stringWithFormat:@"TOTAL BILL : $%.2f", [_foodCart getTotalPrice]]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setToolbarHidden:YES];
}

- (IBAction)payAction:(id)sender{
    [self performSegueWithIdentifier:@"paySegue" sender:nil];
}

#pragma mark - Cell Action

- (void)addNum:(id)sender{
    NSLog(@"add");
    CAFoodDetailTableViewCell *cell = (CAFoodDetailTableViewCell *)sender;
    int i = (int)cell.tag;
    //ADD IN FOOD CART
    [[CAFoodCart shareInstance] modifyFoodInCartWithName:[NSString stringWithFormat:@"%@_%d",_foodType,i+1]
                                                  andNum:1];
    //GET TOTAL PRICE FROM FOOD CART
    [self.billCountItem setTitle:[NSString stringWithFormat:@"TOTAL BILL : $%.2f", [_foodCart getTotalPrice]]];
}

- (void)minusNum:(id)sender{
    NSLog(@"minus");
    CAFoodDetailTableViewCell *cell = (CAFoodDetailTableViewCell *)sender;
    int i = (int)cell.tag;
    //MINUS IN FOOD CART
    [[CAFoodCart shareInstance] modifyFoodInCartWithName:[NSString stringWithFormat:@"%@_%d",_foodType,i+1]
                                                  andNum:-1];
    //GET TOTAL PRICE FROM FOOD CART
    [self.billCountItem setTitle:[NSString stringWithFormat:@"TOTAL BILL : $%.2f", [_foodCart getTotalPrice]]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 1:
            return _foodNum;
        default:
            return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1){
        static NSString *cellIdentifier = @"CAFoodDetailTableViewCell";
        UINib *nib = [UINib nibWithNibName:@"CAFoodDetailTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        CAFoodDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        //配置 cell 细节
        //TODO:从服务器获取
//        CAFood
        
        [cell.nameLabel setText:[NSString stringWithFormat:@"%@_%ld",_foodType,indexPath.row+1]];
        [cell.goodLabel setText:[NSString stringWithFormat:@"%u",arc4random() % 100]];
        [cell.badLabel setText:[NSString stringWithFormat:@"%u",arc4random() % 100]];
        [cell.picView setImage:[UIImage imageNamed:@"FOOD_DETAIL_TMP"]];
        
        bool foundFlag = false;
        NSArray *tmpFoodArr = [[CAFoodCart shareInstance] getFoodInCart];
        for(int i = 0; i < [tmpFoodArr count]; i++){
            CAFoodDetailInCart *food = tmpFoodArr[i];
            if([food.name isEqualToString:cell.nameLabel.text]){
                foundFlag = true;
                [cell.currNumLabel setText:[NSString stringWithFormat:@"%d",food.number]];
                [cell.priceLabel setText:[NSString stringWithFormat:@"$%.2f",food.price]];
                break;
            }
        }
        if(!foundFlag){
            [cell.currNumLabel setText:@"0"];
            [cell.priceLabel setText:[NSString stringWithFormat:@"$%.2f",arc4random() % 1000 / 100.0]];
        }
    
        cell.tag = (int)indexPath.row;
    
        cell.delegate = self;
        
        return cell;
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }else{
        return 80;
    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 10;
    }else{
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"paySegue"]){
        CAFoodPayViewController *caFoodPayViewController = (CAFoodPayViewController *)[segue destinationViewController];
        [caFoodPayViewController setPrice:[NSString stringWithFormat:@"$%.2f",[_foodCart getTotalPrice]]];
        [caFoodPayViewController setTotalNum:[_foodCart getTotalNum]];
        [caFoodPayViewController setPayFoodArr:(NSMutableArray *)[[CAFoodCart shareInstance] getFoodInCart]];
    }
}

@end
