//
//  CAFindMenuTableViewController.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/12/13.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAFindMenuTableViewController.h"
#import "CAFindMenuTableViewCell.h"
#import "Utilities.h"
#import "AFNetworking.h"
#import "CAFindMenuOrderViewController.h"
#import "CAFindMenuListViewController.h"

#define MMENU_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/user/getMList"
#define MMENU_DELETE_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/user/deleteMMenu"

@interface CAFindMenuTableViewController ()

@end

@implementation CAFindMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _backgroundView.image = [UIImage imageNamed:@"FIND_TITLE"];
    
    UIBarButtonItem *R1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                        target:self
                                                                        action:@selector(addAction:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:R1,nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadMMenu];
}

- (void)loadMMenu{
    _menuArr = [[NSMutableArray alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *requestDict = @{
                                  @"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                                  };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager GET:MMENU_URL
      parameters:requestDict
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             NSDictionary *resultDict = (NSDictionary *)responseObject;
             if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                 NSArray *resultArr = (NSArray *)[resultDict objectForKey:@"data"];
                 for(NSDictionary *dict in resultArr){
                     [self.menuArr addObject:dict];
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

- (void)addAction:(id)sender{
    [self performSegueWithIdentifier:@"addMenuSegue" sender:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 1:
            return [self.menuArr count];
        default:
            return 1;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        [self performSegueWithIdentifier:@"detailMenuSegue" sender:indexPath];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1){
        static NSString *cellIdentifier = @"CAFindMenuTableViewCell";
        UINib *nib = [UINib nibWithNibName:@"CAFindMenuTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        CAFindMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        [cell.nameLabel setText:[self.menuArr[indexPath.row] objectForKey:@"name"]];
        [cell.priceLabel setText:[NSString stringWithFormat:@"$%.2f", [[self.menuArr[indexPath.row] objectForKey:@"price"] doubleValue]]];
        
        return cell;
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Sure to delete?"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Delete"
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction *action){
                                                             
                                                             __weak typeof(self) weakSelf = self;
                                                             
                                                             NSDictionary *dict = @{
                                                                                    @"mmenuid" : [self.menuArr[indexPath.row] valueForKey:@"mmenuid"],
                                                                                    };
                                                             
                                                             AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                                                             manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                                                                                  @"text/plain",
                                                                                                                  @"text/html",
                                                                                                                  nil];
                                                             [manager GET:MMENU_DELETE_URL
                                                               parameters:dict
                                                                 progress:nil
                                                                  success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                                                                      NSDictionary *resultDict = (NSDictionary *)responseObject;
                                                                      if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                                                                          NSLog(@"delete success");
                                                                          
                                                                          [weakSelf loadMMenu];
                                                                          
                                                                          [weakSelf.tableView reloadData];
                                                                      }else{
                                                                          NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"msg"]);
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
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"detailMenuSegue"]){
        CAFindMenuOrderViewController *caFindMenuOrderViewController = [segue destinationViewController];
        NSIndexPath *path = (NSIndexPath *)sender;
        [caFindMenuOrderViewController setMenuid:[self.menuArr[path.row] objectForKey:@"mmenuid"]];
        
        
        
        
    }else if([segue.identifier isEqualToString:@"addMenuSegue"]){
        
    }
}

@end
