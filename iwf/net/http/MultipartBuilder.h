//
//  MultipartStream.h
//  iwf
//
//  Created by Centny on 8/27/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

//#import <iwf/iwf.h>
#import <Foundation/Foundation.h>
//
@interface MultipartBuilder : NSObject

@property(nonatomic,retain)NSString *bound;
@property(nonatomic,readonly)NSMutableDictionary *datas;
//
@property(nonatomic,retain)NSString* path;
@property(nonatomic,retain)NSString* type;
@property(nonatomic,retain)NSString* name;
@property(nonatomic,retain)NSString* filename;
@property(nonatomic,assign)long      clength;//the content length.
//
- (instancetype)initWithBound:(NSString*)bound;
- (instancetype)initWithBound:(NSString*)bound args:(NSDictionary*)args;
- (instancetype)initWithBound:(NSString*)bound args:(NSDictionary*)args name:(NSString*)name path:(NSString*)path;
- (void)addArgs:(NSDictionary*)args;
- (void)buildPath:(NSString*)path name:(NSString*)name;
- (NSInputStream*)build;

+ (MultipartBuilder*)builderWith:(NSDictionary*)args name:(NSString*)name path:(NSString*)path;
@end
