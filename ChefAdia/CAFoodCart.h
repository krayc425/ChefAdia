//
//  CAFoodCart.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/9.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAFoodCart : NSObject

//里面放的都是 CAFoodDetailInCart
@property (nonatomic, nonnull) NSMutableArray *foodArr;

+ (_Nonnull instancetype)shareInstance;

- (void)modifyFoodInCartWithName:(NSString *_Nonnull)foodName andNum:(int)num andPrice:(double)price;
- (double)getTotalPrice;
- (int)getTotalNum;
- (NSArray *_Nonnull)getFoodInCart;

@end
