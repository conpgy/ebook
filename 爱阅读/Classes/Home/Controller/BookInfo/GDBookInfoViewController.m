//
//  GDBookInfoViewController.m
//  爱阅读
//
//  Created by 彭根勇 on 14-8-15.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GDBookInfoViewController.h"
#import <Social/Social.h>
#import "MBProgressHUD+NJ.h"

@interface GDBookInfoViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) UITableView *chapterView;

@property (nonatomic, weak) UITableView *markView;

@property (nonatomic, weak) UITableView *noteView;

@property (nonatomic, weak) UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *headerView;

@end

@implementation GDBookInfoViewController

-(UITableView *)tableView
{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] init];
        self.tableView = tableView;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = GDGlobalBgColor;
        
        // 设置frame
        tableView.y = CGRectGetMaxY(self.headerView.frame);
        tableView.width = GDScreenW;
        tableView.height = GDScreenH - tableView.y;
    }
    
    return _tableView;
}

- (IBAction)continueReading
{
    // 动画
    CATransition *ca = [[CATransition alloc] init];
    ca.type = @"oglFlip";
    ca.subtype = @"fromRight";
    ca.duration = 0.5;
    [self.navigationController.view.layer addAnimation:ca forKey:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)share
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"分享至新浪微博", @"分享至腾讯微博", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self shareTheBook:buttonIndex];
}


- (void)shareTheBook: (NSInteger)buttonIndex;
{
    // 创建分享控制器
    SLComposeViewController *cvv;
    
    if (buttonIndex == 1) {
        if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) return;
        cvv = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
    } else if(buttonIndex == 2) {
        if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTencentWeibo]) return;
        cvv = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTencentWeibo];
    } else {
        return;
    }
    
    // 设置初始化器
    [cvv setInitialText:@"##爱阅读好书分享##看到一本好书，与大家一起分享。http://conpgy.github.com"];
    [cvv addImage:[UIImage imageNamed:@"share"]];
    
    // 显示控制器
    [self presentViewController:cvv animated:YES completion:nil];
    
    // 监听
    cvv.completionHandler = ^(SLComposeViewControllerResult result) {
        if (result == SLComposeViewControllerResultCancelled) {
            GDLog(@"取消分享");
        } else {
            [MBProgressHUD showSuccess:@"分享成功"];
        }
    };
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%lu", indexPath.row];
    
    return cell;
}


#pragma mark - UITableViewDelegate

@end
