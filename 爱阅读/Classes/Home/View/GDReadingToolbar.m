//
//  GDReadingToolbar.m
//  爱阅读
//
//  Created by 彭根勇 on 14-8-14.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GDReadingToolbar.h"

@interface GDReadingToolbar ()

@property (weak, nonatomic) IBOutlet UIImageView *slider;
@property (weak, nonatomic) IBOutlet UIView *progressView;

@end

@implementation GDReadingToolbar

+(instancetype)toolbar
{
    return [[[NSBundle mainBundle] loadNibNamed:@"GDReadingToolbar" owner:nil options:nil] lastObject];
}

- (IBAction)panSlider:(UIPanGestureRecognizer *)sender
{
    CGPoint p = [sender translationInView:sender.view];
    [sender setTranslation:CGPointZero inView:sender.view];
    
    self.slider.centerX += p.x;
    
    if (self.slider.centerX <= 20) {
        self.slider.centerX = 20;
    } else if (self.slider.centerX >= GDScreenW - 20) {
        self.slider.centerX = GDScreenW - 20;
    }
    
    self.progressView.width = self.slider.centerX - self.progressView.x;
    
    
    // 计算当前的进度
    double progress = (self.slider.centerX - 20) / (GDScreenW - 2 * 20);
    
    // 通知代理
    if (sender.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(readingToolbarEnded:progress:)]) {
            [self.delegate readingToolbarEnded:self progress:progress];
        }
    } else if (sender.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(readingToolbarBeganPanSlider:)]) {
            [self.delegate readingToolbarBeganPanSlider:self];
        }
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        if ([self.delegate respondsToSelector:@selector(readingToolbarPaningSlider:progress:)]) {
            [self.delegate readingToolbarPaningSlider:self progress:progress];
        }
    }
}

@end
