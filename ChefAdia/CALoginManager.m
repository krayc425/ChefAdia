//
//  CALoginManager.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/8.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CALoginManager.h"

@implementation CALoginManager

+ (int)getLoginState{
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"LoginState"];
}

+ (void)setLoginState:(int)state{
    [[NSUserDefaults standardUserDefaults] setInteger:state forKey:@"LoginState"];
    if(state == LOGOUT){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:@"" forKey:@"user_name"];
        [userDefaults setValue:@"" forKey:@"user_destination"];
        [userDefaults setValue:@"" forKey:@"user_phone"];
    }
}

//检查是否登陆成功，若登陆成功再设置各种属性
+ (Boolean)loginWithUsername:(NSString *)userName andPassword:(NSString *)password{
    //成功做的事
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:userName forKey:@"user_name"];
    [userDefaults setValue:@"NJU XIANLIN CAMPUS 3A344" forKey:@"user_destination"];
    [userDefaults setValue:@"18795963603" forKey:@"user_phone"];
    [CALoginManager setLoginState:LOGIN];
    return true;
}

@end
