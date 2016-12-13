//
//  CAFindMenuViewController.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/13.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAFindMenuViewController.h"
#import "Utilities.h"

@interface CAFindMenuViewController (){
    NSString *fontName;
    UIColor *color;
}

@end

@implementation CAFindMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    fontName = [Utilities getFont];
    color = [Utilities getColor];
    
    _titleTextField.delegate = self;
    _detailTextView.delegate = self;
    
    _backgroundView.image = [UIImage imageNamed:@"FIND_TITLE"];
    _main1Label.font = [UIFont fontWithName:[Utilities getBoldFont] size:40];
    _main2Label.font = [UIFont fontWithName:fontName size:20];
    _newdishLabel.font = [UIFont fontWithName:fontName size:20];
    _titleTextField.font = [UIFont fontWithName:fontName size:15];
    _detailTextView.font = [UIFont fontWithName:fontName size:15];
    
    _main1Label.text = @"ANYTHING";
    _main2Label.text = @"YOU'D LIKE TO ADD TO THE MENU";
    _newdishLabel.text = @"ADD A NEW DISH";
    _titleTextField.placeholder = @"NAME";
    _detailTextView.text = @"DETAILS...";
    
    [_newdishLabel setTextColor:color];
//    _titleTextField.layer.cornerRadius = 10.0;
    _detailTextView.layer.cornerRadius = 5.0;
    _detailTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _detailTextView.layer.borderWidth = 0.5;
    _detailTextView.layoutManager.allowsNonContiguousLayout = NO;
    [_detailTextView scrollRangeToVisible:NSMakeRange(_detailTextView.text.length - 1, 1)];
    
    UITapGestureRecognizer *uploadImgGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadImg)];
    uploadImgGesture.numberOfTapsRequired = 1;
    [_backgroundView addGestureRecognizer:uploadImgGesture];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)submitAction:(id)sender{
    NSLog(@"SUBMIT NEW DISH");
}

- (void)uploadImg{
    
}

- (void)hideKeyboard{
    [_detailTextView resignFirstResponder];
    [_titleTextField resignFirstResponder];
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

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移70个单位
    CGRect rect=CGRectMake(0.0f,-140,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    [self resumeView];
    return YES;
}

@end
