//
//  CAFoodManager.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/8.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAFoodManager.h"
#import "CAFoodMenu.h"
#import "CAFoodDetailInCart.h"
#import "CANetworkManager.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "CAFoodDetail.h"

@implementation CAFoodManager

static CAFoodManager* _instance = nil;

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance ;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [CAFoodManager shareInstance] ;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        //初始化食物类别列表
        [self initTypes];
        //初始化每个小列表的食物详情列表
    }
    return self;
}

- (void)initTypes{
    
}

- (NSArray *)getListOfFoodType{
//    //初始化食物类别列表
    _typeArr = [[NSMutableArray alloc] init];
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
//                                                         @"text/plain",
//                                                         @"text/html",
//                                                         nil];
//    [manager GET:@"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/getMenu"
//      parameters:nil
//        progress:nil
//         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
//             for(NSDictionary *dict in (NSArray *)responseObject){
//                 CAFoodMenu *tmpMenu = [[CAFoodMenu alloc] initWithID:[[dict valueForKey:@"id"] intValue]
//                                                               andPic:[dict valueForKey:@"picture"]
//                                                              andName:[dict valueForKey:@"name"]
//                                                               andNum:[[dict valueForKey:@"dishnum"] intValue]];
//                 [_typeArr addObject:[tmpMenu copy]];
//             }
//         }
//         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//             NSLog(@"%@",error);
//         }];
//
//    NSLog(@"GET LIST OF TYPE");
//    NSLog(@"%lu", [_typeArr count]);
    return _typeArr;
}

- (NSArray *)getListOfFoodWithType:(int)ID{
    _typeArr = [[NSMutableArray alloc] init];
//
//    NSDictionary *temDict = @{
//                              @"menuid" : [NSString stringWithFormat:@"%d",ID],
//                              };
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
//                                                         @"text/plain",
//                                                         @"text/html",
//                                                         nil];
//    [manager GET:@"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/getList"
//      parameters:temDict
//        progress:nil
//         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
//             for(NSDictionary *dict in (NSArray *)responseObject){
//                 NSLog(@"KEY : %@ VALUE : %@", dict.allKeys, dict.allValues);
//                 CAFoodDetail *caFoodDetail = [[CAFoodDetail alloc] initWithName:[dict valueForKey:@"name"]
//                                                                         andType:[dict valueForKey:@"type"]
//                                                                        andPrice:[[dict valueForKey:@"price"] doubleValue]
//                                                                          andPic:[dict valueForKey:@"pic"]
//                                                                        andLikes:[[dict valueForKey:@"like"] intValue]
//                                                                     andDislikes:[[dict valueForKey:@"dislike"] intValue]];
//                 [_typeArr addObject:[caFoodDetail copy]];
//             }
//         }
//         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//             NSLog(@"%@",error);
//         }];
//    
//    NSLog(@"GET LIST");
//    NSLog(@"%lu", [_typeArr count]);
    return _typeArr;

}

- (double)getPriceOfFood:(NSString *)foodName{
    return arc4random() % 1000 / 100.0;
}

@end
