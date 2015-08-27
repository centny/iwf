//
//  MultipartStream.h
//  iwf
//
//  Created by Centny on 8/27/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FPis;
//
@interface MultipartStream : NSInputStream
@property(nonatomic,readonly)NSString *bound;
@property(nonatomic,readonly)NSMutableArray *pis;//all FPis.
- (instancetype)initWithBound:(NSString*)bound;
- (void)addPis:(FPis*)pis;
@end
