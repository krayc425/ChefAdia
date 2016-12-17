//
//  CAFindMenuOrderViewController.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/12/16.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAFindMenuOrderViewController.h"
#import "CAFindMenuListTableViewCell.h"
#import "Utilities.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFNetworking.h"

#define GET_MMENU_DETAIL_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/user/getMMenu"
#define ORDER_MMENU_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/menu/addMOrder"

@interface CAFindMenuOrderViewController ()

@end

@implementation CAFindMenuOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *fontName = [Utilities getFont];
    UIColor *color = [Utilities getColor];
    
    [self.priceInstructionLabel setFont:[UIFont fontWithName:[Utilities getBoldFont] size:15]];
    [self.priceInstructionLabel setTextColor:color];
    [self.totalPriceLabel setFont:[UIFont fontWithName:[Utilities getBoldFont] size:20]];
    [self.totalPriceLabel setTextColor:color];
    
    [self.orderButton.titleLabel setFont:[UIFont fontWithName:fontName size:20]];
    [self.orderButton.titleLabel setTextColor:[UIColor whiteColor]];
    [self.orderButton setBackgroundImage:[UIImage imageNamed:@"BUTTON_BG_DEFAULT_SHORT"] forState:UIControlStateNormal];
    [self.orderButton setUserInteractionEnabled:NO];
    
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //set view
    [self.totalPriceLabel setText:[NSString stringWithFormat:@"$%.2f", self.totalPrice]];
    
    self.typeArr = [[NSMutableArray alloc] init];
    self.numArr = [[NSMutableArray alloc] init];
    self.foodArr = [[NSMutableArray alloc] init];
    
    NSLog(@"%@", self.menuid);
}

- (void)loadMMenu{
    NSDictionary *dict = @{
                           @"mmenuid" : self.menuid,
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager GET:GET_MMENU_DETAIL_URL
      parameters:dict
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
              NSDictionary *resultDict = (NSDictionary *)responseObject;
              if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                  
                  //TODO
                  
                  [self.menuTableView reloadData];
              }else{
                  NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"msg"]);
              }
          }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"%@",error);
          }];

}

- (IBAction)orderAction:(id)sender{
    
    NSDictionary *dict = @{
                           @"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                           @"mmenuid" : self.menuid,
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager GET:ORDER_MMENU_URL
      parameters:dict
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             NSDictionary *resultDict = (NSDictionary *)responseObject;
             if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                 
                 //TODO
                 
                 [self.navigationController popViewControllerAnimated:YES];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.typeArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CAFindMenuListTableViewCell";
    UINib *nib = [UINib nibWithNibName:@"CAFindMenuListTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    CAFindMenuListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell.numLabel setText:[self.numArr[indexPath.row] description]];
    [cell.priceLabel setText:[NSString stringWithFormat:@"$%.2f", [[self.foodArr[indexPath.row] objectForKey:@"price"] doubleValue]]];
    [cell.typeLabel setText:self.typeArr[indexPath.row]];
    [cell.nameLabel setText:[self.foodArr[indexPath.row] objectForKey:@"name"]];
    
    NSURL *imageUrl = [NSURL URLWithString:[self.foodArr[indexPath.row] objectForKey:@"pic"]];
    [cell.picView sd_setImageWithURL:imageUrl];
    
    return cell;
}

@end
