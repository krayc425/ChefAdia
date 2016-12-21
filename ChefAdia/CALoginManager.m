//
//  CALoginManager.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/8.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CALoginManager.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "SDWebImageDownloader.h"
#import "CAFoodCart.h"

@implementation CALoginManager

static CALoginManager* _instance = nil;

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance ;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [CALoginManager shareInstance] ;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (int)getLoginState{
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"LoginState"];
}

- (void)setLoginState:(int)state{
    
    [[NSUserDefaults standardUserDefaults] setInteger:state forKey:@"LoginState"];
    
    if(state == LOGOUT){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:NULL forKey:@"user_id"];
        [userDefaults setValue:NULL forKey:@"user_name"];
        [userDefaults setValue:NULL forKey:@"user_addr"];
        [userDefaults setValue:NULL forKey:@"user_phone"];
        [userDefaults setValue:NULL forKey:@"user_avatar"];
        [userDefaults setValue:NULL forKey:@"easy_order_id"];
        //清空头像
        [self clearAvatar];
        //清空购物车
        [[CAFoodCart shareInstance] clearCart];
    }else if(state == LOGIN){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:_userID forKey:@"user_id"];
        [userDefaults setValue:_userName forKey:@"user_name"];
        [userDefaults setValue:_avatarURL forKey:@"user_avatar"];
        [userDefaults setValue:_address forKey:@"user_addr"];
        [userDefaults setValue:_phone forKey:@"user_phone"];
    }
}

- (BOOL)checkInfo{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"user_addr"]
       && [[NSUserDefaults standardUserDefaults] objectForKey:@"user_phone"]){
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - Avatar

- (BOOL)saveAvatar:(UIImage *)avatarImg{
    NSString *imagePath = [self imageSavedPath:@"avatar.jpeg"];
    
    BOOL isSaveSuccess = [self saveToDocument:avatarImg withFilePath:imagePath];
    return isSaveSuccess;
}

- (UIImage *)readAvatar{
    NSString *imagePath = [self imageSavedPath:@"avatar.jpeg"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:imagePath]) {
        NSLog(@"图片不存在");
        return NULL;
    }else {
        return [UIImage imageWithContentsOfFile:imagePath];
    }
}

- (void)clearAvatar{
    NSString *imagePath = [self imageSavedPath:@"avatar.jpeg"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:imagePath error:nil];
}

- (BOOL)saveToDocument:(UIImage *) image withFilePath:(NSString *) filePath{
    if ((image == nil) || (filePath == nil) || [filePath isEqualToString:@""]) {
        return NO;
    }
    
    @try {
        NSData *imageData = nil;
        //获取文件扩展名
        NSString *extention = [filePath pathExtension];
        if ([extention isEqualToString:@"jpeg"]) {
            //返回PNG格式的图片数据
            imageData = UIImagePNGRepresentation(image);
        }else{
            //返回JPG格式的图片数据，第二个参数为压缩质量：0:best 1:lost
            imageData = UIImageJPEGRepresentation(image, 0);
        }
        if (imageData == nil || [imageData length] <= 0) {
            return NO;
        }
        //将图片写入指定路径
        [imageData writeToFile:filePath atomically:YES];
        return  YES;
    }
    @catch (NSException *exception) {
        NSLog(@"保存图片失败");
    }
    return NO;
}

//根据图片名将图片保存到ImageFile文件夹中
- (NSString *)imageSavedPath:(NSString *) imageName{
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //获取文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //指定新建文件夹路径
    NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"ImageFile"];
    //创建ImageFile文件夹
    [fileManager createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    //返回保存图片的路径（图片保存在ImageFile文件夹下）
    NSString * imagePath = [imageDocPath stringByAppendingPathComponent:imageName];
    return imagePath;
}

//压缩图片
- (UIImage*)OriginImage:(UIImage *)image scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);  //你所需要的图片尺寸
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;   //返回已变图片
}

@end
