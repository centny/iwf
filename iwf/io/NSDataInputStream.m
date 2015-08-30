//
//  NSDataInputStream.m
//  iwf
//
//  Created by Centny on 8/30/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import "NSDataInputStream.h"
#import <iwf/iwf.h>

@interface NSDataInputStream ()
@property(nonatomic,assign)NSUInteger readed_b;
@property(nonatomic,assign)NSUInteger readed_e;
@property(nonatomic,assign)BOOL       base_having;
@end
@implementation NSDataInputStream
- (instancetype)init{
    if(self=[super init]){
        self.readed_b=0;
        self.readed_e=0;
        self.data_b=[NSMutableData data];
        self.data_e=[NSMutableData data];
        self.base_having=true;
    }
    return self;
}
//- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
//    if(aStream==self.base&&eventCode==NSStreamEventEndEncountered){
//        return;
//    }
//    [super stream:aStream handleEvent:eventCode];
//}
- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len{
    NSInteger rlen=0;
    if(self.readed_b<self.data_b.length-1){
        rlen=dataccpy(buffer, 0, self.data_b, self.readed_b, len);
        self.readed_b+=rlen;
        buffer[rlen]=0;
        printf("%s",buffer);
        return rlen;
    }
    if(self.base_having&&self.base&&self.base.hasBytesAvailable){
        rlen = [self.base read:buffer maxLength:len];
        if(rlen>0){
            buffer[rlen]=0;
            printf("%s",buffer);
            return rlen;
        }
        self.base_having=false;
    }
    if(self.readed_e<self.data_e.length-1){
        rlen=dataccpy(buffer, 0, self.data_e, self.readed_e, len);
        self.readed_e+=rlen;
        buffer[rlen]=0;
        printf("%s",buffer);
        return rlen;
    }
    return -1;
    
}
//- (void)appendData:(NSData*)data{
//    [self.data_b appendData:data];
//}
//- (void)appendStr:(NSString*)data{
//    [self.data_b appendData:[data dataUsingEncoding:NSUTF8StringEncoding]];
//}
- (void)appendData:(NSData*)data end:(BOOL)end{
    if(end){
        [self.data_e appendData:data];
    }else{
        [self.data_b appendData:data];
    }
}
- (void)appendStr:(NSString*)data end:(BOOL)end{
    if(end){
        [self.data_e appendData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    }else{
        [self.data_b appendData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    }
}
- (BOOL)hasBytesAvailable{
    return self.readed_b<self.data_b.length-1 || [super hasBytesAvailable] || self.readed_e<self.data_e.length-1 ;
}
@end
