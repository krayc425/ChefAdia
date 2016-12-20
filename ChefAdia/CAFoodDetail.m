//
//  CAFoodDetail.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/12/3.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAFoodDetail.h"

@implementation CAFoodDetail

- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithName:(NSString *)name andID:(NSString *)foodid andPrice:(double)price andPic:(NSString *)pic andLikes:(int)likes andDislikes:(int)dislikes andExtras:(NSArray * _Nonnull)extras andDescription:(NSString * _Nonnull)des{
    self = [super init];
    if(self){
        _name = name;
        _likes = likes;
        _dislikes = dislikes;
        _price = price;
        _pic = pic;
        _foodid = foodid;
        _extras = extras;
        _foodDescription = des;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    CAFoodDetail *caFoodDetail = [[CAFoodDetail alloc] init];
    caFoodDetail.name = self.name;
    caFoodDetail.foodid = self.foodid;
    caFoodDetail.price = self.price;
    caFoodDetail.likes = self.likes;
    caFoodDetail.dislikes = self.dislikes;
    caFoodDetail.pic = self.pic;
    caFoodDetail.extras = self.extras;
    caFoodDetail.foodDescription = self.foodDescription;
    return caFoodDetail;
}

@end
