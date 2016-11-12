//
//  CAFoodManager.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/8.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAFoodManager.h"
#import "CAFoodMenu.h"
#import "CAFoodDetailInCart.h"

@implementation CAFoodManager

static CAFoodManager* _instance = nil;

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance ;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [CAFoodManager shareInstance] ;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        //初始化食物类别列表
        [self initTypes];
        //初始化每个小列表的食物详情列表
    }
    return self;
}

- (void)initTypes{
    CAFoodMenu *rice = [[CAFoodMenu alloc] initWithName:@"RICE" andNum:13];
    CAFoodMenu *hotdish = [[CAFoodMenu alloc] initWithName:@"HOT DISH" andNum:22];
    CAFoodMenu *noodle = [[CAFoodMenu alloc] initWithName:@"NOODLE" andNum:9];
    _typeArr = [NSArray arrayWithObjects:rice, hotdish, noodle, nil];
}

- (NSArray *)getListOfFoodType{
    //初始化食物类别列表
    return _typeArr;
}

- (NSArray *)getListOfFoodWithType:(NSString *)type{
    return nil;
}

- (double)getPriceOfFood:(NSString *)foodName{
    return arc4random() % 1000 / 100.0;
}

@end
