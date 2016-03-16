//
//  H.h
//  iwf
//
//  Created by Centny on 8/28/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iwf/iwf.h>

typedef void (^ URLReqJsonCompleted)(URLRequester *req,NSData* data, NSDictionary* json, NSError *err);

@interface H : NSObject
+ (void)doGet:(NSString *)url completed:(URLReqCompleted)finished;
+ (void)doGet:(NSString *)url json:(URLReqJsonCompleted)finished;
+ (void)doGet:(URLReqCompleted)finished url:(NSString*)format,...;
+ (void)doGetj:(URLReqJsonCompleted)finished url:(NSString*)format,...;
+ (void)doGet:(NSString *)url args:(NSDictionary *)args completed:(URLReqCompleted)finished;
+ (void)doGet:(NSString *)url args:(NSDictionary *)args json:(URLReqJsonCompleted)finished;
//
//post
+ (void)doPost:(NSString *)url completed:(URLReqCompleted)finished;
+ (void)doPost:(NSString *)url json:(URLReqJsonCompleted)finished;
//post data.
+ (void)doPost:(NSString *)url json:(NSDictionary*)data completed:(URLReqCompleted)finished;
+ (void)doPost:(NSString *)url data:(NSData*)data completed:(URLReqCompleted)finished;
+ (void)doPost:(NSString *)url data:(NSData*)data type:(NSString*)type completed:(URLReqCompleted)finished;
+ (void)doPost:(NSString *)url json:(NSDictionary*)data json:(URLReqJsonCompleted)finished;
+ (void)doPost:(NSString *)url data:(NSData*)data json:(URLReqJsonCompleted)finished;
+ (void)doPost:(NSString *)url data:(NSData*)data type:(NSString*)type json:(URLReqJsonCompleted)finished;
//post stream.
//+ (void)doPost:(NSString *)url stream:(NSInputStream*)stream completed:(URLReqCompleted)finished;
//+ (void)doPost:(NSString *)url stream:(NSInputStream*)stream json:(URLReqJsonCompleted)finished;
//post application/x-www-form-urlencoded
+ (void)doPost:(NSString *)url sargs:(NSString *)args completed:(URLReqCompleted)finished;
+ (void)doPost:(NSString *)url sargs:(NSString *)args json:(URLReqJsonCompleted)finished;
+ (void)doPost:(NSString *)url json:(URLReqJsonCompleted)finished sargs:(NSString*)format,...;
+ (void)doPost:(NSString *)url dargs:(NSDictionary *)dargs completed:(URLReqCompleted)finished;
+ (void)doPost:(NSString *)url dargs:(NSDictionary *)dargs json:(URLReqJsonCompleted)finished;
+ (void)doPost:(NSString *)url dargs:(NSDictionary *)dargs sreq:(URLReqStart)sreq completed:(URLReqCompleted)finished;
+ (void)doPost:(NSString *)url dargs:(NSDictionary *)dargs sreq:(URLReqStart)sreq json:(URLReqJsonCompleted)finished;
@end
