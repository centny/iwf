//
//  Util.h
//  iwf
//
//  Created by vty on 9/29/15.
//  Copyright © 2015 Snows. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+(NSString*)homef:(NSString*)path;

//read file by path which releatived by home path.
+(NSString*)readf_:(NSString*)path;
//read file by path.
+(NSString*)readf:(NSString*)path;

//
+(BOOL)writef_:(NSString*)path str:(NSString*)str;
+(BOOL)writef_:(NSString*)path data:(NSData*)data;
+(BOOL)writef:(NSString*)path str:(NSString*)str;
+(BOOL)writef:(NSString*)path data:(NSData*)data;


+(long)fsize_:(NSString*)path;
+(long)fsize:(NSString*)path;

//
+(NSString*)folder:(NSString*)path;
@end
