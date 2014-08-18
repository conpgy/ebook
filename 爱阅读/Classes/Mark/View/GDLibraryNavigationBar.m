//
//  GDLibraryNavigationBar.m
//  爱阅读
//
//  Created by 彭根勇 on 14-8-12.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GDLibraryNavigationBar.h"

@implementation GDLibraryNavigationBar

+(instancetype)navigationBar
{
    return [[[NSBundle mainBundle] loadNibNamed:@"GDLibraryNavigationBar" owner:nil options:nil] lastObject];
}

@end
