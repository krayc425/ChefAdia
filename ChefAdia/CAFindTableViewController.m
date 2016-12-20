//
//  CAFindTableViewController.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/5.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAFindTableViewController.h"
#import "CAFindItemTableViewCell.h"
#import "CALoginManager.h"

@interface CAFindTableViewController ()

@end

@implementation CAFindTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CAFindItemTableViewCell";
    UINib *nib = [UINib nibWithNibName:@"CAFindItemTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    CAFindItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UIImage *img;
    NSString *mainText;
    NSString *subText;
    switch (indexPath.row) {
        case 0:
            img = [UIImage imageNamed:@"FIND_1"];
            mainText = @"MY MENU";
            subText = @"MAKE YOUR OWN EXCLUSIVE MENU";
            break;
        case 1:
            img = [UIImage imageNamed:@"FIND_2"];
            mainText = @"MEAL TICKET";
            subText = @"BUY SOME VALUABLE MEAL TICKETS";
            break;
        default:
            break;
    }
    [cell.imgView setImage:img];
    [cell.mainLabel setText:mainText];
    [cell.subLabel setText:subText];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[CALoginManager shareInstance] getLoginState] == LOGOUT){
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Please login first"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertC addAction:okAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }else{
        switch (indexPath.row) {
            case 0:
                [self performSegueWithIdentifier:@"menuSegue" sender:nil];
                break;
            case 1:
                [self performSegueWithIdentifier:@"mealTicketSegue" sender:nil];
                break;
            default:
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 10;
}

@end
