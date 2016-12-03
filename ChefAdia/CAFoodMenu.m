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

- (id)initWithID:(int)ID andPic:(NSString *_Nonnull)pic andName:(NSString *_Nonnull)name andNum:(int)num {
    self = [super init];
    if(self){
        _name = name;
        _number = num;
        _ID = ID;
        _pic = pic;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    CAFoodMenu *caFoodMenu = [[CAFoodMenu alloc] init];
    caFoodMenu.name = self.name;
    caFoodMenu.number = self.number;
    caFoodMenu.ID = self.ID;
    caFoodMenu.pic = self.pic;
    return caFoodMenu;
}

@end
