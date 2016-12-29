//
//  CAFindMenuListViewController.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/12/16.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAFindMenuListViewController.h"
#import "CAFindMenuListTableViewCell.h"
#import "Utilities.h"
#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define UPLOAD_MMENU_URL @"http://47.89.194.197:8081/ChefAdia-1.0-SNAPSHOT/user/addMMenu"

@interface CAFindMenuListViewController ()

@end

@implementation CAFindMenuListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *fontName = [Utilities getFont];
    UIColor *color = [Utilities getColor];
    
    [self.submitLabel setFont:[UIFont fontWithName:[Utilities getBoldFont] size:30]];
    [self.submitLabel setTextColor:color];
    
    [self.priceInstructionLabel setFont:[UIFont fontWithName:[Utilities getBoldFont] size:15]];
    [self.priceInstructionLabel setTextColor:color];
    [self.totalPriceLabel setFont:[UIFont fontWithName:[Utilities getBoldFont] size:20]];
    [self.totalPriceLabel setTextColor:color];
    
    [self.submitButton.titleLabel setFont:[UIFont fontWithName:fontName size:20]];
    [self.submitButton.titleLabel setTextColor:[UIColor whiteColor]];
    [self.submitButton setBackgroundImage:[UIImage imageNamed:@"BUTTON_BG_GRAY_SHORT"] forState:UIControlStateNormal];
    [self.submitButton setUserInteractionEnabled:NO];
    
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
//    self.nameText.layer.cornerRadius = 20.0;
    self.nameText.font = [UIFont fontWithName:fontName size:20];
    [self.nameText addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    
    //set view
    [self.totalPriceLabel setText:[NSString stringWithFormat:@"$%.2f", self.totalPrice]];
}

- (IBAction)submitAction:(id)sender{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Sure to submit?"
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Submit"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action){
                                                         [self uploadMMenu];
                                                     }];
    [alertC addAction:cancelAction];
    [alertC addAction:okAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)uploadMMenu{
    
    NSDictionary *dict = @{
                           @"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                           @"name" : self.nameText.text,
                           @"mealid" : [self.foodArr[0] objectForKey:@"foodid"],
                           @"meal_num" : self.numArr[0],
                           @"meatid" : [self.foodArr[1] objectForKey:@"foodid"],
                           @"meat_num" : self.numArr[1],
                           @"vegetableid" : [self.foodArr[2] objectForKey:@"foodid"],
                           @"vegetable_num" : self.numArr[2],
                           @"snackid" : [self.foodArr[3] objectForKey:@"foodid"],
                           @"snack_num" : self.numArr[3],
                           @"sauceid" : [self.foodArr[4] objectForKey:@"foodid"],
                           @"sauce_num" : self.numArr[4],
                           @"flavorid" : [self.foodArr[5] objectForKey:@"foodid"],
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager POST:UPLOAD_MMENU_URL
       parameters:dict
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
              NSDictionary *resultDict = (NSDictionary *)responseObject;
              if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                  NSLog(@"ADD MMENU SUCCESS");
                  
                  UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Add new menu success"
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
    [cell.priceLabel setText:[NSString stringWithFormat:@"$%.2f", [[self.foodArr[indexPath.row] objectForKey:@"price"] doubleValue]]];
    [cell.typeLabel setText:self.typeArr[indexPath.row]];
    [cell.nameLabel setText:[self.foodArr[indexPath.row] objectForKey:@"name"]];

    NSURL *imageUrl = [NSURL URLWithString:[self.foodArr[indexPath.row] objectForKey:@"pic"]];
    [cell.picView sd_setImageWithURL:imageUrl];
    
    return cell;
}

- (void)textFieldTextChange:(UITextField *)textField{
    if([textField.text isEqualToString:@""]){
        [self.submitButton setBackgroundImage:[UIImage imageNamed:@"BUTTON_BG_GRAY_SHORT"] forState:UIControlStateNormal];
        [self.submitButton setUserInteractionEnabled:NO];
    }else{
        [self.submitButton setBackgroundImage:[UIImage imageNamed:@"BUTTON_BG_DEFAULT_SHORT"] forState:UIControlStateNormal];
        [self.submitButton setUserInteractionEnabled:YES];
    }
}

@end
