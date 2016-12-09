//
//  CAFoodCart.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/9.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAFoodCart.h"
#import "CAFoodDetailInCart.h"

@implementation CAFoodCart

static CAFoodCart* _instance = nil;

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance ;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [CAFoodCart shareInstance] ;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _foodArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)copyWithZone:(struct _NSZone *)zone{
    return [CAFoodCart shareInstance] ;
}

- (void)modifyFoodInCartWithID:(NSString *)foodID andName:(NSString *_Nonnull)foodName andNum:(int)num andPrice:(double)price{
    bool foundFlag = false;
    for(int i = 0; i < [_foodArr count]; i++){
        CAFoodDetailInCart *food = _foodArr[i];
        if([food.foodID isEqualToString:foodID]){
            foundFlag = true;
            food.number += num;
            //如果数量变为0，那么删除元素
            if(food.number == 0){
                [_foodArr removeObjectAtIndex:i];
            }
            break;
        }
    }
    //原来没有，那么增加一个元素
    if(!foundFlag){
        [_foodArr addObject:[[CAFoodDetailInCart alloc] initWithID:foodID andName:foodName andPrice:price andNum:num]];
    }
}

- (double)getTotalPrice{
    double sum = 0.0;
    for(CAFoodDetailInCart *food in _foodArr){
        sum = sum + (food.price * food.number);
    }
    return sum;
}

- (int)getTotalNum{
    int sum = 0;
    for(CAFoodDetailInCart *food in _foodArr){
        sum = sum + food.number;
    }
    return sum;
}

- (NSArray *)getFoodInCart{
    return _foodArr;
}

- (void)clearCart{
    _foodArr = [[NSMutableArray alloc] init];
}

@end
