//
//  GDHomeViewController.m
//  经典
//
//  Created by 彭根勇 on 14-8-7.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GDHomeViewController.h"
#import "GDReadingViewController.h"
#import "GDBook.h"
#import "GDBookListCell.h"
#import "GDBookTableViewCell.h"
#import "GDCollectionHeaderView.h"
#import "GDBookTool.h"

#define GDBookCollectionCellID @"bookListCell"
#define GDCollectionHeaderViewID @"collectionHeaderView"

@interface GDHomeViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, GDCollectionHeaderViewDelegate>

/** 书单 */
@property (nonatomic, strong) NSArray *books;

/** 顶部工具条 */
@property (nonatomic, weak) UIView *toolbar;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GDHomeViewController

#pragma mark - 初始化

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        //  创建一个布局对象
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //  设置每个cell的宽高
        layout.itemSize = CGSizeMake(90, 130);
        // 设置item之间的间隙
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        [layout setHeaderReferenceSize:CGSizeMake(320, 30)];
        
        CGFloat y = CGRectGetMaxY(self.toolbar.frame);
        CGFloat width = GDScreenW;
        CGFloat height = self.view.height - y - 49;
        CGRect frame = CGRectMake(0, y, width, height);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
    }
    
    return _collectionView;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        
        
        // 设置frame
        _tableView.y = CGRectGetMaxY(self.toolbar.frame);
        _tableView.width = GDScreenW;
        _tableView.height = self.view.height - _tableView.y - 49;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // 设置headerView
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor clearColor];
        headerView.height = 30;
        _tableView.tableHeaderView = headerView;
        
        UIButton *listButton = [[UIButton alloc] init];
        [listButton setImage:[UIImage imageNamed:@"list_mode_normal"] forState:UIControlStateNormal];
        [listButton setImage:[UIImage imageNamed:@"list_mode_selected"] forState:UIControlStateSelected];
        listButton.size = listButton.currentImage.size;
        listButton.x = GDScreenW - 20 - listButton.size.width;
        listButton.y = 2;
        listButton.selected = YES;
        listButton.enabled = NO;
        listButton.adjustsImageWhenDisabled = NO;
        
        UIButton *gridButton = [[UIButton alloc] init];
        [gridButton setImage:[UIImage imageNamed:@"grid_mode_normal"] forState:UIControlStateNormal];
        [gridButton setImage:[UIImage imageNamed:@"grid_mode_selected"] forState:UIControlStateSelected];
        gridButton.size = gridButton.currentImage.size;
        gridButton.x = listButton.x - gridButton.width;
        gridButton.y = listButton.y;
        [gridButton addTarget:self action:@selector(gridButtonDidSelected) forControlEvents:UIControlEventTouchDown];
        
        [headerView addSubview:listButton];
        [headerView addSubview:gridButton];
    }
    
    return _tableView;
}

-(NSArray *)books
{
    if (!_books) {
        _books = [GDBookTool books];
    }
    
    return _books;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *backgroundView = [[UIImageView alloc] init];
    backgroundView.frame = self.view.bounds;
    backgroundView.image = [UIImage resizedImage:@"main_view_bkg"];
    [self.view addSubview:backgroundView];
    
    // 设置顶部工具条
    [self setupTopToolbar];
    
    self.navigationController.navigationBarHidden = YES;
    
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"GDBookListCell" bundle:nil] forCellWithReuseIdentifier:GDBookCollectionCellID];
    
    // 注册collectionHeaderView
    [self.collectionView registerNib:[UINib nibWithNibName:@"GDCollectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:GDCollectionHeaderViewID];
    
    [self.view addSubview:self.collectionView];
    
}


- (void)setupTopToolbar
{
    UIView *toolbar = [[UIView alloc] init];
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
    toolbar.frame = CGRectMake(0, 0, GDScreenW, 64);
    toolbar.backgroundColor = [UIColor clearColor];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    [toolbar addSubview:imgView];
    imgView.frame = toolbar.bounds;
    imgView.image = [UIImage resizedImage:@"pc_nav_bg"];
    
    // 标题标签
    UILabel *titleLabel = [[UILabel alloc] init];
    [toolbar addSubview:titleLabel];
    titleLabel.text = @"我的书籍";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.width = 100;
    titleLabel.y = 20;
    titleLabel.height = toolbar.height - 20;
    titleLabel.centerX = toolbar.centerX;
}


#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.books.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GDBookTableViewCell *cell = [GDBookTableViewCell cellWithTableView:tableView];
    
    // 设置数据
    GDBook *book = self.books[indexPath.row];
    cell.book = book;
    
    return cell;
}

#pragma mark - Talbe view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GDBook *book = self.books[indexPath.row];
    
    // 创建阅读控制器
    GDReadingViewController *readingVc = [[GDReadingViewController alloc] init];
    readingVc.title = book.name;
    readingVc.book = book;
    [self.navigationController pushViewController:readingVc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.books.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GDBookListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GDBookCollectionCellID forIndexPath:indexPath];
    
    cell.book = self.books[indexPath.item];
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    GDCollectionHeaderView *headerView = nil;
    
    if ([kind isEqual:UICollectionElementKindSectionHeader]) {
        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:GDCollectionHeaderViewID forIndexPath:indexPath];
    }
    headerView.delegate = self;
    
    return headerView;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GDBook *book = self.books[indexPath.item];
    
    // 创建阅读控制器
    GDReadingViewController *readingVc = [[GDReadingViewController alloc] init];
    readingVc.title = book.name;
    readingVc.book = book;
    [self.navigationController pushViewController:readingVc animated:YES];
}

#pragma mark - 监听格子按钮点击

- (void)gridButtonDidSelected
{
    [self.tableView removeFromSuperview];
    [self.view addSubview:self.collectionView];
}

#pragma mark - GDCollectionHeaderViewDelegate

-(void)collectionHeaderViewDidClickListButton:(GDCollectionHeaderView *)headerView
{
    [self.collectionView removeFromSuperview];
    [self.view addSubview:self.tableView];
}

@end
