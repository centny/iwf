//
//  OcL.h
//  iwf
//
//  Created by Centny on 8/25/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LOG_D_ 10
#define LOG_I_ 20
#define LOG_W_ 30
#define LOG_E_ 40

//FOUNDATION_EXPORT void NSUseDLog(bool use);
//
//FOUNDATION_EXPORT void NSUseRelLog(bool use);

//FOUNDATION_EXPORT void NSDLog(NSString *format, ...);

//FOUNDATION_EXPORT void NSRelLog(NSString *format, ...);

//FOUNDATION_EXPORT void NSWLog(NSString *format, ...);
//
//FOUNDATION_EXPORT void NSELog(NSString *format, ...);

FOUNDATION_EXPORT void SetLevel(int lvl);
FOUNDATION_EXPORT void SetLongf(bool lf);


FOUNDATION_EXPORT void NSLogs(const char* file,int line,const char* func,int level,NSString* log);

#define NSDLog(format, args...) NSLogs(__FILE__,__LINE__,__func__,LOG_D_,[NSString stringWithFormat:format,args])
#define NSILog(format, args...) NSLogs(__FILE__,__LINE__,__func__,LOG_I_,[NSString stringWithFormat:format,args])
#define NSWLog(format, args...) NSLogs(__FILE__,__LINE__,__func__,LOG_W_,[NSString stringWithFormat:format,args])
#define NSELog(format, args...) NSLogs(__FILE__,__LINE__,__func__,LOG_E_,[NSString stringWithFormat:format,args])