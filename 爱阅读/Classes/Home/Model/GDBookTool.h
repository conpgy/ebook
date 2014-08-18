//
//  GDBookTool.h
//  爱阅读
//
//  Created by 彭根勇 on 14-8-13.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GDBook;

@interface GDBookTool : NSObject

/** 返回GDBook数组 */
+(NSArray *)books;

/** 查询书籍 */
+(BOOL)selectBook:(GDBook *)book;

/** 储存书籍的大小和分页信息 */
+(void)saveBook:(GDBook *)book withBooksize:(NSUInteger)size andPageIndexArray:(NSMutableArray *)pageIndexArray;

@end
