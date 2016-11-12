//
//  CAUserInfoManager.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/12.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CAUserInfoManager : NSObject

+ (_Nonnull instancetype)shareInstance;

- (BOOL)saveAvatar:(UIImage *_Nonnull)avatarImg;
- (UIImage *_Nonnull)readAvatar;

@end
