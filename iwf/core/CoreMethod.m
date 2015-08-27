//
//  CoreMethod.m
//  Centny
//
//  Created by Centny on 9/25/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "CoreMethod.h"

NSString *DocumentDirectory()
{
	NSArray		*paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString	*documentsDirectory = [paths objectAtIndex:0];

	return documentsDirectory;
}

NSUInteger dataccpy(void *buf,NSUInteger boff, NSData* data,NSUInteger doff,NSUInteger len){
    NSUInteger rlen=len;
    if(doff+len>data.length){
        rlen=data.length-doff;
    }
    const void *dst=data.bytes+doff;
    memcpy(buf+boff, dst,rlen);
    return rlen;
}
void PrintStream(NSInputStream *is){
    uint8_t buf[1025];
    NSInteger rlen=0;
    [is open];
    while (is.hasBytesAvailable) {
        rlen=[is read:buf maxLength:1024];
        buf[rlen]=0;
        printf("%s",buf);
    }
    printf("\n");
    [is close];
}