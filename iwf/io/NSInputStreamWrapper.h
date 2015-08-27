//
//  NSInputStreamWrapper.h
//  iwf
//
//  Created by Centny on 8/27/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

//#ifndef input_stream_wrapper_h
//#define input_stream_wrapper_h
#import <Foundation/Foundation.h>

@interface NSInputStreamWrapper : NSInputStream
@property(nonatomic,retain) NSInputStream *base;
- (instancetype)initWithBase:(NSInputStream*)base;
@end
//#endif