//
//  CANetworkManager.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/17.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CANetworkManager.h"
#import "Reachability.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "JSONKit.h"

@implementation CANetworkManager

static CANetworkManager* _instance = nil;

#pragma mark - CONSTRUCTORS

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance ;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [CANetworkManager shareInstance] ;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - NETWORK UTILITIES

- (void)checkNetwork{
    Reachability *reach = [Reachability reachabilityWithHostName:@"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/getMenu"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    [reach startNotifier];
}

- (void)reachabilityChanged:(NSNotification *)notification {
    Boolean isConnected;
    Reachability *reach = [notification object];
    
    if (![reach isReachable]) {
        NSLog(@"网络连接不可用");
        isConnected = NO;
    } else {
        if ([reach currentReachabilityStatus] == ReachableViaWiFi) {
            NSLog(@"正在使用WiFi");
            isConnected = YES;
        } else if ([reach currentReachabilityStatus] == ReachableViaWWAN) {
            NSLog(@"正在使用移动数据");
            isConnected = YES;
        }
    }
}

- (void)postToHost:(NSString *)URL withParams:(NSDictionary *)params{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"application/json",
                                                         @"text/html",
                                                         @"text/json",
                                                         nil];
    [manager POST:URL
       parameters:params
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
              NSLog(@"SUCCESS");
              NSLog(@"JSON POST: %@", responseObject);
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"FAILED");
              NSLog(@"Error: %@", error);
          }];
}

#pragma mark - METHODS

- (NSArray *)getMenu{
    __block NSMutableArray *array = [[NSMutableArray alloc] init];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager GET:@"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/getMenu"
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             for(NSDictionary *Dict in (NSArray *)responseObject){
                 [array addObject:Dict];
             }
             
             NSLog(@"IN BLOCK");
             NSLog(@"%lu", [array count]);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@",error);
         }];
    
    NSLog(@"OUT BLOCK");
    NSLog(@"%lu", [array count]);
    return [array copy];
}

- (void)postMenu{
    NSDictionary *parameters = @{
                                 @"name": @"NOODLE",
                                 @"type" : @"type2",
                                 @"price" : @"3.99",
                                 };
    [self postToHost:@"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/addDish.do"
            withParams:parameters];
}

- (void)getList:(int)menuid{
    __block NSArray *array;
    
    NSDictionary *param = @{
                            @"menuid" : [NSString stringWithFormat:@"%d", menuid],
                            };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager GET:@"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/getList"
      parameters:param
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                          NSLog(@"JSON GET CLASS: %@", [responseObject class]);
             //                          [self tranformTest:responseObject];
             array = (NSArray *)responseObject;
             for(NSDictionary *dict in array){
                 for(NSString *key in dict){
                     NSLog(@"KEY2 : %@ VALUE2 : %@", key, dict[key]);
                 }
             }
             
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@",error);
         }];

}

- (void)getTickInfo{
    
}

- (void)buyTicket{
    
}

- (void)addOrder{
    
}

- (void)getOrderList{

}

- (void)getOrder{
    
}

- (void)comment{
    
}

@end
