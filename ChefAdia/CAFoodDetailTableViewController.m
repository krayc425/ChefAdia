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
#import "CAFoodMenu.h"
#import "CAFoodDetailInCart.h"
#import "CAFoodManager.h"
#import "Utilities.h"
#import "CAFoodDetail.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"

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
    
    [self.naviItem setTitle:[_foodType name]];
    _titleImgView.image = [UIImage imageNamed:@"FOOD_TITLE"];
    
    [self.numberLabel setFont:[UIFont fontWithName:fontName size:20]];
    [self.billCountItem setTintColor:color];
    [self.buyItem setTintColor:color];
    
    _foodCart = [CAFoodCart shareInstance];
}

- (void)loadFood{
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *tempDict = @{
                              @"menuid" : [NSString stringWithFormat:@"%d",_foodType.ID],
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager GET:@"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/getList"
      parameters:tempDict
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             NSDictionary *resultDict = (NSDictionary *)responseObject;
             if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                 NSArray *resultArr = (NSArray *)[resultDict objectForKey:@"data"];
                 for(NSDictionary *dict in resultArr){
                     CAFoodDetail *caFoodDetail = [[CAFoodDetail alloc] initWithName:[dict valueForKey:@"name"]
                                                                             andType:[dict valueForKey:@"type"]
                                                                            andPrice:[[dict valueForKey:@"price"] doubleValue]
                                                                              andPic:[dict valueForKey:@"picture"]
                                                                            andLikes:[[dict valueForKey:@"like"] intValue]
                                                                         andDislikes:[[dict valueForKey:@"dislike"] intValue]];
                     [weakSelf.foodArr addObject:[caFoodDetail copy]];
                 }
                 weakSelf.foodNum = (int)[weakSelf.foodArr count];
                 [weakSelf.numberLabel setText:[NSString stringWithFormat:@"%d SELECTION%s",
                                                weakSelf.foodNum, weakSelf.foodNum <= 1 ? "" : "S"]];
                 [weakSelf.tableView reloadData];
             }else{
                 NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"msg"]);
             }
             
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@",error);
         }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    //加载所有食物数组
    _foodArr = [[NSMutableArray alloc] init];
    [self loadFood];
    
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
    //ADD IN FOOD CART
    [[CAFoodCart shareInstance] modifyFoodInCartWithName:[NSString stringWithFormat:@"%@", cell.nameLabel.text]
                                                  andNum:1
                                                andPrice:[cell.priceLabel.text doubleValue]];
    //GET TOTAL PRICE FROM FOOD CART
    [self.billCountItem setTitle:[NSString stringWithFormat:@"TOTAL BILL : $%.2f", [_foodCart getTotalPrice]]];
}

- (void)minusNum:(id)sender{
    NSLog(@"minus");
    CAFoodDetailTableViewCell *cell = (CAFoodDetailTableViewCell *)sender;
    //MINUS IN FOOD CART
    [[CAFoodCart shareInstance] modifyFoodInCartWithName:[NSString stringWithFormat:@"%@", cell.nameLabel.text]
                                                  andNum:-1
                                                andPrice:[cell.priceLabel.text doubleValue]];
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
        CAFoodDetail *food = [_foodArr objectAtIndex:indexPath.row];
        
        [cell.nameLabel setText:[NSString stringWithFormat:@"%@", food.name]];
        [cell.goodLabel setText:[NSString stringWithFormat:@"%d", food.likes]];
        [cell.badLabel setText:[NSString stringWithFormat:@"%d", food.dislikes]];
        [cell.priceLabel setText:[NSString stringWithFormat:@"%.2f", food.price]];
        
        NSURL *imageUrl = [NSURL URLWithString:food.pic];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        [cell.picView setImage:image];
        
        bool foundFlag = false;
        NSArray *tmpFoodArr = [[CAFoodCart shareInstance] getFoodInCart];
        for(int i = 0; i < [tmpFoodArr count]; i++){
            CAFoodDetailInCart *foodCart = tmpFoodArr[i];
            if([foodCart.name isEqualToString:cell.nameLabel.text]){
                foundFlag = true;
                [cell.currNumLabel setText:[NSString stringWithFormat:@"%d",foodCart.number]];
                break;
            }
        }
        if(!foundFlag){
            [cell.currNumLabel setText:@"0"];
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
        if([_foodCart getTotalNum] == 0){
            NSLog(@"NO FOOD IN CART");
        }else{
            CAFoodPayViewController *caFoodPayViewController = (CAFoodPayViewController *)[segue destinationViewController];
            [caFoodPayViewController setPrice:[NSString stringWithFormat:@"$%.2f",[_foodCart getTotalPrice]]];
            [caFoodPayViewController setTotalNum:[_foodCart getTotalNum]];
            [caFoodPayViewController setPayFoodArr:(NSMutableArray *)[[CAFoodCart shareInstance] getFoodInCart]];
        }
    }
}

@end
