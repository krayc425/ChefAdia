//
//  CAMeNotLoginViewController.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/6.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAMeNotLoginViewController : UIViewController

@property (nonnull, nonatomic) IBOutlet UIImageView *backgroundView;

@property (nonnull, nonatomic) IBOutlet UIImageView *logoView;
@property (nonnull, nonatomic) IBOutlet UILabel *mainLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *subLabel;

@property (nonnull, nonatomic) IBOutlet UIButton *loginButton;
@property (nonnull, nonatomic) IBOutlet UILabel *loginMainLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *loginSubLabel;

@property (nonnull, nonatomic) IBOutlet UIButton *signUpButton;
@property (nonnull, nonatomic) IBOutlet UILabel *signUpMainLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *signUpSubLabel;

@end
