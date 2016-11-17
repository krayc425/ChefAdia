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

- (void)checkNetwork{
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    [reach startNotifier];
    
    
    [self test];
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

- (void)test{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:@"http://120.27.117.222:8080/api/optionState" parameters:nil
        progress:^(NSProgress * _Nonnull downloadProgress) {
        
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             NSLog(@"JSON: %@", responseObject);
             [self tranformTest:responseObject];
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
}

- (void)tranformTest:(id)jsonObject{
    
    //JSONKit
    
    NSString *strJson = (NSString *)[jsonObject description];
    
    NSLog(@"TRANFORM");
    NSLog(@"%@", strJson);
    
    NSArray *arrlist = [strJson objectFromJSONString];
    NSLog(@"%lu",(unsigned long)[arrlist count]);
    for (int i=0; i<[arrlist count]; i++) {
        NSDictionary *item=[arrlist objectAtIndex:i];
        NSString *BrandName=[item objectForKey:@"condition"];
        NSLog(@"%@",BrandName);
    }
    
    //NSJSONSerialization
    
    NSString *urlStr = @"http://120.27.117.222:8080/api/optionState";
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
        NSLog(@"解析失败--%@", error);
        return;
    }
    NSLog(@"-json: %@",json);
    
    NSArray *array = [json objectForKey:@"condition"];
    NSLog(@"--song 1: %@",array);
    array = [json objectForKey:@"msg"];
    NSLog(@"--song 2: %@",array);
    array = [json objectForKey:@"data"];
    NSLog(@"--song 3: %@",array);
    
    NSLog(@"%lu", (unsigned long)[array count]);
    NSDictionary *jsonDict = [array objectAtIndex:0];
    NSLog(@"-----song jsonDict: %@",jsonDict);
    jsonDict = [array objectAtIndex:1];
    NSLog(@"-----song jsonDict: %@",jsonDict);
    jsonDict = [array objectAtIndex:2];
    NSLog(@"-----song jsonDict: %@",jsonDict);
    jsonDict = [array objectAtIndex:3];
    NSLog(@"-----song jsonDict: %@",jsonDict);
}

@end
