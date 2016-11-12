//
//  CAMeLoginTableViewController.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/5.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAMeLoginTableViewController.h"
#import "Utilities.h"
#import "CALoginManager.h"

@interface CAMeLoginTableViewController (){
    NSString *fontName;
    UIColor *color;
}

@end

@implementation CAMeLoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    fontName = [Utilities getFont];
    color = [Utilities getColor];
    
    _userNameLabel.font = [UIFont fontWithName:[Utilities getBoldFont] size:20];
    _addressLabel.font = [UIFont fontWithName:fontName size:15];
    
    _historyView.image = [UIImage imageNamed:@"HISTORY_ICON"];
    _settingsView.image = [UIImage imageNamed:@"SETTINGS_ICON"];
    _weChatView.image = [UIImage imageNamed:@"WECHAT_ICON"];
    
    _historyLabel.font = [UIFont fontWithName:fontName size:15];
    _settingsLabel.font = [UIFont fontWithName:fontName size:15];
    _weChatLabel.font = [UIFont fontWithName:fontName size:15];
    
    _logoutButton.titleLabel.font = [UIFont fontWithName:fontName size:15];
    [_logoutButton setTitleColor:color forState:UIControlStateNormal];
    
    [self refreshLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated{
    [self refreshLabel];
}

- (void)refreshLabel{
    _userNameLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_name"];
    _addressLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_destination"];
    
//    [_avatarView setImage:[UIImage imageNamed:@"AVATAR_FAKE"]];
}

- (IBAction)logoutAction:(id)sender{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Sure to logout?"
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action){
                                                         
                                                         NSLog(@"LOG OUT");
                                                         [CALoginManager setLoginState:LOGOUT];
                                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"Logout" object:nil];
                                                         
                                                     }];
    [alertC addAction:cancelAction];
    [alertC addAction:okAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 3;
        default:
            return 0;
    }
}

@end
