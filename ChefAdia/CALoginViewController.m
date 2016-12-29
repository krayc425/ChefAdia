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
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "MBProgressHUD.h"

#define LOGIN_URL @"http://47.89.194.197:8081/ChefAdia-1.0-SNAPSHOT/user/login"
#define INFO_URL @"http://47.89.194.197:8081/ChefAdia-1.0-SNAPSHOT/user/getInfo"

@interface CALoginViewController (){
    NSString *fontName;
    UIColor *color;
}

@end

@implementation CALoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    fontName = [Utilities getFont];
    color = [Utilities getColor];
    
    _backgroundView.image = [UIImage imageNamed:@"Background"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsCompact];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    _emailText.font = [UIFont fontWithName:fontName size:20];
    _passwordText.font = [UIFont fontWithName:fontName size:20];
    _emailText.delegate = self;
    _passwordText.delegate = self;
    _emailText.layer.cornerRadius = 20.0;
    _passwordText.layer.cornerRadius = 20.0;
    
    _loginButton.titleLabel.font = [UIFont fontWithName:fontName size:20];
    _loginButton.backgroundColor = [UIColor clearColor];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)loginAction:(id)sender{
    
    NSLog(@"LOG IN");
    
    //输入正确性检查
    if([_emailText.text isEqualToString:@""] || [_passwordText.text isEqualToString:@""]){
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Info imcomplete"
                                                                        message:@"Please fill all the info"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertC addAction:okAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }else{
    
        NSDictionary *tempDict = @{
                                   @"email" : _emailText.text,
                                   @"password" : _passwordText.text,
                                   };
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setMode:MBProgressHUDModeText];
        [hud.label setText: @"Login"];
        [hud setRemoveFromSuperViewOnHide:YES];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                             @"text/plain",
                                                             @"text/html",
                                                             nil];
        [manager POST:LOGIN_URL
          parameters:tempDict
             progress:^(NSProgress * _Nonnull uploadProgress) {
                 [hud setProgressObject:uploadProgress];
             }
             success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                 NSDictionary *resultDict = (NSDictionary *)responseObject;
                 if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                     
                     [hud hideAnimated:YES];
                     
                     NSDictionary *dict = (NSDictionary *)[resultDict objectForKey:@"data"];
                     
                     [[CALoginManager shareInstance] setUserID:[dict valueForKey:@"userid"]];
                     [[CALoginManager shareInstance] setUserName:[dict valueForKey:@"username"]];
                     [[CALoginManager shareInstance] setAvatarURL:[dict valueForKey:@"avatar"]];

                     //获取地址与手机号 并存储在本地
                     NSDictionary *tempDict = @{
                                                @"userid" : [dict valueForKey:@"userid"],
                                                };
                     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                                          @"text/plain",
                                                                          @"text/html",
                                                                          nil];
                     [manager GET:INFO_URL
                       parameters:tempDict
                         progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                              NSDictionary *resultDict = (NSDictionary *)responseObject;
                              if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                                  NSDictionary *dict = (NSDictionary *)[resultDict objectForKey:@"data"];
                                  [[CALoginManager shareInstance] setAddress:[dict valueForKey:@"addr"]];
                                  [[CALoginManager shareInstance] setPhone:[dict valueForKey:@"phone"]];
                                  
                                  [[CALoginManager shareInstance] setLoginState:LOGIN];
                                  
                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:nil];
                                  [self.navigationController popViewControllerAnimated:YES];
                                  
                              }else{
                                  NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"message"]);
                              }
                              
                          }
                          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              NSLog(@"%@",error);
                          }];
                 }else{
                     NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"message"]);
                     
                     UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Login Failed"
                                                                                     message:@"Wrong email and password combination"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
                     UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:nil];
                     [alertC addAction:okAction];
                     [self presentViewController:alertC animated:YES completion:nil];

                 }
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"%@",error);
             }];
    }
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    BOOL flag = NO;
    if(textField == _emailText){
        [_passwordText becomeFirstResponder];
    }else if(textField == _passwordText){
        [_passwordText resignFirstResponder];
        flag = YES;
    }
    return flag;
}

@end
