//
//  CAFindTicketViewController.m
//  ChefAdia
//
//  Created by 宋 奎熹 on 2016/11/13.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "CAFindTicketViewController.h"
#import "Utilities.h"

@interface CAFindTicketViewController (){
    NSString *fontName;
}

@end

@implementation CAFindTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    fontName = [Utilities getFont];
    
    //暂时用这张
    _backgroundView.image = [UIImage imageNamed:@"Background"];
    _visaButton.titleLabel.font = [UIFont fontWithName:fontName size:15];
    _moreButton.titleLabel.font = [UIFont fontWithName:fontName size:15];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
