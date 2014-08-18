//
//  GDBookTextView.m
//  经典
//
//  Created by 彭根勇 on 14-8-9.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GDBookTextView.h"

@interface GDBookTextView()

@property (nonatomic, weak) UILabel *textLabel;

@end

@implementation GDBookTextView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = GDColor(185, 173, 148);
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        textLabel.font = GDBookTextFont;
        textLabel.numberOfLines = 0;
        self.textLabel = textLabel;
        [self addSubview:textLabel];
    }
    
    return self;
}

-(void)setAttributedText:(NSAttributedString *)attributedText
{
    _attributedText = attributedText;
    
    self.textLabel.attributedText = attributedText;
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    
    CGSize textSize = [self.attributedText boundingRectWithSize:CGSizeMake(GDScreenW, GDBookTextLabelH) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    // 设置label的frame
    self.textLabel.y = GDBookNameLabelH;
    
    // 因为设置label的大小随文字而改变，所以宽度需要加40。
    self.textLabel.width = textSize.width + 40;
    self.textLabel.height = textSize.height + 20;
    
}

@end
