//
//  CALoginManager.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/8.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum LoginState{
    LOGIN = 1,
    LOGOUT,
};

@interface CALoginManager : NSObject

+ (_Nonnull instancetype)shareInstance;

@property (nonatomic, nonnull) NSString *userID;
@property (nonatomic, nonnull) NSString *userName;
@property (nonatomic, nonnull) NSString *avatarURL;
@property (nonatomic, nonnull) NSString *address;
@property (nonatomic, nonnull) NSString *phone;

- (int)getLoginState;
- (void)setLoginState:(int)state;

- (BOOL)saveAvatar:(UIImage *_Nonnull)avatarImg;
- (UIImage *_Nonnull)readAvatar;

- (BOOL)checkInfo;

@end
