//
//  CAFoodMenu.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/8.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAFoodMenu.h"

@implementation CAFoodMenu

- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithName:(NSString *)name andNum:(int)num{
    self = [super init];
    if(self){
        _name = name;
        _number = num;
    }
    return self;
}

@end
