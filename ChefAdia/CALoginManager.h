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

+ (_Nonnull instancetype)shareInstance;

@property (nonatomic, nonnull) NSString *userID;
@property (nonatomic, nonnull) NSString *userName;
@property (nonatomic, nonnull) NSString *avatarURL;

- (int)getLoginState;

- (void)setLoginState:(int)state;

@end
