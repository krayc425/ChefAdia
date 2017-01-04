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
#import "Utilities.h"
#import "MBProgressHUD.h"

#define ALL_TICKET_URL @"http://47.89.194.197:8081/ChefAdia-1.0-SNAPSHOT/menu/getAllTicket"
#define BUY_TICKET_URL @"http://47.89.194.197:8081/ChefAdia-1.0-SNAPSHOT/menu/buyTick"
#define GET_TICKET_URL @"http://47.89.194.197:8081/ChefAdia-1.0-SNAPSHOT/menu/getTickInfo"

@interface CAFindTicketTableViewController ()

@end

@implementation CAFindTicketTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _backgroundView.image = [UIImage imageNamed:@"FIND_TICKET"];
    _titleLabel.font = [UIFont fontWithName:[Utilities getBoldFont] size:30];
    [_titleLabel setText:@"MEAL TICKETS"];
    
    [self loadTickets];
}

- (void)loadTickets{
    
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
                 [self loadMyTicket];
             }else{
                 NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"message"]);
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
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setMode:MBProgressHUDModeText];
    [hud.label setText: @"Loading"];
    [hud setRemoveFromSuperViewOnHide:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager GET:GET_TICKET_URL
      parameters:dict
        progress:^(NSProgress * _Nonnull uploadProgress) {
            [hud setProgressObject:uploadProgress];
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             NSDictionary *resultDict = (NSDictionary *)responseObject;
             if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                 
                 [hud hideAnimated:YES];
                 
                 NSDictionary *subResultDict = (NSDictionary *)[resultDict objectForKey:@"data"];
                 
                 [self.myTicketArr addObject:subResultDict];
                 
                 [weakSelf.tableView reloadData];
             }else{
                 NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"message"]);
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
                                                                  handler:nil];
                 [alertC addAction:okAction];
                 [self presentViewController:alertC animated:YES completion:nil];
                 
                 NSLog(@"buy ticket success");
                 
                 [self loadMyTicket];
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
        [cell.priceLabel setText:[NSString stringWithFormat:@"$%.2f", [[self.ticketArr[indexPath.row] objectForKey:@"price"] doubleValue]]];
        [cell.descriptionLabel setText:[self.ticketArr[indexPath.row] objectForKey:@"description"]];
        
        [cell.expireInstructionLabel setText:@"VALIDATION PERIOD"];
        [cell.expireLabel setText:[NSString stringWithFormat:@"%d DAYS", [[self.ticketArr[indexPath.row] objectForKey:@"expire_day"] intValue]]];
        [cell.dailyAmountInstructionLabel setText:@"DAILY AMOUNT"];
        [cell.dailyAmountLabel setText:[NSString stringWithFormat:@"$%.2f",[[self.ticketArr[indexPath.row] objectForKey:@"daily_upper"] doubleValue]]];
        [cell.buyButton setHidden:NO];
        
        //如果找到，那设置为找到
        for(NSDictionary *dict in self.myTicketArr){
            if([[[self.ticketArr[indexPath.row] objectForKey:@"id"] description]
                isEqualToString:[dict objectForKey:@"id"]]){
                
                [cell.expireInstructionLabel setText:@"EXPIRE ON"];
                [cell.expireLabel setText:[dict objectForKey:@"expire"]];
                [cell.dailyAmountInstructionLabel setText:@"TODAY'S BALANCE"];
                [cell.dailyAmountLabel setText:[NSString stringWithFormat:@"$%.2f",[[dict objectForKey:@"remain_money"] doubleValue]]];
                [cell.buyButton setHidden:YES];
            }
        }
        
        cell.delegate = self;
        
        return cell;
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

@end
