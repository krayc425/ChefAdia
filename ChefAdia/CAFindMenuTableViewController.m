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

- (void)addAction:(id)sender{
    NSLog(@"add menu");
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1){
        static NSString *cellIdentifier = @"CAFindMenuTableViewCell";
        UINib *nib = [UINib nibWithNibName:@"CAFindMenuTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        CAFindMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        return cell;
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"addMenuSegue"]){
        
    }
}

@end
