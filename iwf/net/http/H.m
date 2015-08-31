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

+ (void)doGet:(NSString *)url
{
    [H doGet:url completed:nil];
}

+ (void)doGet:(NSString *)url completed:(URLReqCompleted)finished
{
    [H doGet:url args:nil completed:finished];
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
+ (void)doPost:(NSString *)url
{
    [H doPost:url completed:nil];
}

+ (void)doPost:(NSString *)url args:(NSString *)args
{
    [H doPost:url args:args completed:nil];
}

+ (void)doPost:(NSString *)url dict:(NSDictionary *)dict
{
    [H doPost:url dict:dict completed:nil];
}

+ (void)doPost:(NSString *)url completed:(URLReqCompleted)finished
{
    URLRequester *req = [[URLRequester alloc]init];
    
    req.url			= url;
    req.method		= @"POST";
    req.completed	= finished;
    [req start];
}

+ (void)doPost:(NSString *)url args:(NSString *)args completed:(URLReqCompleted)finished
{
    URLRequester *req = [[URLRequester alloc]init];
    
    req.url		= url;
    req.method	= @"POST";
    [req addURLArgs:args];
    req.completed = finished;
    [req start];
}

+ (void)doPost:(NSString *)url dict:(NSDictionary *)dict completed:(URLReqCompleted)finished
{
    URLRequester *req = [[URLRequester alloc]init];
    
    req.url		= url;
    req.method	= @"POST";
    [req addDictArgs:dict];
    req.completed = finished;
    [req start];
}

+ (void)doPost:(NSString *)url dict:(NSDictionary *)dict sreq:(URLReqStart)sreq completed:(URLReqCompleted)finished
{
    URLRequester *req = [[URLRequester alloc]init];
    
    req.url		= url;
    req.method	= @"POST";
    [req addDictArgs:dict];
    req.onstart	= sreq;
    req.completed	= finished;
    [req start];
}

@end
