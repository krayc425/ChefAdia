//
//  CAFoodDetailInCart.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/8.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>

//每一大类食物里面的具体食物
@interface CAFoodDetailInCart : NSObject

@property (nonnull, nonatomic) NSString *name;
@property (nonatomic) double price;
//当前拥有的数量
@property (nonatomic) int number;

- (_Nonnull instancetype)initWithName:(NSString *_Nonnull)name andPrice:(double)price;

@end
