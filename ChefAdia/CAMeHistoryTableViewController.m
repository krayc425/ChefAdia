//
//  CAMeHistoryTableViewController.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/9.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAMeHistoryTableViewController.h"
#import "CAMeHistoryTableViewCell.h"
#import "CAMeHistoryDetailTableViewController.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"

#define ORDER_LIST_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/menu/getOrderList"
#define EASY_ORDER_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/user/modEasyOrder"

@interface CAMeHistoryTableViewController ()

@end

@implementation CAMeHistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadOrder];
}

- (void)loadOrder{
    self.orderArr = [[NSMutableArray alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *tempDict = @{
                               @"userid" : self.userID,
                               };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager GET:ORDER_LIST_URL
      parameters:tempDict
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             NSDictionary *resultDict = (NSDictionary *)responseObject;
             if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                 
                 for(NSDictionary *dict in (NSArray *)[resultDict objectForKey:@"data"]){
                     [weakSelf.orderArr addObject:dict];
//                     [weakSelf.orderArr insertObject:dict atIndex:0];
                 }
                 
                 [weakSelf.tableView reloadData];
             }else{
                 NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"message"]);
             }
             
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@",error);
         }];

}

- (void)setEasyOrder:(id)sender{
    CAMeHistoryTableViewCell *cell = (CAMeHistoryTableViewCell *)sender;
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *tempDict = @{
                               @"userid" : self.userID,
                               @"orderid" : [self.orderArr[[[self.tableView indexPathForCell:cell] row]] objectForKey:@"orderid"],
                               };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager POST:EASY_ORDER_URL
      parameters:tempDict
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             NSDictionary *resultDict = (NSDictionary *)responseObject;
             if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                 NSLog(@"success");
                 
                 [weakSelf.tableView reloadData];
             }else{
                 NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"message"]);
             }
             
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@",error);
         }];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.orderArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CAMeHistoryTableViewCell";
    UINib *nib = [UINib nibWithNibName:@"CAMeHistoryTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    CAMeHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //是自定义菜单，不能点进去
    if([[self.orderArr[indexPath.row] objectForKey:@"iscust"] intValue] == 1){
        [cell setUserInteractionEnabled:NO];
    }else{
        [cell setUserInteractionEnabled:YES];
    }
    
    [cell.orderIDLabel setText:[NSString stringWithFormat:@"Order ID : %@", [self.orderArr[indexPath.row] objectForKey:@"orderid"]]];
    [cell.timeLabel setText:[self.orderArr[indexPath.row] objectForKey:@"time"]];
    [cell.priceLabel setText:[NSString stringWithFormat:@"$%.2f", [[self.orderArr[indexPath.row] objectForKey:@"price"] doubleValue]]];
    
    if([cell.orderIDLabel.text isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"easy_order_id"]]){
        [cell setIsEasyOrder:true];
    }else{
        [cell setIsEasyOrder:false];
    }
    
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"detailSegue" sender:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 10;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = (NSIndexPath *)sender;
    CAMeHistoryDetailTableViewController *caMeHistoryDetailTableViewController = (CAMeHistoryDetailTableViewController *)[segue destinationViewController];
    [caMeHistoryDetailTableViewController setOrderID:[self.orderArr[indexPath.row] objectForKey:@"orderid"]];
}

@end
