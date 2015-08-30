//
//  NSDataInputStream.h
//  iwf
//
//  Created by Centny on 8/30/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

//#import <iwf/iwf.h>
#import "NSInputStreamWrapper.h"

@interface NSDataInputStream : NSInputStreamWrapper
@property(nonatomic,retain) NSMutableData* data_b;
@property(nonatomic,retain) NSMutableData* data_e;

- (instancetype)init;
- (void)appendData:(NSData*)data end:(BOOL)end;
- (void)appendStr:(NSString*)data end:(BOOL)end;
@end
