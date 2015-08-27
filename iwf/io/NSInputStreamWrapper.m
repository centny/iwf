//
//  NSInputStreamWrapper.m
//  iwf
//
//  Created by Centny on 8/27/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import "NSInputStreamWrapper.h"

@implementation NSInputStreamWrapper

- (void)open{
    [self.base open];
}
- (void)close{
    [self.base close];
}
- (void)setDelegate:(id<NSStreamDelegate>)delegate{
    self.base.delegate=delegate;
}
- (id<NSStreamDelegate>)delegate{
    return self.base.delegate;
}
- (id)propertyForKey:(NSString *)key{
    return [self.base propertyForKey:key];
}
- (BOOL)setProperty:(id)property forKey:(NSString *)key{
    return [self.base setProperty:property forKey:key];
}
- (void)scheduleInRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode{
    [self.base scheduleInRunLoop:aRunLoop forMode:mode];
}
- (void)removeFromRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode{
    [self.base removeFromRunLoop:aRunLoop forMode:mode];
}
- (NSStreamStatus)streamStatus{
    return self.base.streamStatus;
}
- (NSError *)streamError{
    return self.base.streamError;
}
- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len{
    return [self.base read:buffer maxLength:len];
}
- (BOOL)getBuffer:(uint8_t **)buffer length:(NSUInteger *)len{
    return [self.base getBuffer:buffer length:len];
}
- (BOOL)hasBytesAvailable{
    return self.base.hasBytesAvailable;
}
- (instancetype)initWithBase:(NSInputStream *)base{
    if(self=[super init]){
        self.base=base;
    }
    return self;
}
@end
