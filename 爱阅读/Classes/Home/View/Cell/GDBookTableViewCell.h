//
//  GDBookTableViewCell.h
//  爱阅读
//
//  Created by 彭根勇 on 14-8-11.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GDBook;

@interface GDBookTableViewCell : UITableViewCell

@property (nonatomic, strong) GDBook *book;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
