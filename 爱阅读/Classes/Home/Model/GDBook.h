//
//  GDBook.h
//  经典
//
//  Created by 彭根勇 on 14-8-7.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDBook : NSObject

/** 书名 */
@property (nonatomic, copy) NSString *name;

/** 地址 */
@property (nonatomic, copy) NSString *filePath;

/** 图书序号 */
@property (nonatomic, assign) NSUInteger order;

/** 书的大小 */
@property (nonatomic, assign) long long size;


/** 书的格式类型 */
@property (nonatomic, copy) NSString *mediaType;

/** 书的封面图片 */
@property (nonatomic, copy) NSString *coverImage;

/** 书的每页位置索引数组，下标代表页，元素代表位置 */
@property (nonatomic, strong) NSMutableArray *pageIndexArray;

@end
