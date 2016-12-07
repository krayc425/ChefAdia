//
//  CAMeLoginTableViewController.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/5.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAMeLoginTableViewController.h"
#import "Utilities.h"
#import "CALoginManager.h"
#import <AVFoundation/AVFoundation.h>
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"

#define AVATAR_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/user/modAva"

@interface CAMeLoginTableViewController (){
    NSString *fontName;
    UIColor *color;
}

@end

@implementation CAMeLoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    fontName = [Utilities getFont];
    color = [Utilities getColor];
    
    _userNameLabel.font = [UIFont fontWithName:[Utilities getBoldFont] size:20];
    _addressLabel.font = [UIFont fontWithName:fontName size:15];
    
    _historyView.image = [UIImage imageNamed:@"HISTORY_ICON"];
    _settingsView.image = [UIImage imageNamed:@"SETTINGS_ICON"];
    
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;//裁成圆角
    _avatarView.layer.masksToBounds = YES;//隐藏裁剪掉的部分
    UITapGestureRecognizer *avatarGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modifyAvatar)];
    avatarGesture.numberOfTapsRequired = 1;
    [_avatarView addGestureRecognizer:avatarGesture];
    
    _historyLabel.font = [UIFont fontWithName:fontName size:15];
    _settingsLabel.font = [UIFont fontWithName:fontName size:15];
    
    _logoutButton.titleLabel.font = [UIFont fontWithName:fontName size:15];
    [_logoutButton setTitleColor:color forState:UIControlStateNormal];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLabel) name:@"Login" object:nil];
    
//    [self refreshLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [self refreshLabel];
}

- (void)refreshLabel{
    _userNameLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_name"];
    _addressLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_addr"];
    _avatarView.image = [[CALoginManager shareInstance] readAvatar];
    [self.tableView reloadData];
}

- (IBAction)logoutAction:(id)sender{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Sure to logout?"
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action){
                                                         
                                                         NSLog(@"LOG OUT");
                                                         [[CALoginManager shareInstance] setLoginState:LOGOUT];
                                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"Logout" object:nil];
                                                         
                                                     }];
    [alertC addAction:cancelAction];
    [alertC addAction:okAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)modifyAvatar{
    // 创建UIImagePickerController实例
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    // 设置代理
    imagePickerController.delegate = self;
    // 是否允许编辑（默认为NO）
    imagePickerController.allowsEditing = YES;
    // 创建一个警告控制器
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Pick a Photo" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // 设置警告响应事件
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                            // 设置照片来源为相机
                                                            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                            // 设置进入相机时使用前置或后置摄像头
                                                            imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                                                            // 展示选取照片控制器
                                                            [self presentViewController:imagePickerController animated:YES completion:nil];
    }];
    
    UIAlertAction *photosAction = [UIAlertAction actionWithTitle:@"Choose from Photo Library"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                            [self presentViewController:imagePickerController animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [alert addAction:cameraAction];
    }
    
    [alert addAction:photosAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 2;
        default:
            return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && indexPath.row == 0){
        [self modifyAvatar];
    }
}

#pragma mark - UIImagePickerControllerDelegate
// 完成图片的选取后调用的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    // 选取完图片后跳转回原控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    /* 此处参数 info 是一个字典，下面是字典中的键值 （从相机获取的图片和相册获取的图片时，两者的info值不尽相同）
     * UIImagePickerControllerMediaType; // 媒体类型
     * UIImagePickerControllerOriginalImage;  // 原始图片
     * UIImagePickerControllerEditedImage;    // 裁剪后图片
     * UIImagePickerControllerCropRect;       // 图片裁剪区域（CGRect）
     * UIImagePickerControllerMediaURL;       // 媒体的URL
     * UIImagePickerControllerReferenceURL    // 原件的URL
     * UIImagePickerControllerMediaMetadata    // 当数据来源是相机时，此值才有效
     */
    
    // 从info中将图片取出
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    //上传到服务器
    NSString *url = AVATAR_URL;
    NSDictionary *dict = @{
                           @"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],
                           @"avatar" : @"avatar.jpeg",
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         @"text/json",
                                                         @"application/json",
                                                         nil];

    
    [manager POST:url
       parameters:dict
     
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"avatar.jpeg" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"SUCCESS");
        //存到本地
        if([[CALoginManager shareInstance] saveAvatar:image]){
            
            //刷新头像
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Upload Successfully!"
                                                                                                                                 message:nil
                                                                                                                          preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertC addAction:okAction];
            [self presentViewController:alertC animated:YES completion:^(){
                [self refreshLabel];
            }];
            
            
        }else{
            NSLog(@"保存头像失败");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"FAILED");
        NSLog(@"%@", [error description]);
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Upload Failed!"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertC addAction:okAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }];
    
    
    // 创建保存图像时需要传入的选择器对象（回调方法格式固定）
//    SEL selectorToCall = @selector(image:didFinishSavingWithError:contextInfo:);
    // 将图像保存到相册（第三个参数需要传入上面格式的选择器对象）
//    UIImageWriteToSavedPhotosAlbum(image, self, selectorToCall, NULL);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 保存图片后到相册后，回调的相关方法，查看是否保存成功
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil){
        NSLog(@"Image was saved successfully.");
    } else {
        NSLog(@"An error happened while saving the image.");
        NSLog(@"Error = %@", error);
    }
}

@end
