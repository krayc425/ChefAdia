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

#define TEST_URL @"http://47.89.194.197:8081/ChefAdia-1.0-SNAPSHOT/user/getMenu"

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
    Reachability *reach = [Reachability reachabilityWithHostName:TEST_URL];
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

@end
