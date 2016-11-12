//
//  CASignUpViewController.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/5.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CASignUpViewController.h"
#import "Utilities.h"
#import <QuartzCore/QuartzCore.h>

@interface CASignUpViewController (){
    NSString *fontName;
    UIColor *color;
}

@end

@implementation CASignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.naviItem setTitle:@"SIGN UP"];
    
    fontName = [Utilities getFont];
    color = [Utilities getColor];
    
    _backgroundView.image = [UIImage imageNamed:@"Background"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsCompact];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    _userNameText.font = [UIFont fontWithName:fontName size:20];
    _passwordText.font = [UIFont fontWithName:fontName size:20];
    _phoneNumText.font = [UIFont fontWithName:fontName size:20];
    _userNameText.delegate = self;
    _passwordText.delegate = self;
    _phoneNumText.delegate = self;
    _userNameText.layer.cornerRadius = 20.0;
    _passwordText.layer.cornerRadius = 20.0;
    _phoneNumText.layer.cornerRadius = 20.0;
    
    _signUpButton.titleLabel.font = [UIFont fontWithName:fontName size:20];
    _signUpButton.backgroundColor = [UIColor clearColor];
    [_signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)signUpAction:(id)sender{
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    BOOL flag = NO;
    if(textField == _userNameText){
        [_passwordText becomeFirstResponder];
    }else if(textField == _passwordText){
        [_phoneNumText becomeFirstResponder];
    }else if(textField == _phoneNumText){
        [_phoneNumText resignFirstResponder];
        flag = YES;
    }
    return flag;
}

@end
