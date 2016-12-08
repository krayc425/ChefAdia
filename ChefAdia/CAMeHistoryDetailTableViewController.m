//
//  CAMeHistoryDetailTableViewController.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/11.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAMeHistoryDetailTableViewController.h"
#import "Utilities.h"
#import "CAMeHistoryDetailTableViewCell.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"

#define ORDER_DETAIL_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/menu/getOrder"
#define COMMENT_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/menu/comment"

@interface CAMeHistoryDetailTableViewController ()

@end

@implementation CAMeHistoryDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.priceInstructionLabel setFont:[UIFont fontWithName:[Utilities getFont] size:15]];
    [self.dateInstructionLabel setFont:[UIFont fontWithName:[Utilities getFont] size:15]];
    [self.priceLabel setFont:[UIFont fontWithName:[Utilities getFont] size:15]];
    [self.dateLabel setFont:[UIFont fontWithName:[Utilities getFont] size:15]];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self loadOrderDetail];
}

- (void)loadOrderDetail{
    self.foodArr = [[NSMutableArray alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *tempDict = @{
                               @"orderid" : self.orderID,
                               };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager GET:ORDER_DETAIL_URL
      parameters:tempDict
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             NSDictionary *resultDict = (NSDictionary *)responseObject;
             if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                 
                 NSDictionary *dict = (NSDictionary *)[resultDict objectForKey:@"data"];
                 [weakSelf.priceLabel setText:[NSString stringWithFormat:@"%.2f", [[dict objectForKey:@"price"] doubleValue]]];
                 [weakSelf.dateLabel setText:[dict objectForKey:@"time"]];
                 
                 for(NSDictionary *foodDict in (NSArray *)[dict objectForKey:@"food_list"]){
                     [self.foodArr addObject:foodDict];
                 }
                 
                 [weakSelf.tableView reloadData];
                 
             }else{
                 NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"msg"]);
             }
             
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@",error);
         }];

}

- (void)goodComment:(_Nonnull id)sender{
    NSLog(@"good");
    CAMeHistoryDetailTableViewCell *cell = (CAMeHistoryDetailTableViewCell *)sender;
    [self commentWithNum:1 andFoodID:[self.foodArr[[[self.tableView indexPathForCell:cell] row]] objectForKey:@"foodid"]];
}

- (void)badComment:(_Nonnull id)sender{
    NSLog(@"bad");
    CAMeHistoryDetailTableViewCell *cell = (CAMeHistoryDetailTableViewCell *)sender;
    [self commentWithNum:0 andFoodID:[self.foodArr[[[self.tableView indexPathForCell:cell] row]] objectForKey:@"foodid"]];
}

- (void)commentWithNum:(int)comment andFoodID:(NSString *)foodID{
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *tempDict = @{
                               @"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                               @"foodid" : foodID,
                               @"comment" : [NSNumber numberWithInt:comment],
                               };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager GET:COMMENT_URL
      parameters:tempDict
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             NSDictionary *resultDict = (NSDictionary *)responseObject;
             if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                 
//                 NSLog(@"success");
                 
                 [weakSelf.tableView reloadData];
                 
             }else{
                 NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"msg"]);
             }
             
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@",error);
         }];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 1:
            return [_foodArr count];
        case 0:
            return 2;
        default:
            return 0;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1){
        //注册 nib 的方法，来使用.xib 的cell
        static NSString *CellIdentifier = @"CAMeHistoryDetailTableViewCell";
        UINib *nib = [UINib nibWithNibName:@"CAMeHistoryDetailTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        CAMeHistoryDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        //配置 cell 细节
        [cell.nameLabel setText:[self.foodArr[indexPath.row] objectForKey:@"name"]];
        [cell.numLabel setText:[NSString stringWithFormat:@"%d", [[self.foodArr[indexPath.row] objectForKey:@"num"] intValue]]];
        [cell.priceLabel setText:[NSString stringWithFormat:@"%.2f", [[self.foodArr[indexPath.row] objectForKey:@"price"] doubleValue]]];
        
        cell.delegate = self;
        
        return cell;
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

@end
