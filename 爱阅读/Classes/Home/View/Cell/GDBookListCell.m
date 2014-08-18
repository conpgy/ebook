//
//  GDBookListCell.m
//  爱阅读
//
//  Created by 彭根勇 on 14-8-11.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GDBookListCell.h"
#import "GDBook.h"

@interface GDBookListCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *booknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *iconBooknameLabel;

@end

@implementation GDBookListCell

-(void)setBook:(GDBook *)book
{
    self.booknameLabel.text = book.name;
    self.iconBooknameLabel.text = book.name;
}

@end
