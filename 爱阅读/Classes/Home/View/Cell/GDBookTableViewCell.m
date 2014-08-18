//
//  GDBookTableViewCell.m
//  爱阅读
//
//  Created by 彭根勇 on 14-8-11.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GDBookTableViewCell.h"
#import "GDBook.h"

@interface GDBookTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *booknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@end

@implementation GDBookTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"bookCell";
    
    GDBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GDBookTableViewCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

-(void)setBook:(GDBook *)book
{
    _book = book;
    
    self.booknameLabel.text = book.name;
}

@end
