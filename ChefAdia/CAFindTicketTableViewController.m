//
//  CAFindTicketTableViewController.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/12/9.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAFindTicketTableViewController.h"
#import "CAFindTicketTableViewCell.h"
#import "AFNetworking.h"

#define ALL_TICKET_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/menu/getAllTicket"
#define BUY_TICKET_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/menu/buyTick"
#define GET_TICKET_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/menu/getTickInfo"

@interface CAFindTicketTableViewController ()

@end

@implementation CAFindTicketTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _backgroundView.image = [UIImage imageNamed:@"FIND_TITLE"];
    [self loadTickets];
    [self loadMyTicket];
}

- (void)viewWillAppear:(BOOL)animated{
    
}

- (void)loadTickets{
    
    __weak typeof(self) weakSelf = self;
    
    self.ticketArr = [[NSMutableArray alloc] init];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager GET:ALL_TICKET_URL
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             NSDictionary *resultDict = (NSDictionary *)responseObject;
             if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                 NSArray *array = (NSArray *)[resultDict objectForKey:@"data"];
                 for(NSDictionary *dict in array){
                     [self.ticketArr addObject:dict];
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

- (void)loadMyTicket{
    
    __weak typeof(self) weakSelf = self;
    
    self.myTicketArr = [[NSMutableArray alloc] init];
    
    NSDictionary *dict = @{
                           @"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager GET:GET_TICKET_URL
      parameters:dict
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             NSDictionary *resultDict = (NSDictionary *)responseObject;
             if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                 NSDictionary *subResultDict = (NSDictionary *)[resultDict objectForKey:@"data"];
                 NSLog(@"%@", [subResultDict description]);
                 [self.myTicketArr addObject:subResultDict];
             }else{
                 NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"msg"]);
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@",error);
         }];

}

#pragma mark - Buy Ticket Delegate

- (void)buyTicket:(id)sender{
    CAFindTicketTableViewCell *cell = (CAFindTicketTableViewCell *)sender;
    
    __weak typeof(self) weakSelf = self;
    
    int i = (int)[[self.tableView indexPathForCell:cell] row];
    
    NSDictionary *dict = @{
                           @"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                           @"tickid" : [self.ticketArr[i] objectForKey:@"id"],
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager GET:BUY_TICKET_URL
      parameters:dict
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             NSDictionary *resultDict = (NSDictionary *)responseObject;
             if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                 
                 UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Buy ticket success"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction *action){
                                                                      [self.navigationController popToRootViewControllerAnimated:YES];
                                                                  }];
                 [alertC addAction:okAction];
                 [self presentViewController:alertC animated:YES completion:nil];
                 
                 NSLog(@"buy ticket success");
                 
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
            return [self.ticketArr count];
        default:
            return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }else{
        return 180;
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
        static NSString *cellIdentifier = @"CAFindTicketTableViewCell";
        UINib *nib = [UINib nibWithNibName:@"CAFindTicketTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        CAFindTicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        [cell.IDLabel setText:[NSString stringWithFormat:@"TICKET ID : %@", [self.ticketArr[indexPath.row] objectForKey:@"id"]]];
        [cell.nameLabel setText:[self.ticketArr[indexPath.row] objectForKey:@"name"]];
        //[cell.priceLabel setText:[NSString stringWithFormat:@"$%.2f", [[self.ticketArr[indexPath.row] objectForKey:@"price"] doubleValue]]];
        [cell.descriptionLabel setText:[self.ticketArr[indexPath.row] objectForKey:@"description"]];
        [cell.expireLabel setText:[NSString stringWithFormat:@"%d DAYS", [[self.ticketArr[indexPath.row] objectForKey:@"expire_day"] intValue]]];
        [cell.dailyAmountLabel setText:[NSString stringWithFormat:@"$%.2f",[[self.ticketArr[indexPath.row] objectForKey:@"daily_upper"] doubleValue]]];
        
        cell.delegate = self;
        
        return cell;
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

@end
