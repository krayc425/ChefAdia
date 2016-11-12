//
//  Utilities.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/4.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

//Silver RGB: 214 214 214
+ (UIColor *)getColor{
    return [UIColor colorWithRed:193.0/255.0 green:85.0/255.0 blue:76.0/255.0 alpha:1.0];
}

+ (NSString *)getFont{
    return @"CenturyGothic";
}

+ (NSString *)getBoldFont{
    return @"CenturyGothic-Bold";
}

+ (UIColor *)getWechatColor{
    return [UIColor colorWithRed:136.0/255.0 green:196.0/255.0 blue:42.0/255.0 alpha:1.0];
}

@end
