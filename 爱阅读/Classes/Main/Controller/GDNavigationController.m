//
//  GDNavigationController.m
//  经典
//
//  Created by 彭根勇 on 14-8-8.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GDNavigationController.h"

@interface GDNavigationController ()

@end

@implementation GDNavigationController

+(void)initialize
{
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundImage:[UIImage resizedImage:@"bc_navi_bar"] forBarMetrics:UIBarMetricsDefault];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:YES];
}

@end
