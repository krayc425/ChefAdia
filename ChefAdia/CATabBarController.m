//
//  CATabBarController.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/4.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CATabBarController.h"
#import "Utilities.h"
#import "CALoginManager.h"
#import "CANetworkManager.h"

@interface CATabBarController (){
    NSString *fontName;
    UIColor *color;
}

@end

@implementation CATabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     NSArray *fontFamilies = [UIFont familyNames];
     for (NSString *fontFamily in fontFamilies){
     NSArray *fontNames = [UIFont fontNamesForFamilyName:fontFamily];
     NSLog (@"%@: %@", fontFamily, fontNames);
     }
     */
    
    fontName = [Utilities getFont];
    color = [Utilities getColor];
    
    self.delegate = self;
    [self.naviItem setTitle:@"FOOD"];
    
//    UIBarButtonItem *R1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
//                                                                        target:self
//                                                                        action:nil];
//    self.naviItem.rightBarButtonItems = [NSArray arrayWithObjects:R1,nil];
    self.naviItem.rightBarButtonItems = nil;
    
    //注册观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshVCs) name:@"Login" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshVCs) name:@"Logout" object:nil];
    
    //未选中的字体
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, [UIFont fontWithName:fontName size:11.0f],NSFontAttributeName,nil] forState:UIControlStateNormal];
    //选中的字体
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:fontName size:11.0f],NSFontAttributeName,nil] forState:UIControlStateSelected];
    //更改导航栏字体
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIColor lightGrayColor], NSShadowAttributeName,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)], NSShadowAttributeName, fontName, NSFontAttributeName,nil]];
    
    //刷新 VC
    [self refreshVCs];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setToolbarHidden:YES];
    [self setColor];
}

- (void)login{
    [self refreshVCs];
}

- (void)logout{
    [self refreshVCs];
}

- (void)refreshVCs{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    self.caFoodTableViewController = (CAFoodTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CAFoodTableViewController"];
    [self.caFoodTableViewController loadMenu];
    
    self.caFindTableViewController = (CAFindTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CAFindTableViewController"];
    
    if([[CALoginManager shareInstance] getLoginState] == LOGIN){
        
        [[CALoginManager shareInstance] setUserID:[[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"]];
        [[CALoginManager shareInstance] setUserName:[[NSUserDefaults standardUserDefaults] valueForKey:@"user_name"]];
        
        self.caMeLoginTableViewController = (CAMeLoginTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CAMeLoginTableViewController"];
        
        self.viewControllers = [NSArray arrayWithObjects:
                                self.caFoodTableViewController,
                                self.caFindTableViewController,
                                self.caMeLoginTableViewController,
                                nil];
    }else{
        self.caMeNotLoginViewController = (CAMeNotLoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CAMeNotLoginViewController"];
        
        self.viewControllers = [NSArray arrayWithObjects:
                                self.caFoodTableViewController,
                                self.caFindTableViewController,
                                self.caMeNotLoginViewController,
                                nil];
    }
    
    //设置 tabBarItems
    [self.tabBarItem setImageInsets:UIEdgeInsetsMake(10, 0, -10, 0)];
    [[self.tabBar.items objectAtIndex:0] setTitle:@"FOOD"];
    [[self.tabBar.items objectAtIndex:0] setImage:[UIImage imageNamed:@"TAB_FOOD"]];
    [[self.tabBar.items objectAtIndex:1] setTitle:@"FIND"];
    [[self.tabBar.items objectAtIndex:1] setImage:[UIImage imageNamed:@"TAB_FIND"]];
    [[self.tabBar.items objectAtIndex:2] setTitle:@"ME"];
    [[self.tabBar.items objectAtIndex:2] setImage:[UIImage imageNamed:@"TAB_ME"]];
}

- (void)setColor{
    self.navigationController.navigationBar.barTintColor = color;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName : [UIColor whiteColor]
                                                                      }];
    self.tabBar.barTintColor = color;
    self.tabBar.tintColor = [UIColor whiteColor];
}

#pragma mark - UITabBarController Delegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    switch (self.selectedIndex) {
        case 0:
        {
            [self.naviItem setTitle:@"FOOD"];
//            UIBarButtonItem *R1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
//                                                                                target:self
//                                                                                action:nil];
            //            self.naviItem.rightBarButtonItems = [NSArray arrayWithObjects:R1,nil];
            self.naviItem.rightBarButtonItems = nil;
        }
            break;
        case 1:
        {
            [self.naviItem setTitle:@"FIND"];
            self.naviItem.rightBarButtonItems = nil;
        }
            break;
        case 2:
        {
            [self.naviItem setTitle:@"ME"];
            self.naviItem.rightBarButtonItems = nil;
        }
            break;
        default:
            break;
    }
}

@end
