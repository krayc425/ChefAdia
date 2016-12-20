//
//  CAFoodDetailExtraView.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/12/11.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAFoodDetailExtraView.h"
#import "CAFoodDetailTableViewCell.h"
#import "CAFoodCart.h"
#import "CAFoodDetail.h"
#import "CAFoodDetailInCart.h"
#import "AFNetworking.h"
#import "Utilities.h"
#import "AFHTTPSessionManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define ZERO                    0.0f
#define ONE                     1.0f
#define ANIMATION_DURATION      0.5f
#define CONTAINER_BG_COLOR      [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1f]

@implementation CAFoodDetailExtraView

- (id)initWithFrame:(CGRect)frame withExtra:(NSArray *)extraArr{
    self = [super initWithFrame:frame];
    
    if (self){
        
        self.containerButton = [[UIButton alloc] init];
        [self.containerButton setBackgroundColor:CONTAINER_BG_COLOR];
//
//        [self.containerButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
//        [self.containerButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];
        
        self.okButton = [[UIButton alloc] init];
        [self.okButton setBackgroundImage:[UIImage imageNamed:@"BUTTON_BG_DEFAULT_SHORT"] forState:UIControlStateNormal];
        [self.okButton setTitle:@"OK" forState:UIControlStateNormal];
        [self.okButton.titleLabel setFont:[UIFont fontWithName:[Utilities getFont] size:20]];
        [self.okButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
        
        self.extraArr = [[NSMutableArray alloc] init];
        
        for(NSDictionary *Dict in extraArr){
            CAFoodDetail *caFoodDetail = [[CAFoodDetail alloc] initWithName:[Dict objectForKey:@"name"]
                                                                      andID:[Dict objectForKey:@"foodid"]
                                                                   andPrice:[[Dict objectForKey:@"price"] doubleValue]
                                                                     andPic:[Dict objectForKey:@"pic"]
                                                                   andLikes:[[Dict objectForKey:@"good_num"] intValue]
                                                                andDislikes:[[Dict objectForKey:@"bad_num"] intValue]
                                                                  andExtras:[Dict objectForKey:@"extraFood"]
                                                             andDescription:[Dict objectForKey:@"description"]];
            [self.extraArr addObject:caFoodDetail];
        }
        
        self.extraNum = (int)[self.extraArr count];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.scrollEnabled = NO;
        self.tableView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.tableView];
        [self addSubview:self.okButton];
        [self.containerButton addSubview:self];
    }
    
    return self;
}

- (void)dismissView{
    [UIView animateWithDuration:ANIMATION_DURATION
                     animations:^{
                         self.containerButton.alpha = ZERO;
                         self.okButton.alpha = ZERO;
                     }
                     completion:^(BOOL finished) {
                         [self.containerButton removeFromSuperview];
                         [self.okButton removeFromSuperview];
                     }];
}

- (void)showInView:(UIView *)view{
    self.containerButton.alpha = ZERO;
    self.okButton.alpha = ZERO;
    self.containerButton.frame = view.bounds;
    [view addSubview:self.containerButton];
    [self.okButton setFrame:CGRectMake(self.containerButton.bounds.size.width / 2 - 65,
                                       self.containerButton.bounds.size.height / 2 + (self.extraNum * 80 / 2) + 40,
                                       150,
                                       30)];
    [self.containerButton addSubview:self.okButton];
    
    [UIView animateWithDuration:ANIMATION_DURATION
                     animations:^{
                         self.containerButton.alpha = ONE;
                         self.okButton.alpha = ONE;
                     }
                     completion:^(BOOL finished) {
                     }];
}

#pragma mark - Cell Action

- (void)addNum:(id)sender{
    NSLog(@"add");
    CAFoodDetailTableViewCell *cell = (CAFoodDetailTableViewCell *)sender;
    //ADD IN FOOD CART
    CAFoodDetail *caFoodDetail = [self.extraArr objectAtIndex:[[self.tableView indexPathForCell:cell] row]];
    [[CAFoodCart shareInstance] modifyFoodInCartWithID:caFoodDetail.foodid
                                               andName:caFoodDetail.name
                                                andNum:1
                                              andPrice:[[cell.priceLabel.text substringFromIndex:1] doubleValue]];
    [self.delegate updatePrice];
}

- (void)minusNum:(id)sender{
    NSLog(@"minus");
    CAFoodDetailTableViewCell *cell = (CAFoodDetailTableViewCell *)sender;
    //MINUS IN FOOD CART
    CAFoodDetail *caFoodDetail = [self.extraArr objectAtIndex:[[self.tableView indexPathForCell:cell] row]];
    [[CAFoodCart shareInstance] modifyFoodInCartWithID:caFoodDetail.foodid
                                               andName:caFoodDetail.name
                                                andNum:-1
                                              andPrice:[[cell.priceLabel.text substringFromIndex:1] doubleValue]];
    [self.delegate updatePrice];
}

- (void)selectExtra:(id)sender{
    
}

#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.extraNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CAFoodDetailTableViewCell";
    UINib *nib = [UINib nibWithNibName:@"CAFoodDetailTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    CAFoodDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    CAFoodDetail *food = [self.extraArr objectAtIndex:indexPath.row];
    
    [cell.nameLabel setText:[NSString stringWithFormat:@"%@", food.name]];
    [cell.goodLabel setText:[NSString stringWithFormat:@"%d", food.likes]];
    [cell.badLabel setText:[NSString stringWithFormat:@"%d", food.dislikes]];
    [cell.priceLabel setText:[NSString stringWithFormat:@"$%.2f", food.price]];
    
    //NSArray *arr = food.extras;
    [cell.extraButton setHidden:YES];
    
    NSURL *imageUrl = [NSURL URLWithString:food.pic];
    [cell.picView sd_setImageWithURL:imageUrl];
    
    bool foundFlag = false;
    NSArray *tmpFoodArr = [[CAFoodCart shareInstance] getFoodInCart];
    for(int i = 0; i < [tmpFoodArr count]; i++){
        CAFoodDetailInCart *foodCart = tmpFoodArr[i];
        if([foodCart.foodID isEqualToString:[self.extraArr[indexPath.row] foodid]]){
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

@end
