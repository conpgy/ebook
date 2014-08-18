//
//  GDCollectionHeaderView.h
//  爱阅读
//
//  Created by 彭根勇 on 14-8-12.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GDCollectionHeaderView;

@protocol GDCollectionHeaderViewDelegate <NSObject>

@optional
-(void)collectionHeaderViewDidClickListButton:(GDCollectionHeaderView *)headerView;

@end

@interface GDCollectionHeaderView : UICollectionReusableView

@property (nonatomic, weak) id<GDCollectionHeaderViewDelegate> delegate;


@end
