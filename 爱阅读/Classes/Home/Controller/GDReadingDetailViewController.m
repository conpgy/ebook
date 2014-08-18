//
//  GDReadingViewController.m
//  经典
//
//  Created by 彭根勇 on 14-8-8.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GDReadingDetailViewController.h"
#import "GDBookTextView.h"

@interface GDReadingDetailViewController ()

@property (nonatomic, weak) GDBookTextView *textView;

@end

@implementation GDReadingDetailViewController

#pragma mark - 初始化

-(GDBookTextView *)textView
{
    if (!_textView) {
        GDBookTextView *textView = [[GDBookTextView alloc] init];
        [self.view addSubview:textView];
        self.textView = textView;
        textView.frame = self.view.bounds;
    }
    
    return _textView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self textView];
}

-(void)setAttributedText:(NSAttributedString *)attributedText
{
    _attributedText = attributedText;
    
    self.textView.attributedText = attributedText;
}

@end
