//
//  GDReadingViewController.h
//  爱阅读
//
//  Created by 彭根勇 on 14-8-17.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GDBook;

@interface GDReadingViewController : UIViewController

/** 图书模型 */
@property (nonatomic, strong) GDBook *book;

@end
