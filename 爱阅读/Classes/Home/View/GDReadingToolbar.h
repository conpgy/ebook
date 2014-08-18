//
//  GDReadingToolbar.h
//  爱阅读
//
//  Created by 彭根勇 on 14-8-14.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GDReadingToolbar;

@protocol GDReadingToolbarDelegate <NSObject>

@optional

/** 结束拖拽 */
- (void)readingToolbarEnded:(GDReadingToolbar *)toolbar progress:(double)progress;

/** 开始拖拽 */
- (void)readingToolbarBeganPanSlider:(GDReadingToolbar *)toolbar;

/** 正在拖拽 */
- (void)readingToolbarPaningSlider:(GDReadingToolbar *)toolbar progress:(double)progress;

@end

@interface GDReadingToolbar : UIView

@property (nonatomic, weak) id<GDReadingToolbarDelegate> delegate;


+(instancetype)toolbar;

@end
