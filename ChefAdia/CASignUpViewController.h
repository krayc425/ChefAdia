//
//  CASignUpViewController.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/5.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CASignUpViewController : UIViewController <UITextFieldDelegate>

@property (nonnull, nonatomic) IBOutlet UINavigationItem *naviItem;

@property (nonatomic, nonnull) IBOutlet UIImageView *backgroundView;

@property (nonatomic, nonnull) IBOutlet UITextField *emailText;
@property (nonatomic, nonnull) IBOutlet UITextField *userNameText;
@property (nonatomic, nonnull) IBOutlet UITextField *passwordText;

@property (nonatomic, nonnull) IBOutlet UIButton *signUpButton;

@end
