//
//  GDReadingViewController.m
//  爱阅读
//
//  Created by 彭根勇 on 14-8-17.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GDReadingDetailViewController.h"
#import "GDReadingViewController.h"

#import "GDReadingNavigationBar.h"
#import "GDBook.h"
#import "GDBookTextView.h"
#import "GDBookText.h"
#import "GDBookHandler.h"
#import "GDReadingToolbar.h"
#import "GDBookInfoViewController.h"

@interface GDReadingViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate,GDNavigationBarDelegate, GDBookHandlerDelegate, GDReadingToolbarDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;

@property (nonatomic, strong) GDReadingDetailViewController *currentVc;
@property (nonatomic, strong) GDReadingDetailViewController *previousVc;
@property (nonatomic, strong) GDReadingDetailViewController *nextVc;

@property (nonatomic, assign) BOOL hasPrevious; // 向前翻页时，设为YES，翻译动画完后设为NO
@property (nonatomic, assign) BOOL hasNext; // 向后翻页时，设为YES，翻译动画完后设为NO


/** 当前正在看第几页 */
@property (nonatomic, assign) NSUInteger pageIndex;

/** 第一页和最后一页时，提示框 */
@property (nonatomic, weak) UIButton *tipView;

@property (nonatomic, strong) NSArray *textArray;

@property (nonatomic, weak) GDReadingNavigationBar *navBar;

@property (nonatomic, weak) GDReadingToolbar *toolbar;

@property (nonatomic, weak) GDBookTextView *textView;

@property (nonatomic, strong) GDBookHandler *bookHandler;

/** 书总页数 */
@property (nonatomic, assign) NSUInteger totalPage;

/** 进度标签 */
@property (nonatomic, weak) UILabel *progressLabel;

/** 存放所有内容的view */
@property (nonatomic, weak) UIImageView *contentView;

/** 进度条浮动提示框 */
@property (nonatomic, weak) UIButton *progressFloatBtn;

@property (nonatomic, strong) NSMutableDictionary *pageVcs;

@end

@implementation GDReadingViewController

#pragma mark - 懒加载

-(NSMutableDictionary *)pageVcs
{
    if (!_pageVcs) {
        _pageVcs = [NSMutableDictionary dictionary];
    }
    
    return _pageVcs;
}

-(GDReadingDetailViewController *)currentVc
{
    if (!_currentVc) {
        _currentVc = [[GDReadingDetailViewController alloc] init];
        _currentVc.view.backgroundColor = [UIColor redColor];
        _currentVc.index = 1;
    }
    
    return _currentVc;
}

-(GDReadingDetailViewController *)previousVc
{
    if (!_previousVc) {
        _previousVc = [[GDReadingDetailViewController alloc] init];
        _previousVc.index = 0;
    }
    
    return _previousVc;
}

-(GDReadingDetailViewController *)nextVc
{
    if (!_nextVc) {
        _nextVc = [[GDReadingDetailViewController alloc] init];
        _nextVc.index = 2;
        
    }
    
    return _nextVc;
}

-(UIPageViewController *)pageViewController
{
    if (!_pageViewController) {
        
        _pageViewController = [[UIPageViewController alloc]
                                   
                                   initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                   
                                   navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
        _pageViewController.delegate = self;
        
        _pageViewController.dataSource = self;
        
        // 设第一个视图，为当前pageViewController的首页
        
        NSArray *viewControllers = @[self.currentVc];
        
        [_pageViewController setViewControllers:viewControllers
         
                                          direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        
        [self addChildViewController:_pageViewController];

    }
    
    return _pageViewController;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navBar.y = - self.navBar.height;
    self.toolbar.y = self.view.height;
    
    // 隐藏状态栏
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;

    [self.view addSubview:self.pageViewController.view];
    
    self.bookHandler = [[GDBookHandler alloc] initWithBook:self.book];
    self.bookHandler.delegate = self;
    
    [self setupTapView];
    
    // 设置顶部的导航条
    [self setupNavBar];
    
    [self setupProgressLabel];
    
    // 设置底部的工具条
    [self setupToolbar];
    
    // 设置提示条
    [self setupTipView];
    
    // 设置进度条拖动时悬浮框
    [self setupProgressFloatBtn];
}

#pragma mark - 私有方法

-(void)setupNavBar
{
    GDReadingNavigationBar *navBar = [GDReadingNavigationBar navigationBar];
    [self.view addSubview:navBar];
    navBar.delegate = self;
    navBar.y = -navBar.height;
    navBar.alpha = 0.0;
    self.navBar = navBar;
}

- (void)setupToolbar
{
    GDReadingToolbar *toolbar = [GDReadingToolbar toolbar];
    [self.view addSubview:toolbar];
    toolbar.delegate = self;
    toolbar.y = self.view.height;
    self.toolbar = toolbar;
    toolbar.alpha = 0.0;
}

-(void)setupTapView
{
    // 添加一个view，用来控制导航条和工具条的隐藏与显示
    UIView *tapView = [[UIView alloc] init];
    [self.view addSubview:tapView];
    tapView.frame = CGRectMake(50, 0, self.view.width - 100, self.view.height);
    
    // 添加一个点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHiddenToolBar:)];
    [tapView addGestureRecognizer:tap];
}

- (void)setupTipView
{
    UIButton *tipView = [[UIButton alloc] init];
    [self.view addSubview:tipView];
    self.tipView = tipView;
    
    tipView.hidden = YES;
    tipView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [tipView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tipView.titleLabel.font = [UIFont systemFontOfSize:16];
    tipView.size = CGSizeMake(120, 50);
    tipView.centerY = self.view.centerY;
    tipView.centerX = self.view.centerX;
    tipView.layer.cornerRadius = 7;
}

- (void)setupProgressFloatBtn
{
    UIButton *progressFloatBtn = [[UIButton alloc] init];
    [self.view addSubview:progressFloatBtn];
    self.progressFloatBtn = progressFloatBtn;
    
    progressFloatBtn.hidden = YES;
    [progressFloatBtn setBackgroundImage:[UIImage imageNamed:@"toolbar_progress_float"] forState:UIControlStateNormal];
    progressFloatBtn.size = progressFloatBtn.currentBackgroundImage.size;
    progressFloatBtn.centerX = self.view.centerX;
    progressFloatBtn.y = GDScreenH - 120;
    progressFloatBtn.titleLabel.numberOfLines = 0;
    progressFloatBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}

- (void)setupProgressLabel
{
    UILabel *progressLabel = [[UILabel alloc] init];
    [self.view addSubview:progressLabel];
    self.progressLabel = progressLabel;
    
    progressLabel.font = [UIFont boldSystemFontOfSize:13];
    progressLabel.textColor = [UIColor grayColor];
    progressLabel.textAlignment = NSTextAlignmentCenter;
    
    // 设置frame
    progressLabel.width = 70;
    progressLabel.height = 25;
    progressLabel.centerX = GDScreenW * 0.5;
    progressLabel.y = self.view.height - progressLabel.height;
    
    // 设置文字
    progressLabel.text = [NSString stringWithFormat:@"1/%lu", (unsigned long)self.book.pageIndexArray.count];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    // 判断是否有翻页动画，没有的话，则接返回。（因为如果没有动画，则不会调用代理方法。交互不能停止。直接返回）
    for (UIGestureRecognizer *recognizer in pageViewController.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
            UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)recognizer;
            CGPoint tPoint = [pan translationInView:pageViewController.view];
            
            if (!CGPointEqualToPoint(tPoint, CGPointZero) && tPoint.x == 0) {
                    return nil;
            }
        }
    }

    if (self.hasNext){
        self.hasNext = NO;
        self.pageViewController.view.userInteractionEnabled = YES;
        return nil;
    }
    
    if (self.navBar.y == 0) {
        [self showHiddenToolBar:nil];
        return nil;
    }
    
    if(self.pageIndex <= 1)
    {
        if (self.tipView.hidden) {
            self.tipView.hidden = NO;
            [self.tipView setTitle:@"已翻至第一页" forState:UIControlStateNormal];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.tipView.hidden = YES;
            });
        }
        return nil;
    }
    
    GDReadingDetailViewController *readingVc = self.previousVc;
    
    readingVc.attributedText = [self.bookHandler stringWithPage:self.pageIndex - 1];
    
    self.hasPrevious = YES;
    
    // 在翻书动画执行完之前不允许继续交互
    self.pageViewController.view.userInteractionEnabled = NO;
    
    return readingVc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
#warning 有时候这个hasPrevious会自动变成YES，然后会出现一个错误，因此在这里加个判断，原理不清楚
    if (self.hasPrevious) {
        self.hasPrevious = NO;
        self.pageViewController.view.userInteractionEnabled = YES;
        return nil;
    }

    if (self.navBar.y == 0 ) {
        [self showHiddenToolBar:nil];
        return nil;
    }
    

    NSAttributedString *attributedText = [self.bookHandler stringWithPage:self.pageIndex + 1];
    if (attributedText == nil)
    {
        if (self.tipView.hidden) {
            self.tipView.hidden = NO;
            [self.tipView setTitle:@"已翻至最后一页" forState:UIControlStateNormal];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.tipView.hidden = YES;
            });
        }
        return nil;
    }
    
    GDReadingDetailViewController *readingVc = self.nextVc;
    
    readingVc.attributedText = attributedText;
    
    self.hasNext = YES;
    
    // 在翻书动画执行完之前不允许继续交互
    self.pageViewController.view.userInteractionEnabled = NO;
    return readingVc;
}

#pragma mark - UIPageViewController 代理方法

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed && finished) {
        // 交换
        if (self.hasPrevious)   // 向前翻页
        {
            self.previousVc = self.nextVc;
            self.nextVc = [previousViewControllers firstObject];
            self.pageIndex--;
            
        } else if(self.hasNext) // 向后翻页
        {
            self.nextVc = self.previousVc;
            self.previousVc = [previousViewControllers firstObject];
            self.pageIndex++;
        }
        self.progressLabel.text = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)self.pageIndex, (unsigned long)self.book.pageIndexArray.count];
    }
    self.hasPrevious = NO;
    self.hasNext = NO;
    
    // 在翻书动画执行完后允许继续交互
    self.pageViewController.view.userInteractionEnabled = YES;
}

#pragma mark - 栏控制

- (void)showHiddenToolBar:(UITapGestureRecognizer *)tap
{
    if (self.navBar.y == -self.navBar.height) {
        [UIView animateWithDuration:0.3 animations:^{
            self.navBar.y = 0;
            self.toolbar.y = self.view.height - self.toolbar.height;
            self.navBar.alpha = 1.0;
            self.toolbar.alpha = 1.0;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.navBar.y = -self.navBar.height;
            self.toolbar.y = self.view.height;
            self.navBar.alpha = 0.0;
            self.toolbar.alpha = 0.0;
        }];
    }
    
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
}

-(BOOL)prefersStatusBarHidden
{
    if (self.navBar.y == - self.navBar.height) {
        return YES;
    } else {
        return NO;
    }
}


#pragma mark - navigationBar 按钮点击调用的方法

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)bookmark
{
    
}

- (void)bookInfo
{
    // 动画
    CATransition *ca = [[CATransition alloc] init];
    ca.type = @"oglFlip";
    ca.subtype = @"fromLeft";
    ca.duration = 0.5;
    [self.navigationController.view.layer addAnimation:ca forKey:nil];
    
    GDBookInfoViewController *bookInfoVc = [[GDBookInfoViewController alloc] init];
    [self.navigationController pushViewController:bookInfoVc animated:YES];
}

- (void)textFont
{
    
}

- (void)search
{
    
}

#pragma mark - GDNavigationBarDelegate

-(void)navigationBar:(GDReadingNavigationBar *)navigationBar didClickButton:(GDNavigationBarButtonType)type
{
    switch (type) {
        case GDNavigationBarButtonTypeBack:
            [self back];
            break;
            
        case GDNavigationBarButtonTypeBookmark:
            [self bookmark];
            break;
            
        case GDNavigationBarButtonTypeBookInfo:
            [self bookInfo];
            break;
            
        case GDNavigationBarButtonTypeFont:
            [self textFont];
            break;
            
        case GDNavigationBarButtonTypeSearch:
            [self search];
            break;
            
            
        default:
            break;
    }
}


/** 通过进度条翻页 */
- (void)nextByProgressView
{
    self.pageIndex++;
    NSAttributedString *attributedText = [self.bookHandler stringWithPage:self.pageIndex];
    if (attributedText == nil)
    {
        self.pageIndex--;
        return;
    }
    
    self.currentVc.attributedText = attributedText;
    self.progressLabel.text = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)self.pageIndex, (unsigned long)self.book.pageIndexArray.count];
}

#pragma mark - GDBookHandlerDelegate

-(void)firstPage:(NSMutableAttributedString *)pageString
{
    if(pageString == nil) return;
    
    self.currentVc.attributedText = pageString;
    self.pageIndex++;
}

-(void)bookDidRead:(NSUInteger)size
{
    self.totalPage = size;
}

#pragma mark - GDReadingToolbarDelegate

-(void)readingToolbarEnded:(GDReadingToolbar *)toolbar progress:(double)progress
{
    self.pageIndex = (NSUInteger)(progress * self.totalPage);
    if (self.pageIndex > 0) {
        self.pageIndex--;
    }
    [self nextByProgressView];
    
    self.progressFloatBtn.hidden = YES;
}

-(void)readingToolbarPaningSlider:(GDReadingToolbar *)toolbar progress:(double)progress
{
    self.pageIndex = (NSUInteger)(progress * self.totalPage);
    
    NSString *text = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)self.pageIndex, (unsigned long)self.totalPage];
    if (self.pageIndex == 0) {
        text = [NSString stringWithFormat:@"1/%lu", (unsigned long)self.totalPage];
    }
    [self.progressFloatBtn setTitle:text forState:UIControlStateNormal];
}

-(void)readingToolbarBeganPanSlider:(GDReadingToolbar *)toolbar
{
    self.progressFloatBtn.hidden = NO;
    
    NSString *text = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)self.pageIndex, (unsigned long)self.totalPage];
    
    [self.progressFloatBtn setTitle:text forState:UIControlStateNormal];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] postNotificationName:GDReadingVCPopNote object:nil];
}

@end
