//
//  GDBookTool.m
//  爱阅读
//
//  Created by 彭根勇 on 14-8-13.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GDBookTool.h"
#import "FMDB.h"
#import "GDBook.h"

static FMDatabase *_db;

@interface GDBookTool ()
@end

@implementation GDBookTool

+(NSArray *)books
{
    NSMutableArray *books = [NSMutableArray array];
    
    // 获得数据库文件路径
    NSString *filename = [[NSBundle mainBundle] pathForResource:@"books.sqlite" ofType:nil];
    
    FMDatabase *db = [FMDatabase databaseWithPath:filename];
    
    // 打开数据库
    if ([db open]) {
        BOOL success = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS books (id integer PRIMARY KEY AUTOINCREMENT, book_order integer NOT NULL, name text NOT NULL, filepath text NOT NULL, booksize text, mediatype text, coverimage text, page_index_array text);"];
        
        if (!success) {
            GDLog(@"创表失败");
        }
    } else {
        GDLog(@"打开数据库失败");
        return nil;
    }
    _db = db;
    
//    [db executeUpdate:@"UPDATE books set book_order=20 where id=20;"];
//    [db executeUpdate:@"ALTER TABLE books ADD page_index_array blob;"];
    
    // 执行查询
    FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM books"];
    
//    [db executeUpdate:@"INSERT INTO books (book_order, name, filepath, mediatype) VALUES (5, '按时长大', 'jingangjing.txt', 'txt');"];
    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE books set filepath='anshizhangda.txt' where book_order=5;"];
    [db executeUpdate:updateSQL];
    
    // 遍历结果
    while ([resultSet next]) {
        GDBook *book = [[GDBook alloc] init];
        
        book.name = [resultSet stringForColumn:@"name"];
        book.order = [resultSet intForColumn:@"book_order"];
        book.filePath = [resultSet stringForColumn:@"filepath"];
        book.size = [[resultSet stringForColumn:@"booksize"] longLongValue];
        book.coverImage = [resultSet stringForColumn:@"coverimage"];
        book.mediaType = [resultSet stringForColumn:@"mediatype"];
        NSString *arrayStr = [resultSet stringForColumn:@"page_index_array"];
        book.pageIndexArray =[NSMutableArray arrayWithArray:[arrayStr componentsSeparatedByString:@"\n"]];
        [book.pageIndexArray removeLastObject];
        
        [books addObject:book];
    }
    
    return books;
}

/**
 *  查询数据库中是否储存了书的大小和分页信息
 */
+(BOOL)selectBook:(GDBook *)book
{
    NSString *selectSQL = [NSString stringWithFormat:@"SELECT booksize,page_index_array FROM books where book_order=%lu",(unsigned long)book.order];
    
    FMResultSet *resultSet = [_db executeQuery:selectSQL];
    
    while ([resultSet next]) {
        NSString *size = [resultSet stringForColumn:@"booksize"];
        NSString *pageIndexArray = [resultSet stringForColumn:@"page_index_array"];
        
        if (size != nil && pageIndexArray != nil) {
            return YES;
        }
    }
    
    return NO;
}

/**
 *  储存书的大小和分页信息
 */
+(void)saveBook:(GDBook *)book withBooksize:(NSUInteger)size andPageIndexArray:(NSMutableArray *)pageIndexArray
{
    NSString *sizeStr = [NSString stringWithFormat:@"%lu", (unsigned long)size];
    
    // 将数组转换为字符串
    NSMutableString *pageIndexStr = [NSMutableString string];
    for (NSNumber *number in pageIndexArray) {
        unsigned long long index = [number unsignedLongLongValue];
        [pageIndexStr appendFormat:@"%llu\n", index];
    }
    
    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE books set booksize='%@', page_index_array='%@' where book_order=%lu;", sizeStr, pageIndexStr, book.order];
    if ([_db executeUpdate:updateSQL]) {
        // 更新这本书的信息
        book.size = size;
        book.pageIndexArray = pageIndexArray;
    }
}

@end
