//
//  CAFoodDetailInCart.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/8.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAFoodDetailInCart.h"

@implementation CAFoodDetailInCart

- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithID:(NSString *)foodID andName:(NSString *_Nonnull)foodName andPrice:(double)price andNum:(int)num{
    self = [super init];
    if(self){
        _foodID = foodID;
        _foodName = foodName;
        _number = num;
        _price = price;
    }
    return self;
}

@end
