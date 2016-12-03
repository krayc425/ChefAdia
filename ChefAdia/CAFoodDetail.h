//
//  CAFoodDetail.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/12/3.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>

//每一种食物
@interface CAFoodDetail : NSObject

@property (nonnull, nonatomic) NSString *name;
@property (nonatomic, nonnull) NSString *type;
@property (nonatomic) double price;
@property (nonatomic, nonnull) NSString *pic;
@property (nonatomic) int likes;
@property (nonatomic) int dislikes;

- (_Nonnull instancetype)initWithName:(NSString *_Nonnull)name andType:(NSString *_Nonnull)type andPrice:(double)price andPic:(NSString *_Nonnull)pic andLikes:(int)likes andDislikes:(int)dislikes;

@end
