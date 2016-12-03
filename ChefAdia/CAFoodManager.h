//
//  CAFoodManager.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/8.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAFoodManager : NSObject

+ (_Nonnull instancetype)shareInstance;

@property (nonnull, nonatomic) __block NSMutableArray *typeArr;

- (void)initTypes;

//返回所有食物的类别的列表
- (NSArray *_Nonnull)getListOfFoodType;

//得到某一种类食物的详细食物列表
- (NSArray *_Nonnull)getListOfFoodWithType:(int)ID;

//得到某一种食物的价钱
- (double)getPriceOfFood:(NSString *_Nonnull)foodName;

@end
