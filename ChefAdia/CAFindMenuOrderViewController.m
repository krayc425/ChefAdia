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
#import "CAMenuData.h"

#define GET_MMENU_DETAIL_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/user/getMMenu"
#define ORDER_MMENU_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/menu/addMOrder"

@interface CAFindMenuOrderViewController ()

@end

@implementation CAFindMenuOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *fontName = [Utilities getFont];
    UIColor *color = [Utilities getColor];
    
    [self.nameLabel setFont:[UIFont fontWithName:[Utilities getBoldFont] size:30]];
//    [self.nameLabel setTextColor:color];
    
    [self.priceInstructionLabel setFont:[UIFont fontWithName:[Utilities getBoldFont] size:15]];
    [self.priceInstructionLabel setTextColor:color];
    [self.totalPriceLabel setFont:[UIFont fontWithName:[Utilities getBoldFont] size:20]];
    [self.totalPriceLabel setTextColor:color];
    
    [self.orderButton.titleLabel setFont:[UIFont fontWithName:fontName size:20]];
    [self.orderButton.titleLabel setTextColor:[UIColor whiteColor]];
    [self.orderButton setBackgroundImage:[UIImage imageNamed:@"BUTTON_BG_DEFAULT_SHORT"] forState:UIControlStateNormal];
    
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //set view
    [self.nameLabel setText:self.menuName];
    [self.totalPriceLabel setText:[NSString stringWithFormat:@"$%.2f", self.menuPrice]];

    [self loadMMenu];
}

- (void)loadMMenu{
    self.typeArr = [NSMutableArray arrayWithArray:[CAMenuData getNameList]];
    self.foodArr = [[NSMutableArray alloc] init];
    self.numArr = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self.typeArr count]; i++){
        [self.foodArr addObject:@""];
        [self.numArr addObject:[NSNumber numberWithInt:0]];
    }
    
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
                  
                  NSDictionary *subResultDict = (NSDictionary *)[resultDict objectForKey:@"data"];
                  NSLog(@"%@", [subResultDict description]);
                  
                  for(NSString *str in subResultDict){
                      NSString *tmpStr = [str uppercaseString];
                      if([tmpStr containsString:@"NUM"]){
                          tmpStr = [tmpStr substringToIndex:tmpStr.length-4];
                          self.numArr[[self.typeArr indexOfObject:tmpStr]] = subResultDict[str];
                      }else{
                          self.foodArr[[self.typeArr indexOfObject:tmpStr]] = subResultDict[str];
                      }
                  }
                  
                  [self.menuTableView reloadData];
              }else{
                  NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"message"]);
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
    
    NSLog(@"%@", [dict description]);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
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
                 NSLog(@"ORDER MMENU SUCCESS");
                 
                 UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Order success"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:nil];
                 [alertC addAction:okAction];
                 [self presentViewController:alertC animated:YES completion:nil];

                 [self.navigationController popViewControllerAnimated:YES];
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
    return [self.typeArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
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
    
    [cell.typeLabel setText:self.typeArr[indexPath.row]];
    [cell.nameLabel setText:self.foodArr[indexPath.row]];

    [cell.picView setHidden:YES];
    [cell.priceLabel setHidden:YES];
    
    return cell;
}

@end