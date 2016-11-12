//
//  CAFoodMenu.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/8.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>

//食物大类
@interface CAFoodMenu : NSObject

@property (nonnull, nonatomic) NSString *name;
@property (nonatomic) int number;

- (_Nonnull instancetype)initWithName:(NSString *_Nonnull)name andNum:(int)num;

@end
