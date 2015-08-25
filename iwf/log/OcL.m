//
//  OcL.m
//  iwf
//
//  Created by Centny on 8/25/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import "OcL.h"
#import <iwf/iwf-Swift.h>

void SetLevel(int lvl){
    [LogImpl setLevel:lvl];
}
void SetLongf(bool lf){
    [LogImpl setLongf:lf];
}
void NSLogs(const char* file,int line,const char* func,int level,NSString* log){
    [LogImpl slog:[NSString stringWithUTF8String:file] line:line function:[NSString stringWithUTF8String:func]  level:level log:log];
}
//void Logv(NSString *file,int line,NSString *format NSString *format, ...)
//{
//        va_list args;
//        va_start(args, format);
//    LogImpl slog:__FILE__ line:<#(NSInteger)#> function:<#(NSString * __nonnull)#> longf:<#(BOOL)#> level:<#(NSInteger)#> log:<#(NSString * __nonnull)#>
//        NSLogv([NSString stringWithFormat:@"D %@", format], args);
//        va_end(args);
//}
//
//void NSRelLog(NSString *format, ...)
//{
//    if (__useRelLog) {
//        va_list args;
//        va_start(args, format);
//        NSLogv([NSString stringWithFormat:@"R %@", format], args);
//        va_end(args);
//    }
//}
//
//void NSWLog(NSString *format, ...)
//{
//    va_list args;
//    
//    va_start(args, format);
//    NSLogv([NSString stringWithFormat:@"W %@", format], args);
//    va_end(args);
//}
//
//void NSELog(NSString *format, ...)
//{
//    va_list args;
//    
//    va_start(args, format);
//    NSLogv([NSString stringWithFormat:@"E %@", format], args);
//    va_end(args);
//}