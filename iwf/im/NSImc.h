//
//  NSImc.h
//  iwf
//
//  Created by vty on 11/25/15.
//  Copyright © 2015 Snows. All rights reserved.
//

#import <iwf/iwf.h>

typedef void (^ NSImcEvnh)(NSIm* im, int evn, void* arga, void*argb);

@interface NSImc : NSIm <NSImH>
@property(nonatomic,readonly) int msgc;
@property(retain,readonly)NSDictionary* lres;
-(id)initWith:(NSString*)ip port:(NSString*)port;
-(void)run:(NSImcEvnh)evnh;
@end
