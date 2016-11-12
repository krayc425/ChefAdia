//
//  CALoginManager.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/8.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>

enum LoginState{
    LOGIN = 1,
    LOGOUT,
};

@interface CALoginManager : NSObject

+ (int)getLoginState;

+ (void)setLoginState:(int)state;

+ (Boolean)loginWithUsername:(NSString *)userName andPassword:(NSString *)password;

@end
