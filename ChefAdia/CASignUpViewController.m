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
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "CALoginManager.h"
#import "MBProgressHUD.h"

#define SIGNUP_URL @"http://47.89.194.197:8081/ChefAdia-1.0-SNAPSHOT/user/register"

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
    
    _emailText.font = [UIFont fontWithName:fontName size:20];
    _userNameText.font = [UIFont fontWithName:fontName size:20];
    _passwordText.font = [UIFont fontWithName:fontName size:20];
    
    _emailText.delegate = self;
    _userNameText.delegate = self;
    _passwordText.delegate = self;
    
    _emailText.layer.cornerRadius = 20.0;
    _userNameText.layer.cornerRadius = 20.0;
    _passwordText.layer.cornerRadius = 20.0;
    
    
    _signUpButton.titleLabel.font = [UIFont fontWithName:fontName size:20];
    _signUpButton.backgroundColor = [UIColor clearColor];
    [_signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)signUpAction:(id)sender{
    NSLog(@"SIGN UP");
    
    //输入正确性检查
    if([_emailText.text isEqualToString:@""] || [_passwordText.text isEqualToString:@""]
       || [_userNameText.text isEqualToString:@""]){
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
                                   @"username" : _userNameText.text,
                                   @"password" : _passwordText.text,
                                   };
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setMode:MBProgressHUDModeText];
        [hud.label setText: @"Sign up"];
        [hud setRemoveFromSuperViewOnHide:YES];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                             @"text/plain",
                                                             @"text/html",
                                                             nil];
        [manager POST:SIGNUP_URL
           parameters:tempDict
             progress:^(NSProgress * _Nonnull uploadProgress) {
                 [hud setProgressObject:uploadProgress];
             }
              success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                  NSLog(@"SUCCESS");
                  NSDictionary *resultDict = (NSDictionary *)responseObject;
                  
                  if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                      
                      [hud hideAnimated:YES];
                      
                      NSDictionary *dict = (NSDictionary *)[resultDict objectForKey:@"data"];
                      
                      [[CALoginManager shareInstance] setUserID:[dict valueForKey:@"userid"]];
                      [[CALoginManager shareInstance] setUserName:[dict valueForKey:@"username"]];
                      [[CALoginManager shareInstance] setAvatarURL:[dict valueForKey:@"avatar"]];
                      [[CALoginManager shareInstance] setLoginState:LOGIN];
                      
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:nil];
                      [self.navigationController popViewControllerAnimated:YES];
                  }else{
                      NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"code"]);
                      
                      UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Sign up failed"
                                                                                      message:@"Email existed"
                                                                               preferredStyle:UIAlertControllerStyleAlert];
                      UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                         style:UIAlertActionStyleDefault
                                                                       handler:nil];
                      [alertC addAction:okAction];
                      [self presentViewController:alertC animated:YES completion:nil];
                  }

              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  NSLog(@"FAILED");
                  NSLog(@"Error: %@", error);
              }];
        
    }

}

- (void)hideKeyboard{
    [_emailText resignFirstResponder];
    [_userNameText resignFirstResponder];
    [_passwordText resignFirstResponder];
    
    [self resumeView];
}

- (void)resumeView{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度
    float Y = 44.0f + 20.0f;
    CGRect rect=CGRectMake(0.0f,Y,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    BOOL flag = NO;
    if(textField == _emailText){
        [_userNameText becomeFirstResponder];
    }else if(textField == _userNameText){
        [_passwordText becomeFirstResponder];
    }else if(textField == _passwordText){
        [_passwordText resignFirstResponder];
        flag = YES;
    }
    return flag;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移70个单位
    CGRect rect=CGRectMake(0.0f,-70,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
    [self resumeView];
}

@end
