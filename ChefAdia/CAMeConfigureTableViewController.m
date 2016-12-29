//
//  CAMeConfigureTableViewController.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/8.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAMeConfigureTableViewController.h"
#import "Utilities.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "CALoginManager.h"

#define PHONE_URL @"http://47.89.194.197:8081/ChefAdia-1.0-SNAPSHOT/user/modPhone"
#define ADDRESS_URL @"http://47.89.194.197:8081/ChefAdia-1.0-SNAPSHOT/user/modAddr"

@interface CAMeConfigureTableViewController (){
    NSString *fontName;
}

@end

@implementation CAMeConfigureTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //多余的 cell 不显示
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    fontName = [Utilities getFont];
    
    _destinationInstructionLabel.font = [UIFont fontWithName:fontName size:15];
    _destinationLabel.font = [UIFont fontWithName:fontName size:25];
    
    _phoneInstructionLabel.font = [UIFont fontWithName:fontName size:15];
    _phoneLabel.font = [UIFont fontWithName:fontName size:25];
    
    [self refreshLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)refreshLabel{
    _destinationLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_addr"];
    _phoneLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_phone"];
}

- (void)editDestination{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Edit destination"
                                                                    message:@""
                                                             preferredStyle:UIAlertControllerStyleAlert];
    [alertC addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"Enter your destination";
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action){
                                                         
                                                         UITextField *destinationText = alertC.textFields.firstObject;
                                                         NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                                         
                                                         NSDictionary *tempDict = @{
                                                                                    @"userid" : (NSString *)[userDefaults valueForKey:@"user_id"],
                                                                                    @"addr" : destinationText.text,
                                                                                    };
                                                         
                                                         AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                                                         
                                                         manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                                                         
                                                         manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                                                                              @"text/plain",
                                                                                                              @"application/json",
                                                                                                              @"text/html",
                                                                                                              @"text/json",
                                                                                                              nil];

                                                         [manager POST:ADDRESS_URL
                                                           parameters:tempDict
                                                             progress:nil
                                                              success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                                                                  NSDictionary *resultDict = (NSDictionary *)responseObject;
                                                                  if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                                                                      
                                                                      [_destinationLabel setText: [destinationText text]];
                                                                      [self.tableView reloadData];
                                                                      
                                                                      [[CALoginManager shareInstance] setAddress:[destinationText text]];
                                                                      [[CALoginManager shareInstance] setLoginState:LOGIN];
                                                                      
                                                                  }else{
                                                                      NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"code"]);
                                                                  }
                                                                  
                                                              }
                                                              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                                  NSLog(@"%@",error);
                                                              }];
                                                         
                                                     }];
    [alertC addAction:cancelAction];
    [alertC addAction:okAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)editPhone{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Edit phone number"
                                                                    message:@""
                                                             preferredStyle:UIAlertControllerStyleAlert];
    [alertC addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"Enter your phone number";
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action){
                                                         
                                                         UITextField *phoneText = alertC.textFields.firstObject;
                                                         NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                                         
                                                         NSDictionary *tempDict = @{
                                                                                    @"userid" : (NSString *)[userDefaults valueForKey:@"user_id"],
                                                                                    @"phone" : (NSString *)phoneText.text,
                                                                                    };
                                                         
                                                         AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                                                         
                                                         manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                                                         
                                                         manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                                                                              @"text/plain",
                                                                                                              @"application/json",
                                                                                                              @"text/html",
                                                                                                              @"text/json",
                                                                                                              nil];

                                                         [manager POST:PHONE_URL
                                                           parameters:tempDict
                                                             progress:nil
                                                              success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                                                                  NSDictionary *resultDict = (NSDictionary *)responseObject;
                                                                  if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                                                                      
                                                                      [_phoneLabel setText:[phoneText text]];
                                                                      [self.tableView reloadData];
                                                                      
                                                                      [[CALoginManager shareInstance] setPhone:[phoneText text]];
                                                                      [[CALoginManager shareInstance] setLoginState:LOGIN];
                                                                      
                                                                  }else{
                                                                      NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"message"]);
                                                                  }
                                                                  
                                                              }
                                                              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
    switch (section) {
        case 0:
            return 2;
        default:
            return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self editDestination];
            break;
        case 1:
            [self editPhone];
            break;
        default:
            break;
    }
}

@end
