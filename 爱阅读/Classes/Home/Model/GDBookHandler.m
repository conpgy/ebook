//
//  GDBookHandler.m
//  经典
//
//  Created by 彭根勇 on 14-8-10.
//  Copyright (c) 2014年 conpgy. All rights reserved.
//

#import "GDBookHandler.h"
#import "GDBook.h"
#import "GDBookTool.h"

@interface GDBookHandler()

/** 段落属性对象 */
@property (nonatomic, strong) NSMutableParagraphStyle *paraStyle;

//页面大小（与分页有关）
@property (nonatomic, assign) CGSize pageSize;

@property (nonatomic, assign) NSInteger bookPageIndex;

/** 书的路径 */
@property (nonatomic, copy) NSString *bookPath;

@property (nonatomic, strong) GDBook *book;

/** 书的大小 */
@property (nonatomic, assign) unsigned long long bookSize;

//保存每页的下标（文件的偏移量-分页）
@property (nonatomic, strong) NSMutableArray *pageIndexArray;

/** 操作队列 */
@property (nonatomic, strong) NSOperationQueue *queue;

@property (nonatomic, strong) NSOperation *operation;

@end

@implementation GDBookHandler

#pragma mark - 初始化

-(NSOperationQueue *)queue
{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
//        _queue.maxConcurrentOperationCount = 2;
    }
    
    return _queue;
}

-(NSMutableArray *)pageIndexArray
{
    if (!_pageIndexArray) {
        _pageIndexArray = [NSMutableArray array];
    }
    
    return _pageIndexArray;
}

-(NSMutableParagraphStyle *)paraStyle
{
    if (!_paraStyle) {
        _paraStyle = [[NSMutableParagraphStyle alloc] init];
        
        // 设置段落属性
        _paraStyle.lineSpacing = 5;
        _paraStyle.firstLineHeadIndent = 40;
        _paraStyle.headIndent = 10;
        _paraStyle.tailIndent = 310;
        _paraStyle.lineBreakMode = NSLineBreakByCharWrapping;    // 换行方式
        _paraStyle.paragraphSpacingBefore = -2;  // 未知
        _paraStyle.hyphenationFactor = 30;   // 未知
    }
    return _paraStyle;
}

-(instancetype)initWithBook:(GDBook *)book
{
    if (self = [super init]) {
        self.book = book;
        self.bookPath = [[NSBundle mainBundle] pathForResource:book.filePath ofType:nil];
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(initializeBook) userInfo:nil repeats:NO];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endOperation) name:GDReadingVCPopNote object:nil];
    }
    
    return self;
}

- (NSString *)filePath:(NSString *)fileName{
	if (fileName == nil) {
		return nil;
	}
    
	return fileName;
}

- (NSFileHandle *)handleWithFile:(NSString *)fileName {
    if (fileName == nil) return nil;
    
	return [NSFileHandle fileHandleForReadingAtPath:fileName];
}

- (unsigned long long)fileLengthWithFile:(NSString *)fileName{
	if (fileName == nil) {
		return (0);
	}
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *path = [self filePath:fileName];
	NSError *error;
	NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:&error];
	if (!fileAttributes) {
		NSLog(@"%@",error);
		return (0);
	}
	return [[fileAttributes objectForKey:NSFileSize] unsignedLongLongValue];
}


//偏移量调整（防止英文字符 一个单词被分开）
- (unsigned long long)fixOffserWith:(NSFileHandle *)handle{
	unsigned long long offset = [handle offsetInFile];
	if (offset == 0) {
		return (0);
	}
	NSData *oData = [handle readDataOfLength:1];
	if (oData) {
		NSString *jStr = [[NSString alloc]initWithData:oData encoding:NSUTF8StringEncoding];
		if (jStr) {
			char *oCh = (char *)[oData bytes];
			while  ((*oCh >= 65 && *oCh <= 90) || (*oCh >= 97 && *oCh <= 122)) {
				[handle seekToFileOffset:--offset];
				NSData *jData = [handle readDataOfLength:1];
				NSString *kStr = [[NSString alloc]initWithData:jData encoding:NSUTF8StringEncoding];
				if (kStr == nil || offset == 0) {
					break;
				}
				oCh = (char *)[jData bytes];
			}
			offset++;
		}
	}
	return offset;
}

- (void)showFirstPage{
	if ([self.delegate respondsToSelector:@selector(firstPage:)]) {
		NSFileHandle *handle = [self handleWithFile:self.bookPath];

		NSData *data = [handle readDataOfLength:[[self.pageIndexArray objectAtIndex:0] unsignedLongLongValue]];
		NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedStr addAttribute:NSParagraphStyleAttributeName value:self.paraStyle range:NSMakeRange(0, attributedStr.length)];
        [attributedStr addAttribute:NSFontAttributeName value:GDBookTextFont range:NSMakeRange(0, attributedStr.length)];
        [self.delegate firstPage:attributedStr];
	}
}

- (void)bookDidRead:(NSUInteger)size{
    if ([self.delegate respondsToSelector:@selector(bookDidRead:)]) {
        [self.delegate bookDidRead:size];
    }
}

- (unsigned long long)indexOfPage:(NSFileHandle *)handle textFont:(UIFont *)font{

	unsigned long long offset = [handle offsetInFile];
	unsigned long long fileSize = self.bookSize;
    
    CGFloat MaxHeight = GDBookTextLabelH;
	
	BOOL isEndOfFile = NO;
	NSUInteger length = 100;
    
    NSMutableAttributedString *labelStr = [[NSMutableAttributedString alloc] init];
    [labelStr addAttribute:NSParagraphStyleAttributeName value:self.paraStyle range:NSMakeRange(0, labelStr.length)];
    [labelStr addAttribute:NSFontAttributeName value:GDBookTextFont range:NSMakeRange(0, labelStr.length)];
    
	do{
		for (int j=0; j<3; j++) {
			if ((offset+length+j) > fileSize) {
				offset = fileSize;
				isEndOfFile = YES;
				break ;
			}
			[handle seekToFileOffset:offset];
			NSData *data = [handle readDataOfLength:j+length];
			if (data) {
				NSString *iStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
				if (iStr ) {
					NSString *oStr = [NSString stringWithFormat:@"%@%@",labelStr.string,iStr];

                    NSMutableAttributedString *attributedOStr = [[NSMutableAttributedString alloc] initWithString:oStr];
                
                [attributedOStr setAttributes:@{NSParagraphStyleAttributeName: self.paraStyle, NSFontAttributeName: GDBookTextFont} range:NSMakeRange(0, attributedOStr.length)];
                CGSize textSize = [attributedOStr boundingRectWithSize:CGSizeMake(GDScreenW, GDBookTextLabelH) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
					
					if (textSize.height-MaxHeight > 0 && length != 1) {
						if (length <= 5) {
							length = 1;
						}else {
							length = length/(2);
						}
					}else if (textSize.height > MaxHeight && length == 1) {
						offset = [handle offsetInFile]-length-j;
						[handle seekToFileOffset:offset];
						offset = [self fixOffserWith:handle];
						isEndOfFile = YES;
					}else if(textSize.height <= MaxHeight ) {
                        [labelStr appendAttributedString:[[NSAttributedString alloc] initWithString:iStr]];
						offset = j+length+offset;
					}
					break ;
				}
			}
		}
		if (offset >= fileSize) {
			isEndOfFile = YES;
		}
	}while (!isEndOfFile);
    
	return offset;
}


#pragma mark lll

- (NSAttributedString *)stringWithPage:(NSUInteger)pageIndex{
	if (pageIndex > [self.pageIndexArray count]) {
		return nil;
	}

	NSFileHandle *handle = [self handleWithFile:self.bookPath];
	unsigned long long offset = 0;
	if (pageIndex > 1) {
		offset = [[self.pageIndexArray objectAtIndex:pageIndex-2]unsignedLongLongValue];
	}
	[handle seekToFileOffset:offset];
	unsigned long long length = [[self.pageIndexArray objectAtIndex:pageIndex-1]unsignedLongLongValue]-offset;
	NSData *data  = [handle readDataOfLength:length];
	NSString *labelText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	if (labelText == nil) {
		return nil;
	}
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:labelText];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:self.paraStyle range:NSMakeRange(0, attributedStr.length)];
    [attributedStr addAttribute:NSFontAttributeName value:GDBookTextFont range:NSMakeRange(0, attributedStr.length)];
    
    return attributedStr;
}

- (unsigned long long)offsetWithPage:(NSUInteger)pageIndex
{
    if (pageIndex > [self.pageIndexArray count]) {
		return 0;
	}
    
	unsigned long long offset = 0;
	if (pageIndex > 1) {
		offset = [[self.pageIndexArray objectAtIndex:pageIndex-2]unsignedLongLongValue];
	}
    
    return offset;
}

- (void)bookIndex{
	NSFileHandle *handle = [self handleWithFile:self.bookPath];
	NSUInteger count = [self.pageIndexArray count];
    NSUInteger bookSize = self.bookSize;
	unsigned long long index = [[self.pageIndexArray objectAtIndex:count-1] unsignedLongLongValue];
	while (index < bookSize) {
        
        // 如果当前操作被取消，则不继续饿执行了
        if ([self.operation isCancelled])   return;
        
		[handle seekToFileOffset:index];
		index = [self indexOfPage:handle textFont:GDBookTextFont];
		[self.pageIndexArray addObject:[NSNumber numberWithUnsignedLongLong:index]];
	}
    
	[self bookDidRead:[self.pageIndexArray count]];
    
    // 将书的大小和页面索引存入数据库中
    [GDBookTool saveBook:self.book withBooksize:self.bookSize andPageIndexArray:self.pageIndexArray];
}

/** 对书进行初始化 */

- (void)initializeBook
{
    if ([GDBookTool selectBook:self.book]) {    // 数据库中对此书进行了分页处理
        // 获得书的总页数和分页数组
        self.bookSize = self.book.size;
        NSMutableArray *arry = self.book.pageIndexArray;
        // 将array中的字符串元素转换为NSNumber
        for (NSString *ele in arry) {
            NSNumber *number =@([ele longLongValue]);
            [self.pageIndexArray addObject:number];
        }
        
        [self showFirstPage];
        
        if ([self.delegate respondsToSelector:@selector(bookDidRead:)]) {
            [self.delegate bookDidRead:self.book.pageIndexArray.count];
        }
    } else {
        [self pageAr];
    }
}


/** 
 * 进行分页和显示处理
 */
- (void)pageAr{
	self.bookSize = [self fileLengthWithFile:self.bookPath];
    
    if (self.bookSize == 0) return;
    
	NSFileHandle *handle = [self handleWithFile:self.bookPath];
	unsigned long long index = 0;
	unsigned long long previouaIndex = 0;
    
	for (int i=0; i<3; i++)  {
		index = [self indexOfPage:handle textFont:GDBookTextFont];
        if (index != previouaIndex) {
            [self.pageIndexArray addObject:[NSNumber numberWithUnsignedLongLong:index]];
            [handle seekToFileOffset:index];
        }
        previouaIndex = index;
	}
	[self showFirstPage];
	
    typeof(self) weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf bookIndex];
    }];
    self.operation = operation;
    
    [self.queue addOperation:operation];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/** 对象被销毁时，停止操作operation */
- (void)endOperation
{
    [self.operation cancel];
}

@end
