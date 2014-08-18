//
//  GDNavigationBar.m
//  经典
//
//  Created by 彭根勇 on 14-8-9.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GDReadingNavigationBar.h"

@implementation GDReadingNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(instancetype)navigationBar
{
    return [[[NSBundle mainBundle] loadNibNamed:@"GDReadingNavigationBar" owner:nil options:nil] lastObject];
}
- (IBAction)back
{
    if ([self.delegate respondsToSelector:@selector(navigationBar:didClickButton:)]) {
        [self.delegate navigationBar:self didClickButton:GDNavigationBarButtonTypeBack];
    }
}

- (IBAction)bookmark:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if ([self.delegate respondsToSelector:@selector(navigationBar:didClickButton:)]) {
        [self.delegate navigationBar:self didClickButton:GDNavigationBarButtonTypeBookmark];
    }
}
- (IBAction)bookInfo
{
    if ([self.delegate respondsToSelector:@selector(navigationBar:didClickButton:)]) {
        [self.delegate navigationBar:self didClickButton:GDNavigationBarButtonTypeBookInfo];
    }
}
- (IBAction)textFont
{
    if ([self.delegate respondsToSelector:@selector(navigationBar:didClickButton:)]) {
        [self.delegate navigationBar:self didClickButton:GDNavigationBarButtonTypeFont];
    }
}
- (IBAction)search
{
    if ([self.delegate respondsToSelector:@selector(navigationBar:didClickButton:)]) {
        [self.delegate navigationBar:self didClickButton:GDNavigationBarButtonTypeSearch];
    }
}

@end
