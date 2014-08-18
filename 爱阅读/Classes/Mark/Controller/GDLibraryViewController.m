//
//  GDMarkViewController.m
//  经典
//
//  Created by 彭根勇 on 14-8-8.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GDLibraryViewController.h"
#import "GDLibraryNavigationBar.h"

@interface GDLibraryViewController ()

@end

@implementation GDLibraryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    UIImageView *backgroundView = [[UIImageView alloc] init];
    backgroundView.frame = self.view.bounds;
    backgroundView.image = [UIImage resizedImage:@"main_view_bkg"];
    [self.view addSubview:backgroundView];
    
    // 设置顶部工具条
    [self setupNavBar];
}

- (void)setupNavBar
{
    GDLibraryNavigationBar *navBar = [GDLibraryNavigationBar navigationBar];
    [self.view addSubview:navBar];
}

@end
