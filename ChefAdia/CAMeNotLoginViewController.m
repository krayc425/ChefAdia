//
//  CAMeNotLoginViewController.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/6.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAMeNotLoginViewController.h"
#import "Utilities.h"

@interface CAMeNotLoginViewController (){
    NSString *fontName;
    UIColor *color;
}

@end

@implementation CAMeNotLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    fontName = [Utilities getFont];
    color = [Utilities getColor];
    
    _backgroundView.image = [UIImage imageNamed:@"Background"];
    
    _logoView.image = [UIImage imageNamed:@"Logo"];
    _mainLabel.font = [UIFont fontWithName:[Utilities getBoldFont] size:20];
    _subLabel.font = [UIFont fontWithName:fontName size:15];
    
    _loginButton.backgroundColor = [UIColor clearColor];
    [_loginMainLabel setFont:[UIFont fontWithName:fontName size:20]];
    [_loginMainLabel setTextColor:color];
    [_loginSubLabel setFont:[UIFont fontWithName:fontName size:15]];
    [_loginSubLabel setTextColor:color];
    
    _signUpButton.backgroundColor = [UIColor clearColor];
    [_signUpMainLabel setFont:[UIFont fontWithName:fontName size:20]];
    [_signUpMainLabel setTextColor:color];
    [_signUpSubLabel setFont:[UIFont fontWithName:fontName size:15]];
    [_signUpSubLabel setTextColor:color];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
