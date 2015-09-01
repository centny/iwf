//
//  CoreMethod.m
//  Centny
//
//  Created by Centny on 9/25/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "CoreMethod.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>
#import "../ext/ClassExt.h"

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
NSData* toData(NSInputStream *is){
    NSMutableData* data=[NSMutableData data];
    uint8_t buf[1025];
    NSInteger rlen=0;
    [is open];
    while (is.hasBytesAvailable) {
        rlen=[is read:buf maxLength:1024];
        buf[rlen]=0;
        [data appendBytes:buf length:rlen];
    }
    [is close];
    return data;
}
NSString* nuuid(){
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidStr = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidObject));
    CFRelease(uuidObject);
    return uuidStr;
}

NSString* mimetype(NSString* filename) {
    CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[filename pathExtension], NULL);
    CFStringRef type = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType);
    CFRelease(uti);
    if (type) {
        return (__bridge NSString *)(type);
    }else{
        return @"application/octet-stream";
    }
}

void RunLoop(float sec){
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:sec]];
}

BOOL RunLoopv_(NSObject<NSBoolable> *mark,float delay,float timeout){
    float used=0;
    while(!mark.boolValue){
        if(used>=timeout){
            return false;
        }
        RunLoop(delay);
        used+=delay;
    }
    return true;
}
//
//NSArray* MakeImgViews(CGRect frame, NSArray* urls,NSString* loading){
//    NSMutableArray* views=[NSMutableArray array];
//    for (NSString* url in urls) {
//        UIImageView *iv=[[UIImageView alloc]initWithFrame:frame];
//        iv.image=[UIImage imageNamed:loading];
//        iv.url=url;
//        [views addObject:iv];
//    }
//    return views;
//}