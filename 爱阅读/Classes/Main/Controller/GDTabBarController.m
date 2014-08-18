//
//  GDTabBarController.m
//  经典
//
//  Created by 彭根勇 on 14-8-7.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GDTabBarController.h"
#import "GDHomeViewController.h"
#import "GDSettingViewController.h"
#import "GDNavigationController.h"
#import "GDLibraryViewController.h"

@interface GDTabBarController ()

@end

@implementation GDTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置子控制器
    [self addChildVcs];
}

- (void)addChildVcs
{
    // 添加首页控制器
    GDHomeViewController *homeVc = [[GDHomeViewController alloc] init];
    [self addChildVc:homeVc title:@"书架" imageName:@"tabbar_book_shelf" selectedImageName:@"tabbar_book_shelf_hl"];
    
    // 添加书签控制器
    GDLibraryViewController *markVc = [[GDLibraryViewController alloc] init];
    [self addChildVc:markVc title:@"书城" imageName:@"tabbar_book_library" selectedImageName:@"tabbar_book_library_hl"];
    
    // 添加设置控制器
    GDSettingViewController *settingVc = [[GDSettingViewController alloc] init];
    [self addChildVc:settingVc title:@"设置" imageName:@"tabbar_pandora_box" selectedImageName:@"tabbar_pandora_box_hl"];
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    childVc.title = title;
    
    // 设置tabBar的图片
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    UIImage *sel = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = sel;
    
    // 设置tabBar的文字
    [childVc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10], NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10], NSForegroundColorAttributeName:[UIColor orangeColor]} forState:UIControlStateSelected];
    
    GDNavigationController *nav = [[GDNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

@end
