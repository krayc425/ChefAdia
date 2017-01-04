//
//  CAFoodDetailTableViewController.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/8.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAFoodDetailTableViewController.h"
#import "CAFoodDetailTableViewCell.h"
#import "CAFoodPayViewController.h"
#import "CAFoodCart.h"
#import "CAFoodMenu.h"
#import "CAFoodDetailInCart.h"
#import "Utilities.h"
#import "CAFoodDetail.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CAFoodDetailExtraView.h"
#import "CALoginManager.h"
#import "MBProgressHUD.h"

#define MARGIN 20

#define LIST_URL @"http://47.89.194.197:8081/ChefAdia-1.0-SNAPSHOT/menu/getList"

@interface CAFoodDetailTableViewController (){
    NSString *fontName;
    UIColor *color;
}

@end

@implementation CAFoodDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    fontName = [Utilities getFont];
    color = [Utilities getColor];
    
    [self.naviItem setTitle:[_foodType name]];
    
    [self.numberLabel setFont:[UIFont fontWithName:fontName size:20]];
    [self.billCountItem setTintColor:color];
    [self.buyItem setTintColor:color];
    
    _foodCart = [CAFoodCart shareInstance];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView reloadData];
}

- (void)loadFood{
    _foodArr = [[NSMutableArray alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *tempDict = @{
                              @"menuid" : [NSString stringWithFormat:@"%d",_foodType.ID],
                              };
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setMode:MBProgressHUDModeText];
    [hud.label setText: @"Loading"];
    [hud setRemoveFromSuperViewOnHide:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager GET:LIST_URL
      parameters:tempDict
        progress:^(NSProgress * _Nonnull uploadProgress) {
            [hud setProgressObject:uploadProgress];
        }

         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             NSDictionary *resultDict = (NSDictionary *)responseObject;
             if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                 
                 [hud hideAnimated:YES];
                 
                 NSDictionary *subResultDict = (NSDictionary *)[resultDict objectForKey:@"data"];
                 
                 for(NSDictionary *Dict in (NSArray *)[subResultDict objectForKey:@"list"]){
                     
                     CAFoodDetail *caFoodDetail = [[CAFoodDetail alloc] initWithName:[Dict objectForKey:@"name"]
                                                                             andID:[Dict objectForKey:@"foodid"]
                                                                            andPrice:[[Dict objectForKey:@"price"] doubleValue]
                                                                              andPic:[Dict objectForKey:@"pic"]
                                                                            andLikes:[[Dict objectForKey:@"good_num"] intValue]
                                                                         andDislikes:[[Dict objectForKey:@"bad_num"] intValue]
                                                                           andExtras:[Dict objectForKey:@"extraFood"]
                                                                      andDescription:[Dict objectForKey:@"description"]];
                     [_foodArr addObject:caFoodDetail];
                 }
                 
                 weakSelf.foodNum = [[subResultDict objectForKey:@"num"] intValue];
                
                 [weakSelf.numberLabel setText:[NSString stringWithFormat:@"%d SELECTION%s",
                                                weakSelf.foodNum, weakSelf.foodNum <= 1 ? "" : "S"]];
                 
                 NSURL *imageUrl = [NSURL URLWithString:[subResultDict objectForKey:@"pic"]];
                 [weakSelf.titleImgView sd_setImageWithURL:imageUrl];
                 
                 [weakSelf.tableView reloadData];
             }else{
                 NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"message"]);
             }
             
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@",error);
         }];
}

- (void)viewWillAppear:(BOOL)animated{
    //加载所有食物数组
//    [self loadFood];
    
    [self.navigationController setToolbarHidden:NO];
    [self.billCountItem setTitle:[NSString stringWithFormat:@"TOTAL BILL : $%.2f", [_foodCart getTotalPrice]]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setToolbarHidden:YES];
}

- (IBAction)payAction:(id)sender{
    if([[CALoginManager shareInstance] getLoginState] == LOGOUT){
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Please login first"
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
        if([_foodCart getTotalNum] == 0){
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"No food in cart"
                                                                            message:nil
                                                                     preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertC addAction:okAction];
            [self presentViewController:alertC animated:YES completion:nil];
        }else{
            [self performSegueWithIdentifier:@"paySegue" sender:nil];
        }
    }
}

#pragma mark - Cell Action

- (void)addNum:(id)sender{
    NSLog(@"add");
    CAFoodDetailTableViewCell *cell = (CAFoodDetailTableViewCell *)sender;
    //ADD IN FOOD CART
    CAFoodDetail *caFoodDetail = [_foodArr objectAtIndex:[[self.tableView indexPathForCell:cell] row]];
    [[CAFoodCart shareInstance] modifyFoodInCartWithID:caFoodDetail.foodid
                                               andName:caFoodDetail.name
                                                andNum:1
                                              andPrice:[[cell.priceLabel.text substringFromIndex:1] doubleValue]];
    [self updatePrice];
}

- (void)minusNum:(id)sender{
    NSLog(@"minus");
    CAFoodDetailTableViewCell *cell = (CAFoodDetailTableViewCell *)sender;
    //MINUS IN FOOD CART
    CAFoodDetail *caFoodDetail = [_foodArr objectAtIndex:[[self.tableView indexPathForCell:cell] row]];
    [[CAFoodCart shareInstance] modifyFoodInCartWithID:caFoodDetail.foodid
                                               andName:caFoodDetail.name
                                                andNum:-1
                                              andPrice:[[cell.priceLabel.text substringFromIndex:1] doubleValue]];
    [self updatePrice];
}

- (void)selectExtra:(id)sender{
    NSLog(@"extra");
    CAFoodDetailTableViewCell *cell = (CAFoodDetailTableViewCell *)sender;
    if([cell.currNumLabel.text intValue] == 0){
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"You didn't choose this food"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertC addAction:okAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }else{
        CAFoodDetail *caFoodDetail = [_foodArr objectAtIndex:[[self.tableView indexPathForCell:cell] row]];
        
        CAFoodDetailExtraView *extraView =
        [[CAFoodDetailExtraView alloc] initWithFrame:CGRectMake(MARGIN,
                                                                self.view.center.y + 22 - ([caFoodDetail.extras count] * 80) / 2,
                                                                self.view.frame.size.width - 2 * MARGIN,
                                                                [caFoodDetail.extras count] * 80)
                                           withExtra:caFoodDetail.extras];
        extraView.delegate = self;
        [extraView showInView:self.view];
    }
}

- (void)updatePrice{
    //GET TOTAL PRICE FROM FOOD CART
    [self.billCountItem setTitle:[NSString stringWithFormat:@"TOTAL BILL : $%.2f", [_foodCart getTotalPrice]]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 1:
            return _foodNum;
        default:
            return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1){
        static NSString *cellIdentifier = @"CAFoodDetailTableViewCell";
        UINib *nib = [UINib nibWithNibName:@"CAFoodDetailTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        CAFoodDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        CAFoodDetail *food = [_foodArr objectAtIndex:indexPath.row];
        
        [cell.nameLabel setText:[NSString stringWithFormat:@"%@", food.name]];
        [cell.goodLabel setText:[NSString stringWithFormat:@"%d", food.likes]];
        [cell.badLabel setText:[NSString stringWithFormat:@"%d", food.dislikes]];
        [cell.priceLabel setText:[NSString stringWithFormat:@"$%.2f", food.price]];
        [cell.descriptionLabel setText:[NSString stringWithFormat:@"%@", food.foodDescription]];
        
        //NSArray *arr = food.extras;
        if([food.extras count] == 0){
            [cell.extraButton setBackgroundImage:[UIImage imageNamed:@"BUTTON_BG_GRAY_EXTRA"] forState:UIControlStateNormal];
            [cell.extraButton setUserInteractionEnabled:NO];
        }else{
            [cell.extraButton setBackgroundImage:[UIImage imageNamed:@"BUTTON_BG_DEFAULT_EXTRA"] forState:UIControlStateNormal];
            [cell.extraButton setUserInteractionEnabled:YES];
        }
        
        NSURL *imageUrl = [NSURL URLWithString:food.pic];
        [cell.picView sd_setImageWithURL:imageUrl];
        
        bool foundFlag = false;
        NSArray *tmpFoodArr = [[CAFoodCart shareInstance] getFoodInCart];
        for(int i = 0; i < [tmpFoodArr count]; i++){
            CAFoodDetailInCart *foodCart = tmpFoodArr[i];
            if([foodCart.foodID isEqualToString:[self.foodArr[indexPath.row] foodid]]){
                foundFlag = true;
                [cell.currNumLabel setText:[NSString stringWithFormat:@"%d",foodCart.number]];
                break;
            }
        }
        if(!foundFlag){
            [cell.currNumLabel setText:@"0"];
        }

        cell.tag = (int)indexPath.row;
    
        cell.delegate = self;
        
        return cell;
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"paySegue"]){
        CAFoodPayViewController *caFoodPayViewController = (CAFoodPayViewController *)[segue destinationViewController];
        [caFoodPayViewController setPrice:[NSString stringWithFormat:@"$%.2f",[_foodCart getTotalPrice]]];
        [caFoodPayViewController setPayFoodArr:(NSMutableArray *)[_foodCart getFoodInCart]];
        [caFoodPayViewController setTotalNum:[_foodCart getTotalNum]];
    }
}

@end
