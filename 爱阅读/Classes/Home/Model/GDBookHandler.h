//
//  GDBookHandler.h
//  经典
//
//  Created by 彭根勇 on 14-8-10.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GDBookHandler,GDBook;

@protocol GDBookHandlerDelegate <NSObject>

@optional
/** 返回第一页的内容 */
- (void)firstPage:(NSMutableAttributedString *)pageString;

/** 书籍遍历完毕 */
- (void)bookDidRead:(NSUInteger)size;

@end

@interface GDBookHandler : NSObject

@property (nonatomic, weak) id<GDBookHandlerDelegate> delegate;

/** 书的URL */
@property (nonatomic, copy) NSString *url;


/**
 *  通过书的url进行初始化
 */
-(instancetype)initWithBook:(GDBook *)book;

/**
 *  根据页面索引返回该页对应的内容
 *
 *  @param pageIndex 页面索引
 */
-(NSMutableAttributedString *)stringWithPage:(NSUInteger)pageIndex;

@end
