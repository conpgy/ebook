//
//  GDBookText.h
//  经典
//
//  Created by 彭根勇 on 14-8-9.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDBookText : NSObject

/** 书名 */
@property (nonatomic, copy) NSString *bookName;

/** 当前显示的文字 */
@property (nonatomic, copy) NSString *text;

/** AttributedText */
@property (nonatomic, copy) NSAttributedString *attributedText;


@end
