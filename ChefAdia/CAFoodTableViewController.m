//
//  CAFoodTableViewController.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/8.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAFoodTableViewController.h"
#import "CAFoodTableViewCell.h"
#import "CAFoodManager.h"
#import "CAFoodMenu.h"
#import "Utilities.h"
#import "CAFoodDetailTableViewController.h"

#import "Reachability.h"
#import "JSONKit.h"



@interface CAFoodTableViewController (){
    NSString *fontName;
    
    
    NSArray *books;
    NSArray *parseResult;
}

@end

@implementation CAFoodTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    fontName = [Utilities getFont];
    
    _backgroundView.image = [UIImage imageNamed:@"FOOD_TITLE"];
    _menuLabel.font = [UIFont fontWithName:fontName size:15];
    _name1Label.font = [UIFont fontWithName:[Utilities getBoldFont] size:40];
    _name2Label.font = [UIFont fontWithName:fontName size:20];
    _contactLabel.font = [UIFont fontWithName:fontName size:15];
    
    _name1Label.text = @"KRAYC'S";
    _name2Label.text = @"CHINESE FOOD";
    _contactLabel.text = @"XIANLIN AVENUE\n10:00 A.M. ~ 22:00 P.M.";
    
    _menuArr = [[CAFoodManager shareInstance] getListOfFoodType];
    
    
    
    
    books = [NSArray arrayWithObjects:
             [NSDictionary dictionaryWithObjectsAndKeys:@"A1", @"title", @"B1", @"author", nil],
             [NSDictionary dictionaryWithObjectsAndKeys:@"A2", @"title", @"B2", @"author", nil],
             [NSDictionary dictionaryWithObjectsAndKeys:@"A3", @"title", @"B3", @"author", nil], nil];
    
//    NSString *jsonpath = [[NSBundle mainBundle] pathForResource:@"books" ofType:@"json"];
//    NSData *data = [NSJSONSerialization dataWithJSONObject:books options:0 error:nil];
    
    
    
    
    NSString *str = @"http://120.27.117.222:8080/api/optionState";
    Reachability *reach = [Reachability reachabilityWithHostName:str];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            NSLog(@"NOT REACAABLE");
            break;
        case ReachableViaWiFi:
            NSLog(@"REACHABLE WIFI");
            break;
        case ReachableViaWWAN:
            NSLog(@"REACHABLE WAN");
            break;
        default:
            break;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = documentsDirectory;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:@"test"];
    // 创建目录
    BOOL res=[fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    if (res) {
        NSLog(@"文件夹创建成功");
    }else{
        NSLog(@"文件夹创建失败");
    }

    
    NSURL *url = [NSURL URLWithString:str];
//    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
//    NSURLSessionConfiguration *sessionConfig =[NSURLSessionConfiguration defaultSessionConfiguration];
//
//    NSURLSession *session =[NSURLSession sessionWithConfiguration:sessionConfig
//                                                         delegate:self
//                                                    delegateQueue:nil];
//    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *downTask = [session downloadTaskWithRequest:request
                                                        completionHandler:^(NSURL *location,
                                                                            NSURLResponse *response,
                                                                            NSError *error) {
        
        //文件下载会被先写入到一个 临时路径 location, 我们需要将下载的文件移动到我们需要地方保存
                                                            NSURL *savePath = [NSURL fileURLWithPath:[NSString stringWithFormat: @"%@/1.json",testDirectory]];
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:savePath error:nil];
    }];
    
    [downTask resume];
    
    
//    NSFileManager 
    // 字符串读取的方法
    
    NSString *testPath = [testDirectory stringByAppendingPathComponent:@"1.json"];
    NSLog(@"%@", testPath);
    //    NSData *data = [NSData dataWithContentsOfFile:testPath];
    //    NSLog(@"文件读取成功: %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//    NSString *content=[NSString stringWithContentsOfFile:testPath encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [NSData dataWithContentsOfFile:testPath];
    parseResult = [data objectFromJSONData];
    
    NSLog(@"%@", [parseResult description]);
    
    NSLog(@"%lu", (unsigned long)[parseResult count]);
    
//    NSDictionary *j = [parseResult objectAtIndex:0];
//    NSLog(@"%@",[j description]);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 1:
            return [_menuArr count];
        default:
            return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1){
        //注册 nib 的方法，来使用.xib 的cell
        static NSString *CellIdentifier = @"CAFoodTableViewCell";
        UINib *nib = [UINib nibWithNibName:@"CAFoodTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        CAFoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        //配置 cell 细节
        CAFoodMenu *item = _menuArr[indexPath.row];
        cell.nameLabel.text = [item name];
        cell.numberLabel.text = [NSString stringWithFormat:@"%d SELECTION%s", [item number], [item number] <= 1 ? "" : "S"];
        
        //tmp
        [cell.bgView setImage:[UIImage imageNamed:@"FOOD_TITLE"]];
//        [cell.bgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"FOOD_%@",item.name]]];
        
        return cell;
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        [self performSegueWithIdentifier:@"detailSegue" sender:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }else{
        return 250;
    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 10;
    }else{
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"detailSegue"]){
        CAFoodDetailTableViewController *caFoodDetailTableViewController = (CAFoodDetailTableViewController *)[segue destinationViewController];
        NSIndexPath *path = (NSIndexPath *)sender;
        CAFoodMenu *caFoodMenu = (CAFoodMenu *)_menuArr[path.row];
        [caFoodDetailTableViewController setFoodType:caFoodMenu.name];
    }
}

@end
