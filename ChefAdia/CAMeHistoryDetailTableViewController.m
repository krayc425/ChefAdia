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
#import "MBProgressHUD.h"

#define ORDER_DETAIL_URL @"http://47.89.194.197:8081/ChefAdia-1.0-SNAPSHOT/menu/getOrder"
#define COMMENT_URL @"http://47.89.194.197:8081/ChefAdia-1.0-SNAPSHOT/menu/comment"

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
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setMode:MBProgressHUDModeText];
    [hud.label setText: @"Loading"];
    [hud setRemoveFromSuperViewOnHide:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager GET:ORDER_DETAIL_URL
      parameters:tempDict
        progress:^(NSProgress * _Nonnull uploadProgress) {
            [hud setProgressObject:uploadProgress];
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             NSDictionary *resultDict = (NSDictionary *)responseObject;
             if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                 
                 [hud hideAnimated:YES];
                 
                 NSDictionary *dict = (NSDictionary *)[resultDict objectForKey:@"data"];
                 //TODO
                 [weakSelf.priceLabel setText:[NSString stringWithFormat:@"$%.2f", [[dict objectForKey:@"price"] doubleValue]]];
                 [weakSelf.dateLabel setText:[dict objectForKey:@"time"]];
                 
                 for(NSDictionary *foodDict in (NSArray *)[dict objectForKey:@"food_list"]){
                     [self.foodArr addObject:foodDict];
                 }
                 
                 self.commentArr = [[NSMutableArray alloc] initWithCapacity:self.foodArr.count];

                 [weakSelf.tableView reloadData];
                 
             }else{
                 NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"message"]);
             }
             
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@",error);
         }];
}

- (void)goodComment:(_Nonnull id)sender{
    NSLog(@"good");
    CAMeHistoryDetailTableViewCell *cell = (CAMeHistoryDetailTableViewCell *)sender;
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    
    if([self.commentArr containsObject:path]){
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"You have already commented this food"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertC addAction:okAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }else{
        [self commentWithNum:1 andFoodID:[self.foodArr[path.row] objectForKey:@"foodid"]];
        [self.commentArr addObject:path];
    }
}

- (void)badComment:(_Nonnull id)sender{
    NSLog(@"bad");
    CAMeHistoryDetailTableViewCell *cell = (CAMeHistoryDetailTableViewCell *)sender;
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    
    if([self.commentArr containsObject:path]){
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"You have already commented this food"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertC addAction:okAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }else{
        [self commentWithNum:0 andFoodID:[self.foodArr[path.row] objectForKey:@"foodid"]];
        [self.commentArr addObject:path];
    }
}

- (void)commentWithNum:(int)comment andFoodID:(NSString *)foodID{
    
//    __weak typeof(self) weakSelf = self;
    
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
                 
                 UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Comment success"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:nil];
                 [alertC addAction:okAction];
                 [self presentViewController:alertC animated:YES completion:nil];
                 
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
        static NSString *CellIdentifier = @"CAMeHistoryDetailTableViewCell";
        UINib *nib = [UINib nibWithNibName:@"CAMeHistoryDetailTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        CAMeHistoryDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        [cell.nameLabel setText:[self.foodArr[indexPath.row] objectForKey:@"name"]];
        [cell.numLabel setText:[NSString stringWithFormat:@"%d", [[self.foodArr[indexPath.row] objectForKey:@"num"] intValue]]];
        [cell.priceLabel setText:[NSString stringWithFormat:@"$%.2f", [[self.foodArr[indexPath.row] objectForKey:@"price"] doubleValue]]];
        
        cell.delegate = self;
        
        return cell;
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

@end
