//
//  CAFindMenuAddViewController.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/12/15.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAFindMenuAddViewController.h"
#import "CAFindMenuAddTableViewCell.h"
#import "AFNetworking.h"
#import "Utilities.h"
#import "CAMenuData.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CAFindMenuListViewController.h"

#define MMENU_FOOD_URL @"http://47.89.194.197:8081/ChefAdia-1.0-SNAPSHOT/user/getMMenuInfo"

@interface CAFindMenuAddViewController ()

@end

@implementation CAFindMenuAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *fontName = [Utilities getFont];
    UIColor *color = [Utilities getColor];
    
    [self.stepLabel setFont:[UIFont fontWithName:[Utilities getBoldFont] size:30]];
    [self.stepLabel setTextColor:color];
    
    [self.priceInstructionLabel setFont:[UIFont fontWithName:[Utilities getBoldFont] size:15]];
    [self.priceInstructionLabel setTextColor:color];
    [self.totalPriceLabel setFont:[UIFont fontWithName:[Utilities getBoldFont] size:20]];
    [self.totalPriceLabel setTextColor:color];
    
    [self.prevButton.titleLabel setFont:[UIFont fontWithName:fontName size:20]];
    [self.nextButton.titleLabel setFont:[UIFont fontWithName:fontName size:20]];
    [self.prevButton.titleLabel setTextColor:[UIColor whiteColor]];
    [self.nextButton.titleLabel setTextColor:[UIColor whiteColor]];
    [self.prevButton setBackgroundImage:[UIImage imageNamed:@"BUTTON_BG_CLEAR"] forState:UIControlStateNormal];
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"BUTTON_BG_GRAY_SHORT"] forState:UIControlStateNormal];
    
    [self.priceLabel setFont:[UIFont fontWithName:fontName size:20]];
    [self.descriptionLabel setFont:[UIFont fontWithName:fontName size:20]];
    [self.numLabel setFont:[UIFont fontWithName:fontName size:20]];
    
    //对应的编号是 index+1(1~6)，tag 是 index (0~5)
    self.currentStep = 1;
    self.typeArr = [CAMenuData getShortNameList];
    for(UIButton *button in self.menuStackView.subviews){
        [button setTitle:self.typeArr[button.tag] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:fontName size:15]];
    }
    
    self.chosenFoodArr = [[NSMutableArray alloc] init];
    self.chosenNumArr = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self.typeArr count]; i++){
        [self.chosenFoodArr addObject:@{@"foodid" : @""}];
        [self.chosenNumArr addObject:[NSNumber numberWithInt:0]];
    }
    
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self loadMFood];
}

- (void)refreshView{
    [self.stepLabel setText:[NSString stringWithFormat:@"STEP %d/%lu", self.currentStep, [self.typeArr count]]];
    if(self.currentStep == 1){
        [self.prevButton setBackgroundImage:[UIImage imageNamed:@"BUTTON_BG_CLEAR"] forState:UIControlStateNormal];
    }else{
        [self.prevButton setBackgroundImage:[UIImage imageNamed:@"BUTTON_BG_DEFAULT_SHORT"] forState:UIControlStateNormal];
    }
    
    if(self.currentStep == [self.typeArr count]){
        [self.nextButton setTitle:@"DONE" forState:UIControlStateNormal];
        [self.nextButton.titleLabel setFont:[UIFont fontWithName:[Utilities getBoldFont] size:20]];
        
    }else{
        [self.nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
        [self.nextButton.titleLabel setFont:[UIFont fontWithName:[Utilities getFont] size:20]];
    }
    
    for(int i = 1; i <= self.currentStep; i++){
        [self.menuStackView.subviews[i-1] setUserInteractionEnabled:YES];
    }
    if([self isChosenFinished:self.currentStep - 1]){
        [self.nextButton setBackgroundImage:[UIImage imageNamed:@"BUTTON_BG_DEFAULT_SHORT"] forState:UIControlStateNormal];
        [self.nextButton setUserInteractionEnabled:YES];
    }else{
        [self.nextButton setBackgroundImage:[UIImage imageNamed:@"BUTTON_BG_GRAY_SHORT"] forState:UIControlStateNormal];
        [self.nextButton setUserInteractionEnabled:NO];
        
        for(int i = self.currentStep+1; i <= self.typeArr.count; i++){
            [self.menuStackView.subviews[i-1] setUserInteractionEnabled:NO];
        }
    }
    
    for(UIButton *button in self.menuStackView.subviews){
        if(button.tag == self.currentStep - 1){
            [button setBackgroundColor: [Utilities getColor]];
            [button.titleLabel setTextColor:[UIColor whiteColor]];
        }else{
            [button setBackgroundColor: [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0]];
            [button.titleLabel setTextColor:[Utilities getColor]];
        }
    }
    
    [self.numLabel setText:[self.chosenNumArr[self.currentStep-1] description]];
    
    [self.filteredFoodArr removeAllObjects];
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF['type'] == %d", self.currentStep];
    self.filteredFoodArr = [[self.typeFoodArr filteredArrayUsingPredicate:searchPredicate] mutableCopy];
    
    [self.priceLabel setText:[NSString stringWithFormat:@"$%.2f", [[self.filteredFoodArr[0] objectForKey:@"price"] doubleValue]]];
    
    [self.menuTableView reloadData];
}

- (Boolean)isChosenFinished:(int)i{
    if([[self.chosenFoodArr[i] objectForKey:@"foodid"] isEqualToString:@""]
       || [self.chosenNumArr[i] intValue] == 0){
        return false;
    }else{
        return true;
    }
}

- (double)calTotalPrice{
    double sum = 0.0;
    for(int i = 0; i < [self.typeArr count]; i++){
        sum += ([self.chosenNumArr[i] intValue]) * [[self.chosenFoodArr[0] objectForKey:@"price"] doubleValue];
    }
    return sum;
}

- (void)loadMFood{
    self.typeFoodArr = [[NSMutableArray alloc] init];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager GET:MMENU_FOOD_URL
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             NSDictionary *resultDict = (NSDictionary *)responseObject;
             if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                 
                 NSArray *resultArr = (NSArray *)[resultDict objectForKey:@"data"];
                 for(NSDictionary *dict in resultArr){
                     [self.typeFoodArr addObject:dict];
                 }
                 [self refreshView];
                 
             }else{
                 NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"message"]);
             }
             
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@",error);
         }];
}

- (IBAction)prevAction:(id)sender{
    if(self.currentStep > 1){
        self.currentStep--;
        [self refreshView];
    }
}

- (IBAction)nextAction:(id)sender{
    if(self.currentStep < [self.typeArr count]){
        self.currentStep++;
        [self refreshView];
    }else if(self.currentStep == [self.typeArr count]){
        [self performSegueWithIdentifier:@"submitMenuSegue" sender:nil];
    }
}

- (IBAction)modifyStepAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    self.currentStep = (int)button.tag+1;
    [self refreshView];
}

- (IBAction)addAction:(id)sender{
    int i = [self.chosenNumArr[self.currentStep-1] intValue];
    i++;
    self.chosenNumArr[self.currentStep-1] = [NSNumber numberWithInt:i];
    [self.totalPriceLabel setText:[NSString stringWithFormat:@"$%.2f", self.calTotalPrice]];
    [self refreshView];
}

- (IBAction)minusAction:(id)sender{
    int i = [self.chosenNumArr[self.currentStep-1] intValue];
    if(i > 0){
        i--;
        self.chosenNumArr[self.currentStep-1] = [NSNumber numberWithInt:i];
    }
    [self.totalPriceLabel setText:[NSString stringWithFormat:@"$%.2f", self.calTotalPrice]];
    [self refreshView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filteredFoodArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CAFindMenuAddTableViewCell";
    UINib *nib = [UINib nibWithNibName:@"CAFindMenuAddTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    CAFindMenuAddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell.nameLabel setText:[self.filteredFoodArr[indexPath.row] objectForKey:@"name"]];
    NSURL *imageUrl = [NSURL URLWithString:[self.filteredFoodArr[indexPath.row] objectForKey:@"pic"]];
    [cell.picView sd_setImageWithURL:imageUrl];
    
    if([self.chosenFoodArr containsObject:self.filteredFoodArr[indexPath.row]]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.chosenFoodArr replaceObjectAtIndex:self.currentStep-1
                                  withObject:self.filteredFoodArr[indexPath.row]];
    [self refreshView];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"submitMenuSegue"]){
        CAFindMenuListViewController *caFindMenuListViewController = [segue destinationViewController];
        [caFindMenuListViewController setTotalPrice:[[self.totalPriceLabel.text substringFromIndex:1] doubleValue]];
        [caFindMenuListViewController setTypeArr:[NSMutableArray arrayWithArray:self.typeArr]];
        [caFindMenuListViewController setNumArr:self.chosenNumArr];
        [caFindMenuListViewController setFoodArr:self.chosenFoodArr];
    }
}

@end
