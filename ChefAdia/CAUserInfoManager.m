//
//  CAUserInfoManager.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/12.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAUserInfoManager.h"

@implementation CAUserInfoManager

static CAUserInfoManager* _instance = nil;

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance ;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [CAUserInfoManager shareInstance] ;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - Avatar

- (BOOL)saveAvatar:(UIImage *)avatarImg{
    NSString *imagePath = [self imageSavedPath:@"avatar.png"];
    BOOL isSaveSuccess = [self saveToDocument:avatarImg withFilePath:imagePath];
    return isSaveSuccess;
}

- (UIImage *)readAvatar{
    NSString *imagePath = [self imageSavedPath:@"avatar.png"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:imagePath]) {
        NSLog(@"图片不存在");
        return nil;
    }else {
        return [UIImage imageWithContentsOfFile:imagePath];
    }
}

-(BOOL)saveToDocument:(UIImage *) image withFilePath:(NSString *) filePath{
    if ((image == nil) || (filePath == nil) || [filePath isEqualToString:@""]) {
        return NO;
    }
    
    @try {
        NSData *imageData = nil;
        //获取文件扩展名
        NSString *extention = [filePath pathExtension];
        if ([extention isEqualToString:@"png"]) {
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
-(NSString *)imageSavedPath:(NSString *) imageName{
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

@end
