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
#import "CAFoodCart.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "CALoginManager.h"
#import "MBProgressHUD.h"

#define PAY_URL @"http://47.89.194.197:8081/ChefAdia-1.0-SNAPSHOT/menu/addOrder"
#define GET_TICKET_URL @"http://47.89.194.197:8081/ChefAdia-1.0-SNAPSHOT/menu/getTickInfo"

@interface CAFoodPayViewController (){
    NSString *fontName;
}

@end

@implementation CAFoodPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    fontName = [Utilities getFont];
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [_bowlInstructionLabel setFont:[UIFont fontWithName:fontName size:15]];
    [_ticketInstructionLabel setFont:[UIFont fontWithName:fontName size:15]];
    
    [_priceLabel setFont:[UIFont fontWithName:[Utilities getBoldFont] size:40]];
    [_timeLabel setFont:[UIFont fontWithName:fontName size:15]];
    [_countLabel setFont:[UIFont fontWithName:fontName size:15]];
    
    [_priceLabel setTextColor:[Utilities getColor]];
    
    //price label
    [_priceLabel setText:_price];
    
    //time label
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [fmt stringFromDate:now];
    [_timeLabel setText:dateString];
    
    //count label
    [_countLabel setText:[NSString stringWithFormat:@"(%d ITEM%s)", _totalNum, _totalNum <= 1 ? "" : "S"]];
    
    _cashButton.titleLabel.font = [UIFont fontWithName:fontName size:15];
    _visaButton.titleLabel.font = [UIFont fontWithName:fontName size:15];
    [_bowlSwitch setOnTintColor:[Utilities getColor]];
    [_ticketSwitch setOnTintColor:[Utilities getColor]];
    [_bowlSwitch setOn:NO];
    [_ticketSwitch setOn:NO];
    
    [_ticketSwitch addTarget:self action:@selector(checkHasTicket:) forControlEvents:UIControlEventValueChanged];
}

- (IBAction)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//temp
- (BOOL)checkHasTicket:(id)sender{
    
    UISwitch *ticketSwitch = (UISwitch *)sender;
    if([ticketSwitch isOn]){
        [ticketSwitch setOn:NO];
        
        return NO;
    }else{

        NSMutableArray *myTicketArr = [[NSMutableArray alloc] init];
        
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
                     
                     if([subResultDict[@"remain_money"] doubleValue] > 0){
                         [myTicketArr addObject:subResultDict];
                     }
                     
                 }else{
                     NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"message"]);
                 }
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"%@",error);
             }];
        
        if([myTicketArr count] > 0){
            [ticketSwitch setOn:YES];
            
            return YES;
        }else{
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"You don't have any available ticket"
                                                                            message:nil
                                                                     preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertC addAction:okAction];
            [self presentViewController:alertC animated:YES completion:nil];
            
            return NO;
        }
        
    }
}

- (IBAction)payAction:(id)sender{
    //CASH : TAG = 0
    //VISA : TAG = 1

    if(![[CALoginManager shareInstance] checkInfo]){
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Info not complete"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"My info"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action){
                                                             [self performSegueWithIdentifier:@"infoSegue" sender:nil];
                                                         }];
        [alertC addAction:cancelAction];
        [alertC addAction:okAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Sure to order?"
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Order"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action){
                                                         
                                                         int ticket_info = [self.ticketSwitch isOn];
                                                         int bowl_info = [self.bowlSwitch isOn];
                                                         
                                                         UIButton *button = (UIButton *)sender;
                                                         
                                                         NSMutableArray *foodArr = [[NSMutableArray alloc] init];
                                                         for(CAFoodDetailInCart *food in self.payFoodArr){
                                                             NSDictionary *foodDict = @{
                                                                                        @"foodid" : food.foodID,
                                                                                        @"num" : [NSNumber numberWithInt:food.number],
                                                                                        };
                                                             [foodArr addObject:foodDict];
                                                         }
                                                         
                                                         NSDictionary *tempDict = @{
                                                                                    @"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                                                                    @"time" : [self.timeLabel text],
                                                                                    @"food_list" : foodArr,
                                                                                    @"price" : [NSNumber numberWithDouble:[[[self.priceLabel text] substringFromIndex:1] doubleValue]],
                                                                                    @"ticket_info" : [NSNumber numberWithInt:ticket_info],
                                                                                    @"bowl_info" : [NSNumber numberWithInt:bowl_info],
                                                                                    @"pay_type" : [NSNumber numberWithInteger:button.tag],
                                                                                    };
                                                         
                                                         AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                                                         manager.requestSerializer = [AFJSONRequestSerializer serializer];
                                                         manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                                                                              @"text/plain",
                                                                                                              @"text/html",
                                                                                                              nil];
                                                         
                                                         MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                         [hud setMode:MBProgressHUDModeText];
                                                         [hud.label setText: @"Ordering"];
                                                         [hud setRemoveFromSuperViewOnHide:YES];

                                                         [manager POST:PAY_URL
                                                            parameters:tempDict
                                                              progress:^(NSProgress * _Nonnull uploadProgress) {
                                                                  [hud setProgressObject:uploadProgress];
                                                              }
                                                               success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                                                                   NSDictionary *resultDict = (NSDictionary *)responseObject;
                                                                   if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                                                                       
                                                                       [[CAFoodCart shareInstance] clearCart];
                                                                       
                                                                       [hud hideAnimated:YES];
                                                                       
                                                                       UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Order success"
                                                                                                                                       message:nil
                                                                                                                                preferredStyle:UIAlertControllerStyleAlert];
                                                                       UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                                                          style:UIAlertActionStyleDefault
                                                                                                                        handler:^(UIAlertAction *action){
                                                                                                                            [self.navigationController popToRootViewControllerAnimated:YES];
                                                                                                                        }];
                                                                       [alertC addAction:okAction];
                                                                       
                                                                       [self presentViewController:alertC animated:YES completion:nil];
                                                                       
                                                                   }else{
                                                                       NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"message"]);
                                                                   }
                                                                   
                                                               }
                                                               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                                   
                                                                   UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Order failed"
                                                                                                                                   message:nil
                                                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                                                   UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                                                      style:UIAlertActionStyleDefault
                                                                                                                    handler:^(UIAlertAction *action){
                                                                                                                        [self.navigationController popToRootViewControllerAnimated:YES];
                                                                                                                    }];
                                                                   [alertC addAction:okAction];
                                                                   
                                                                   [self presentViewController:alertC animated:YES completion:nil];
                                                                   
                                                                   NSLog(@"%@",error);
                                                               }];
                                                     }];
    [alertC addAction:cancelAction];
    [alertC addAction:okAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_payFoodArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CAFoodPayTableViewCell";
    UINib *nib = [UINib nibWithNibName:@"CAFoodPayTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    CAFoodPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    CAFoodDetailInCart *food = _payFoodArr[indexPath.row];
    cell.nameLabel.text = food.foodName;
    cell.priceLabel.text = [NSString stringWithFormat:@"$%.2f",food.price];
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
