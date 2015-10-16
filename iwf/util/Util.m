//
//  Util.m
//  iwf
//
//  Created by vty on 9/29/15.
//  Copyright © 2015 Snows. All rights reserved.
//

#import "Util.h"

@implementation Util
+(NSString*)homef:(NSString*)path{
    return [NSHomeDirectory() stringByAppendingFormat:@"/%@",path];
}
+(NSString*)readf_:(NSString*)path{
    return [self readf:[self homef:path]];
}
+(NSString*)readf:(NSString *)path{
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}
+(BOOL)writef_:(NSString*)path str:(NSString*)str{
    return [self writef:[self homef:path] str:str];
}
+(BOOL)writef_:(NSString*)path data:(NSData*)data{
    return [self writef:[self homef:path] data:data];
}
+(BOOL)writef:(NSString*)path str:(NSString*)str{
    return [self writef:path data:[str dataUsingEncoding:NSUTF8StringEncoding]];
}
+(BOOL)writef:(NSString*)path data:(NSData*)data{
    NSFileManager* fm=[NSFileManager defaultManager];
    NSString* dir=[self folder:path];
    if(![fm fileExistsAtPath:dir isDirectory:nil]){
        [fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [data writeToFile:path atomically:YES];
}
+(long)fsize_:(NSString *)path{
    return [self fsize_:[self homef:path]];
}
+(long)fsize:(NSString *)path{
    NSDictionary* attrs=[[NSFileManager defaultManager]attributesOfItemAtPath:path error:nil];
    NSNumber* fs=[attrs valueForKey:@"NSFileSize"];
    return [fs longLongValue];
}
+(NSString*)folder:(NSString*)path{
    return [[NSURL URLWithString:path]URLByDeletingLastPathComponent].path;
}
@end
