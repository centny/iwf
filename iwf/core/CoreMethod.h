//
//  CoreMethod.h
//  Centny
//
//  Created by Centny on 9/25/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// define some core method for log.

@protocol NSBoolable <NSObject>
@property (readonly) BOOL boolValue;
@end

FOUNDATION_EXPORT NSString *DocumentDirectory();


typedef void (^ CommonEvent)(id sender,id data, id msg);


FOUNDATION_EXPORT NSUInteger dataccpy(void *buf,NSUInteger boff, NSData* data,NSUInteger doff,NSUInteger len);

FOUNDATION_EXPORT void PrintStream(NSInputStream *is);
FOUNDATION_EXPORT NSData* toData(NSInputStream *is);

//new uuid string.
FOUNDATION_EXPORT NSString* nuuid();

//guess mime type, default is application/oct-stream when not found.
FOUNDATION_EXPORT NSString* mimetype(NSString* filename);

FOUNDATION_EXPORT void RunLoop(float sec);

FOUNDATION_EXPORT BOOL RunLoopv_(NSObject<NSBoolable> *mark,float delay,float timeout);

#define RunLoopv(mark) RunLoopv_(mark,0.5,5)
#define RunLoopx(mark) RunLoopv_(mark,0.5,500)


//FOUNDATION_EXPORT NSArray* MakeImgViews(CGRect frame, NSArray* urls,NSString* loading);