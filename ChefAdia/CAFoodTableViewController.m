//
//  CAFoodTableViewController.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/8.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAFoodTableViewController.h"
#import "CAFoodTableViewCell.h"
#import "CAFoodMenu.h"
#import "Utilities.h"
#import "CAFoodDetailTableViewController.h"
#import "CAFoodPayViewController.h"
#import "CAFoodDetailInCart.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MBProgressHUD.h"

#define MENU_URL @"http://47.89.194.197:8081/ChefAdia-1.0-SNAPSHOT/menu/getMenu"
#define GET_EASY_ORDER_URL @"http://47.89.194.197:8081/ChefAdia-1.0-SNAPSHOT/user/getEasyOrder"

@interface CAFoodTableViewController (){
    NSString *fontName;
}

@end

@implementation CAFoodTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    fontName = [Utilities getFont];
    
    //加载食物大类
//    [self loadMenu];
    
    _backgroundView.image = [UIImage imageNamed:@"FOOD_TITLE"];
    _menuLabel.font = [UIFont fontWithName:fontName size:15];
    _name1Label.font = [UIFont fontWithName:[Utilities getBoldFont] size:40];
    _name2Label.font = [UIFont fontWithName:fontName size:20];
    _contactLabel.font = [UIFont fontWithName:fontName size:15];
    
    [_easyOrderButton.titleLabel setFont: [UIFont fontWithName:[Utilities getBoldFont] size:15]];
    [self checkEasyOrder];
    
    _name1Label.text = @"CHEFADIA'S";
    _name2Label.text = @"DELICIOUS CHINESE FOOD";
    _contactLabel.text = @"XIANLIN AVENUE\n10:00 A.M. ~ 22:00 P.M.";
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [self checkEasyOrder];
//    [self loadMenu];
}

- (void)checkEasyOrder{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"easy_order_id"] != NULL){
        [_easyOrderButton setBackgroundImage:[UIImage imageNamed:@"BUTTON_BG_DEFAULT"] forState:UIControlStateNormal];
        [_easyOrderButton setUserInteractionEnabled:YES];
    }else{
        [_easyOrderButton setBackgroundImage:[UIImage imageNamed:@"BUTTON_BG_GRAY"] forState:UIControlStateNormal];
        [_easyOrderButton setUserInteractionEnabled:NO];
    }
}

- (IBAction)easyOrderAction:(id)sender{
    if([_easyOrderButton isUserInteractionEnabled]){
        
        NSDictionary *tempDict = @{
                                   @"userid" : [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"],
                                   };
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                             @"text/plain",
                                                             @"text/html",
                                                             nil];
        [manager GET:GET_EASY_ORDER_URL
          parameters:tempDict
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                 NSDictionary *resultDict = (NSDictionary *)responseObject;
                 if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                     
                     [self performSegueWithIdentifier:@"easyOrderSegue" sender:[resultDict objectForKey:@"data"]];
                     
                 }else{
                     NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"message"]);
                 }
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"%@",error);
             }];
    }
}

- (void)loadMenu{
    _menuArr = [[NSMutableArray alloc] init];

    __weak typeof(self) weakSelf = self;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setMode:MBProgressHUDModeText];
    [hud.label setText: @"Loading"];
    [hud setRemoveFromSuperViewOnHide:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager GET:MENU_URL
      parameters:nil
        progress:^(NSProgress * _Nonnull uploadProgress) {
            [hud setProgressObject:uploadProgress];
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             NSDictionary *resultDict = (NSDictionary *)responseObject;
             if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                 
                 [hud hideAnimated:YES];
                 
                 NSArray *resultArr = (NSArray *)[resultDict objectForKey:@"data"];
                 for(NSDictionary *dict in resultArr){
                     CAFoodMenu *tmpMenu = [[CAFoodMenu alloc] initWithID:[[dict valueForKey:@"menuid"] intValue]
                                                                   andPic:[dict valueForKey:@"pic"]
                                                                  andName:[dict valueForKey:@"name"]
                                                                   andNum:[[dict valueForKey:@"num"] intValue]];
                     [weakSelf.menuArr addObject:[tmpMenu copy]];
                 }
                 [weakSelf.tableView reloadData];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 1:
            return [_menuArr count];
        default:
            return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1){
        //注册 nib 的方法，来使用.xib 的cell
        static NSString *CellIdentifier = @"CAFoodTableViewCell";
        UINib *nib = [UINib nibWithNibName:@"CAFoodTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        CAFoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        //配置 cell 细节
        CAFoodMenu *item = _menuArr[indexPath.row];
        cell.nameLabel.text = [item name];
        cell.numberLabel.text = [NSString stringWithFormat:@"%d SELECTION%s", [item number], [item number] <= 1 ? "" : "S"];
        
        NSURL *imageUrl = [NSURL URLWithString:[item pic]];
        [cell.bgView sd_setImageWithURL:imageUrl];
        
        return cell;
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        [self performSegueWithIdentifier:@"detailSegue" sender:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }else{
        return 250;
    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 10;
    }else{
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"detailSegue"]){
        CAFoodDetailTableViewController *caFoodDetailTableViewController = (CAFoodDetailTableViewController *)[segue destinationViewController];
        NSIndexPath *path = (NSIndexPath *)sender;
        CAFoodMenu *caFoodMenu = (CAFoodMenu *)_menuArr[path.row];
        [caFoodDetailTableViewController setFoodType:caFoodMenu];
        
        [caFoodDetailTableViewController loadFood];
        
    }else if([segue.identifier isEqualToString:@"easyOrderSegue"]){
        [[CAFoodCart shareInstance] clearCart];
        
        NSDictionary *resultDict = (NSDictionary *)sender;
        CAFoodPayViewController *caFoodPayViewController = (CAFoodPayViewController *)[segue destinationViewController];
        
        NSArray *resultFoodArr = (NSArray *)[resultDict objectForKey:@"food_list"];
        for(NSDictionary *dict in resultFoodArr){
            [[CAFoodCart shareInstance] modifyFoodInCartWithID:[dict objectForKey:@"foodid"]
                                                       andName:[dict objectForKey:@"name"]
                                                        andNum:[[dict objectForKey:@"num"] intValue]
                                                      andPrice:[[dict objectForKey:@"price"] doubleValue]];
        }
        [caFoodPayViewController setPayFoodArr:[[CAFoodCart shareInstance] getFoodInCart]];
        //价格和时间要实时更新，不能用原来的
        [caFoodPayViewController setPrice:[NSString stringWithFormat:@"$%.2f", [[CAFoodCart shareInstance] getTotalPrice]]];
        [caFoodPayViewController setTotalNum:[[CAFoodCart shareInstance] getTotalNum]];
    }
}

@end
