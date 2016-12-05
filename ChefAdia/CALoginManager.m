//
//  CALoginManager.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/8.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CALoginManager.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"

@implementation CALoginManager

static CALoginManager* _instance = nil;

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance ;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [CALoginManager shareInstance] ;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (int)getLoginState{
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"LoginState"];
}

- (void)setLoginState:(int)state{
    
    [[NSUserDefaults standardUserDefaults] setInteger:state forKey:@"LoginState"];
    
    if(state == LOGOUT){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:@"" forKey:@"user_id"];
        [userDefaults setValue:@"" forKey:@"user_name"];
        [userDefaults setValue:@"" forKey:@"user_addr"];
        [userDefaults setValue:@"" forKey:@"user_phone"];
        [userDefaults setValue:@"" forKey:@"user_avatar"];
    }else if(state == LOGIN){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:_userID forKey:@"user_id"];
        [userDefaults setValue:_userName forKey:@"user_name"];
        [userDefaults setValue:_avatarURL forKey:@"user_avatar"];
        
        NSLog(@"AVATAR URL : %@", _avatarURL);
        
        //获取地址与手机号 并存储在本地
        NSDictionary *tempDict = @{
                                   @"userid" : _userID,
                                   };
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                             @"text/plain",
                                                             @"text/html",
                                                             nil];
        [manager GET:@"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/getInfo"
          parameters:tempDict
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                 NSDictionary *resultDict = (NSDictionary *)responseObject;
                 if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                     NSDictionary *dict = (NSDictionary *)[resultDict objectForKey:@"data"];
                     
                     [userDefaults setValue:[dict valueForKey:@"addr"] forKey:@"user_addr"];
                     [userDefaults setValue:[dict valueForKey:@"phone"] forKey:@"user_phone"];
                 
                 }else{
                     NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"msg"]);
                 }
                 
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"%@",error);
             }];

    }
}

@end
