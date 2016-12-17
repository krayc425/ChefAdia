//
//  CAMenuData.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/12/17.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAMenuData.h"

@implementation CAMenuData

+ (NSArray *)getShortNameList{
    return @[@"MEAL",
             @"MEAT",
             @"VEG",
             @"SNACK",
             @"SAUCE",
             @"FLAVOR"];
}

+ (NSArray *)getNameList{
    return @[@"MEAL",
             @"MEAT",
             @"VEGETABLE",
             @"SNACK",
             @"SAUCE",
             @"FLAVOR"];
}

@end
