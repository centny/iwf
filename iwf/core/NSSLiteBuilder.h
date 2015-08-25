//
//  NSSLiteBuilder.h
//  BuyGo
//
//  Created by Cny on 8/23/13.
//  Copyright (c) 2013 Cny. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSSLiteBuilder;
typedef void (^ SQLiteQueryCallback)(NSSLiteBuilder *builder, NSMutableDictionary *row);
//
@interface NSSLiteBuilder : NSObject
@property(nonatomic, retain) NSString		*emsg;
+ (id)builderWithDb:(NSString *)spath;
- (int)initDb:(const char *)spath;
- (int)exec:(const char *)sql;
- (int)prepare:(const char *)sql;
- (int)reset;
- (int)columnCount;
- (int)dataCount;
- (int)bind:(int)idx int32:(int)val;
- (int)bind:(int)idx int64:(long long int)val;
- (int)bind:(int)idx double64:(double)val;
- (int)bind:(int)idx text:(const char *)val;
- (int)bind:(int)idx string:(NSString *)val;
- (int)bindNull:(int)idx;
- (int)columnInt32:(int)idx;
- (long long int)columnInt64:(int)idx;
- (double)columnDouble:(int)idx;
- (const unsigned char *)columnText:(int)idx;
- (NSString *)columnString:(int)idx;
- (const char *)columnName:(int)idx;
- (NSString *)columnNameString:(int)idx;
- (int)columnType:(int)idx;
- (NSString *)errorMsg;
- (int)freeStm;
- (int)step;
//
- (NSArray *)queryAll:(SQLiteQueryCallback)back;
@end
//

