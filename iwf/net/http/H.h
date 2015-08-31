//
//  H.h
//  iwf
//
//  Created by Centny on 8/28/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iwf/iwf.h>
@interface H : NSObject

//
+ (void)doGet:(NSString *)url;
+ (void)doGet:(NSString *)url completed:(URLReqCompleted)finished;
+ (void)doGet:(NSString *)url args:(NSDictionary *)args completed:(URLReqCompleted)finished;
+ (void)doPost:(NSString *)url;
+ (void)doPost:(NSString *)url args:(NSString *)args;
+ (void)doPost:(NSString *)url dict:(NSDictionary *)dict;
+ (void)doPost:(NSString *)url completed:(URLReqCompleted)finished;
+ (void)doPost:(NSString *)url args:(NSString *)args completed:(URLReqCompleted)finished;
+ (void)doPost:(NSString *)url dict:(NSDictionary *)dict completed:(URLReqCompleted)finished;
+ (void)doPost:(NSString *)url dict:(NSDictionary *)dict sreq:(URLReqStart)sreq completed:(URLReqCompleted)finished;
@end
