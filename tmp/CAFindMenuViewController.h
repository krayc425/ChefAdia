//
//  CAFindMenuViewController.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/13.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAFindMenuViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (nonnull, nonatomic) IBOutlet UIImageView *backgroundView;
@property (nonnull, nonatomic) IBOutlet UILabel *main1Label;
@property (nonnull, nonatomic) IBOutlet UILabel *main2Label;

@property (nonnull, nonatomic) IBOutlet UILabel *newdishLabel;
@property (nonnull, nonatomic) IBOutlet UITextField *titleTextField;
@property (nonnull, nonatomic) IBOutlet UITextView *detailTextView;
@property (nonnull, nonatomic) IBOutlet UIButton *submitButton;

@end
