//
//  CALoginViewController.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/5.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CALoginViewController.h"
#import "Utilities.h"
#import <QuartzCore/QuartzCore.h>
#import "CALoginManager.h"

@interface CALoginViewController (){
    NSString *fontName;
    UIColor *color;
}

@end

@implementation CALoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.naviItem setTitle:@"LOGIN"];
    
    fontName = [Utilities getFont];
    color = [Utilities getColor];
    
    _backgroundView.image = [UIImage imageNamed:@"Background"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsCompact];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    _userNameText.font = [UIFont fontWithName:fontName size:20];
    _passwordText.font = [UIFont fontWithName:fontName size:20];
    _userNameText.delegate = self;
    _passwordText.delegate = self;
    _userNameText.layer.cornerRadius = 20.0;
    _passwordText.layer.cornerRadius = 20.0;
    
    _loginButton.titleLabel.font = [UIFont fontWithName:fontName size:20];
    _loginButton.backgroundColor = [UIColor clearColor];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)loginAction:(id)sender{
    
    NSLog(@"LOG IN");
    
    //输入正确性检查
    if([_userNameText.text isEqualToString:@""] || [_passwordText.text isEqualToString:@""]){
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Info imcompleted!"
                                                                        message:@"Please fill all the info"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertC addAction:okAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }else{
    
        if([CALoginManager loginWithUsername:[_userNameText text] andPassword:[_passwordText text]]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            NSLog(@"WRONG UserName AND Password");
            
        }
        
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    BOOL flag = NO;
    if(textField == _userNameText){
        [_passwordText becomeFirstResponder];
    }else if(textField == _passwordText){
        [_passwordText resignFirstResponder];
        flag = YES;
    }
    return flag;
}

@end
