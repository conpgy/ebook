//
//  GDNavigationBar.h
//  经典
//
//  Created by 彭根勇 on 14-8-9.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GDReadingNavigationBar;

typedef enum {
    GDNavigationBarButtonTypeBack,
    GDNavigationBarButtonTypeBookmark,
    GDNavigationBarButtonTypeBookInfo,
    GDNavigationBarButtonTypeFont,
    GDNavigationBarButtonTypeSearch
}GDNavigationBarButtonType;

//typedef enum {
//    GDNavigationBarButtonStateNormal,
//    GDNavigationBarButtonStateSelected
//}GDNavigationBarButtonState;

@protocol GDNavigationBarDelegate  <NSObject>

@optional

- (void)navigationBar:(GDReadingNavigationBar *)navigationBar didClickButton:(GDNavigationBarButtonType)type;

@end

@interface GDReadingNavigationBar : UIView

@property (nonatomic, weak) id<GDNavigationBarDelegate> delegate;

+(instancetype)navigationBar;

@end
