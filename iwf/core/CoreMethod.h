//
//  CoreMethod.h
//  Centny
//
//  Created by Centny on 9/25/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import <Foundation/Foundation.h>
// define some core method for log.

FOUNDATION_EXPORT NSString *DocumentDirectory();


typedef void (^ CommonEvent)(id sender,id data, id msg);


NSUInteger dataccpy(void *buf,NSUInteger boff, NSData* data,NSUInteger doff,NSUInteger len);

void PrintStream(NSInputStream *is);