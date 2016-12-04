//
//  CAMeLoginTableViewController.h
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/5.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAMeLoginTableViewController : UITableViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonnull, nonatomic) UIImagePickerController* picker_library_;

@property (nonnull, nonatomic) IBOutlet UIImageView *avatarView;
@property (nonnull, nonatomic) IBOutlet UILabel *userNameLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *addressLabel;

@property (nonnull, nonatomic) IBOutlet UIImageView *historyView;
@property (nonnull, nonatomic) IBOutlet UIImageView *settingsView;
@property (nonnull, nonatomic) IBOutlet UILabel *historyLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *settingsLabel;

@property (nonnull, nonatomic) IBOutlet UIButton *logoutButton;

@end
