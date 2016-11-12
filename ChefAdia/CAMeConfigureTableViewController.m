//
//  CAMeConfigureTableViewController.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/8.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAMeConfigureTableViewController.h"
#import "Utilities.h"

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
    _destinationLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_destination"];
    _phoneLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_phone"];
}

- (void)editDestination{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Edit Destination"
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
                                                         [[NSUserDefaults standardUserDefaults] setValue:destinationText.text forKey:@"user_destination"];
                                                         [self refreshLabel];
                                                         
                                                     }];
    [alertC addAction:cancelAction];
    [alertC addAction:okAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)editPhone{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Edit Phone Number"
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
                                                         [[NSUserDefaults standardUserDefaults] setValue:phoneText.text forKey:@"user_phone"];
                                                         [self refreshLabel];
                                                         
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
