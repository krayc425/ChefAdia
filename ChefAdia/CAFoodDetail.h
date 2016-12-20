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
@property (nonatomic, nonnull) NSString *foodid;
@property (nonatomic) double price;
@property (nonatomic, nonnull) NSString *pic;
@property (nonatomic) int likes;
@property (nonatomic) int dislikes;
@property (nonnull, nonatomic) NSArray *extras;
@property (nonnull, nonatomic) NSString *foodDescription;

- (_Nonnull instancetype)initWithName:(NSString *_Nonnull)name andID:(NSString *_Nonnull)foodid andPrice:(double)price andPic:(NSString *_Nonnull)pic andLikes:(int)likes andDislikes:(int)dislikes andExtras:(NSArray *_Nonnull)extras andDescription:(NSString *_Nonnull)des;

@end
