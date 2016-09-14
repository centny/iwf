//
//  H.m
//  iwf
//
//  Created by Centny on 8/28/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import "H.h"

@implementation H

//////
+ (URLReqCompleted)CovJson:(URLReqJsonCompleted)finished{
    return ^(URLRequester *req, NSData *data, NSError *err) {
        NSDictionary* dict=nil;
        NSError* terr=nil;
        if(data){
            dict=[data toJsonObject:&terr];
        }
        if(err==nil){
            err=terr;
        }
        finished(req,data,dict,err);
    };
}
+ (void)doGet:(NSString *)url completed:(URLReqCompleted)finished
{
    [H doGet:url args:nil completed:finished];
}
+ (void)doGet:(NSString *)url json:(URLReqJsonCompleted)finished{
    [H doGet:url completed:[H CovJson:finished]];
}
+ (void)doGet:(URLReqCompleted)finished url:(NSString*)format,...{
    va_list args;
    va_start(args, format);
    NSString *url=[[NSString alloc]initWithFormat:format arguments:args];
    va_end(args);
    [H doGet:url completed:finished];
}
+ (void)doGetj:(URLReqJsonCompleted)finished url:(NSString*)format,...{
    va_list args;
    va_start(args, format);
    NSString *url=[[NSString alloc]initWithFormat:format arguments:args];
    va_end(args);
    [H doGet:url json:finished];
}
+ (void)doGet:(NSString *)url args:(NSDictionary *)args completed:(URLReqCompleted)finished{
    URLRequester *req = [[URLRequester alloc]init];
    if(args){
        [req addDictArgs:args];
    }
    req.url			= url;
    req.method		= @"GET";
    req.completed	= finished;
    [req start];
}
+ (void)doGetThread:(NSString *)url args:(NSDictionary *)args completed:(URLReqCompleted)finished{
    URLRequester *req = [[URLRequester alloc]init];
    if(args){
        [req addDictArgs:args];
    }
    req.url			= url;
    req.method		= @"GET";
    req.completed	= finished;
    req.main        = NO;
    [req start];
}
+ (void)doGet:(NSString *)url args:(NSDictionary *)args json:(URLReqJsonCompleted)finished{
    [H doGet:url args:args completed:[H CovJson:finished]];
}
+ (void)doPost:(NSString *)url completed:(URLReqCompleted)finished
{
    URLRequester *req = [[URLRequester alloc]init];
    req.url			= url;
    req.method		= @"POST";
    req.completed	= finished;
    [req start];
}
+ (void)doPost:(NSString *)url json:(URLReqJsonCompleted)finished{
    [H doPost:url completed:[H CovJson:finished]];
}
+ (void)doPost:(NSString *)url json:(NSDictionary*)data completed:(URLReqCompleted)finished{
    [H doPost:url data:[data toJson:nil] type:@"application/json" completed:finished];
}
+ (void)doPost:(NSString *)url data:(NSData*)data completed:(URLReqCompleted)finished{
    [H doPost:url data:data type:@"application/octet-stream" completed:finished];
}
+ (void)doPost:(NSString *)url data:(NSData*)data type:(NSString*)type completed:(URLReqCompleted)finished{
    URLRequester *req = [[URLRequester alloc]init];
    req.url		= url;
    req.method	= @"POST";
    [req.req_h setObject:type forKey:@"Content-Type"];
    req.body=data;
    req.completed = finished;
    [req start];
}
+ (void)doPost:(NSString *)url json:(NSDictionary*)data json:(URLReqJsonCompleted)finished{
    [H doPost:url data:[data toJson:nil] type:@"application/json" json:finished];
}
+ (void)doPost:(NSString *)url data:(NSData*)data json:(URLReqJsonCompleted)finished{
    [H doPost:url data:data type:@"application/octet-stream" json:finished];
}
+ (void)doPost:(NSString *)url data:(NSData*)data type:(NSString*)type json:(URLReqJsonCompleted)finished{
    [H doPost:url data:data type:type completed:[H CovJson:finished]];
}
+ (void)doPost:(NSString *)url stream:(NSInputStream *)stream name:(NSString*)name filename:(NSString*)filename type:(NSString *)type fields:(NSDictionary*)fields  completed:(URLReqCompleted)finished{
    URLRequester *req = [[URLRequester alloc]init];
    req.url		= url;
    req.method	= @"POST";
    [req.multipart buildStream:stream name:name filename:filename type:type];
    if(fields){
        [req.multipart addArgs:fields];
    }
    req.completed = finished;
    [req start];
}
+ (void)doPost:(NSString *)url data:(NSData *)data name:(NSString*)name filename:(NSString*)filename type:(NSString *)type fields:(NSDictionary*)fields  completed:(URLReqCompleted)finished{
    URLRequester *req = [[URLRequester alloc]init];
    req.url		= url;
    req.method	= @"POST";
    [req.multipart buildData:data name:name filename:filename type:type];
    if(fields){
        [req.multipart addArgs:fields];
    }
    req.completed = finished;
    [req start];
}
+ (void)doPost:(NSString *)url stream:(NSInputStream *)stream name:(NSString*)name filename:(NSString*)filename type:(NSString *)type fields:(NSDictionary*)fields  json:(URLReqJsonCompleted)finished{
    [H doPost:url stream:stream name:name filename:filename type:type fields:nil completed:[H CovJson:finished]];
}
+ (void)doPost:(NSString *)url data:(NSData *)data name:(NSString*)name filename:(NSString*)filename type:(NSString *)type fields:(NSDictionary*)fields  json:(URLReqJsonCompleted)finished{
    [H doPost:url data:data name:name filename:filename type:type fields:nil completed:[H CovJson:finished]];
}
+ (void)doPost:(NSString *)url sargs:(NSString *)args completed:(URLReqCompleted)finished
{
    URLRequester *req = [[URLRequester alloc]init];
    req.url		= url;
    req.method	= @"POST";
    [req addURLArgs:args];
    req.completed = finished;
    [req start];
}

+ (void)doPost:(NSString *)url sargs:(NSString *)args json:(URLReqJsonCompleted)finished{
    [H doPost:url sargs:args completed:[H CovJson:finished]];
}
+ (void)doPost:(NSString *)url json:(URLReqJsonCompleted)finished sargs:(NSString*)format,...{
    va_list args;
    va_start(args, format);
    NSString *targs=[[NSString alloc]initWithFormat:format arguments:args];
    va_end(args);
    [H doPost:url sargs:targs json:finished];
}
+ (void)doPost:(NSString *)url dargs:(NSDictionary *)args completed:(URLReqCompleted)finished
{
    URLRequester *req = [[URLRequester alloc]init];
    req.url		= url;
    req.method	= @"POST";
    [req addDictArgs:args];
    req.completed = finished;
    [req start];
}
+ (void)doPost:(NSString *)url dargs:(NSDictionary *)dargs json:(URLReqJsonCompleted)finished{
    [H doPost:url dargs:dargs completed:[H CovJson:finished]];
}
+ (void)doPost:(NSString *)url dargs:(NSDictionary *)args sreq:(URLReqStart)sreq completed:(URLReqCompleted)finished
{
    URLRequester *req = [[URLRequester alloc]init];
    req.url		= url;
    req.method	= @"POST";
    [req addDictArgs:args];
    req.onstart	= sreq;
    req.completed	= finished;
    [req start];
}
+ (void)doPost:(NSString *)url dargs:(NSDictionary *)dargs sreq:(URLReqStart)sreq json:(URLReqJsonCompleted)finished{
    [H doPost:url dargs:dargs sreq:sreq completed:[H CovJson:finished]];
}
@end
