//
//  GDCollectionHeaderView.m
//  爱阅读
//
//  Created by 彭根勇 on 14-8-12.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GDCollectionHeaderView.h"

@implementation GDCollectionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)listButtonClick
{
    if ([self.delegate respondsToSelector:@selector(collectionHeaderViewDidClickListButton:)]) {
        [self.delegate collectionHeaderViewDidClickListButton:self];
    }
}

@end
