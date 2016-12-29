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
#import "UIScrollView+EmptyDataSet.h"
#import "Utilities.h"
#import "MBProgressHUD.h"

#define ORDER_LIST_URL @"http://47.89.194.197:8081/ChefAdia-1.0-SNAPSHOT/menu/getOrderList"
#define EASY_ORDER_URL @"http://47.89.194.197:8081/ChefAdia-1.0-SNAPSHOT/user/modEasyOrder"

@interface CAMeHistoryTableViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation CAMeHistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self loadOrder];
}

- (void)viewWillAppear:(BOOL)animated{
}

- (void)loadOrder{
    
    self.orderArr = [[NSMutableArray alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *tempDict = @{
                               @"userid" : self.userID,
                               };
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setMode:MBProgressHUDModeText];
    [hud.label setText: @"Loading"];
    [hud setRemoveFromSuperViewOnHide:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager GET:ORDER_LIST_URL
      parameters:tempDict
        progress:^(NSProgress * _Nonnull uploadProgress) {
            [hud setProgressObject:uploadProgress];
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             NSDictionary *resultDict = (NSDictionary *)responseObject;
             if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                 
                 [hud hideAnimated:YES];
                 
                 for(NSDictionary *dict in (NSArray *)[resultDict objectForKey:@"data"]){
                     [weakSelf.orderArr addObject:dict];
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
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setMode:MBProgressHUDModeText];
    [hud.label setText: @"Setting"];
    [hud setRemoveFromSuperViewOnHide:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager POST:EASY_ORDER_URL
      parameters:tempDict
         progress:^(NSProgress * _Nonnull uploadProgress) {
             [hud setProgressObject:uploadProgress];
         }
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             NSDictionary *resultDict = (NSDictionary *)responseObject;
             if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                 
                 [hud hideAnimated:YES];
                 
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
    if([self.orderArr count] > 0){
        return 1;
    }else{
        return 0;
    }
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
        [cell.custLabel setText:@"MY MENU"];
    }else{
        [cell setUserInteractionEnabled:YES];
        [cell.custLabel setText:@""];
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

#pragma mark - Empty Set Delegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"NO ORDER YET";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:[Utilities getBoldFont] size:20.0f],
                                 NSForegroundColorAttributeName: [Utilities getColor]
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"GO AND ORDER SOME FOOD NOW!";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:[Utilities getFont] size:15.0f],
                                 NSForegroundColorAttributeName: [Utilities getColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
