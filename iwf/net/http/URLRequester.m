//
//  URLRequester.m
//  NCardSet
//
//  Created by Centny on 4/10/13.
//  Copyright (c) 2013 Centny. All rights reserved.
//

#import "URLRequester.h"
#import "ClassExt.h"
//#import "FPis.h"
#import <iwf/iwf.h>
#import <iwf/iwf-Swift.h>
//
const NSString* HC_C=@"C"; //cache only.
const NSString* HC_CN=@"CN"; //cache first.
const NSString* HC_N=@"N"; //normal http cache.
const NSString* HC_I=@"I"; //image cache.
const NSString* HC_NO=@"NO"; //image cache.
const NSString* HC_KEY=@"_hc_";

@implementation URLRequester
- (id)init
{
    self = [super init];
    
    if (self) {
        self.encoding	= NSUTF8StringEncoding;
        self.method		= @"GET";
        _timeout		= URL_TIME_OUT;
        _clength        = 0;
        _res_d			= [NSMutableData data];
        _args			= [NSMutableDictionary dictionary];
        _req_h			= [NSMutableDictionary dictionary];
        _res_h			= [NSMutableDictionary dictionary];
        _policy         = [NSString stringWithFormat:@"%@",HC_N];
        _policy_        = NSURLRequestUseProtocolCachePolicy;
        _multipart      = [MultipartBuilder builder];
    }
    
    return self;
}

- (NSString *)sdata
{
    if (self.res_d && self.res_d.length) {
        return [[NSString alloc] initWithData:self.res_d encoding:self.encoding];
    } else {
        return @"";
    }
}
- (NSInteger)statusCode
{
    return self.response.statusCode;
}

- (void)addURLArgs:(NSString *)args
{
    [self.args addEntriesFromDictionary:[args dictionaryByURLQuery]];
}

- (void)addDictArgs:(NSDictionary *)dict
{
    [self.args addEntriesFromDictionary:dict];
}

- (void)addArgBy:(NSString *)key value:(NSString *)value
{
    [self.args setObject:value forKey:key];
}

- (void)addHeaderField:(NSString *)key value:(NSString *)value
{
    [self.req_h setObject:value forKey:key];
}
- (NSString *)codingData:(NSStringEncoding)coding
{
    if (self.res_d && self.res_d.length) {
        return [[NSString alloc] initWithData:self.res_d encoding:coding];
    } else {
        return @"";
    }
}

- (void)start
{
    if ([@"GET" isEqualToString : self.method]) {
        if (self.args.count) {
            NSRange rg = [self.url rangeOfString:@"?"];
            
            if (rg.length < 1) {
                self.url = [NSString stringWithFormat:@"%@?%@", self.url, [self.args stringByURLQuery]];
            } else {
                self.url = [NSString stringWithFormat:@"%@&%@", self.url, [self.args stringByURLQuery]];
            }
        }
        NSDLog(@"GET %@",self.url);
        _request = [self createRequest];
    } else {
        NSDLog(@"POST %@->%@", self.url, [self.args stringByURLQuery]);
        _request = [self createRequest];
        if(self.streamBody){
            self.request.HTTPBodyStream=self.streamBody;
        }else if(self.body){
            self.request.HTTPBody=self.body;
        }else{
            NSInputStream* is=[self.multipart build];
            if(is){
                [self.request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",self.multipart.bound] forHTTPHeaderField:@"Content-Type"];
                self.request.HTTPBodyStream=is;
            }else{
                [self.request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                self.request.HTTPBody=[[self.args stringByURLQuery]dataUsingEncoding:self.encoding];
            }
        }
    }
    
    for (NSString *key in [self.req_h allKeys]) {
        [self.request setValue:[[self.req_h objectForKey:key]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forHTTPHeaderField:key];
    }
    [self onReqStart:self.request];
    _connection = [[NSURLConnection alloc]initWithRequest:self.request delegate:self startImmediately:YES];
}

- (void)cancel
{
    [self.connection cancel];
}

- (NSURL*)parsePolicy
{
    NSURL *url = [NSURL URLWithString:[self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableDictionary *args=[NSMutableDictionary dictionaryBy:url.query arySeparator:@"&" kvSeparator:@"="];
    if([args objectForKey:HC_KEY]){
        self.policy=[args objectForKey:HC_KEY];
        [args removeObjectForKey:HC_KEY];
        NSString* burl=[[self.url componentsSeparatedByString:@"?"]objectAtIndex:0];
        NSString* bargs=[args stringByURLQuery];
        if(bargs.length){
            self.url=[NSString stringWithFormat:@"%@?%@",burl,bargs];
        }else{
            self.url=burl;
        }
        url= [NSURL URLWithString:self.url];
    }
    if([self.args objectForKey:HC_KEY]){
        self.policy=[self.args objectForKey:HC_KEY];
        [self.args removeObjectForKey:HC_KEY];
    }
    if([HC_C isEqualToString:self.policy]){
        _policy_ = NSURLRequestReturnCacheDataDontLoad;
    }else if ([HC_CN isEqualToString:self.policy]){
        _policy_ = NSURLRequestReturnCacheDataElseLoad;
    }else if ([HC_NO isEqualToString:self.policy]){
        _policy_ = NSURLRequestReloadIgnoringLocalCacheData;
    }else if([HC_I isEqualToString:self.policy]){
        _policy_ = NSURLRequestReturnCacheDataElseLoad;
    }else{
        _policy_ = NSURLRequestUseProtocolCachePolicy;
    }
    return url;
}

- (NSMutableURLRequest *)createRequest
{
    NSURL				*url = [self parsePolicy];
    NSMutableURLRequest *request;
    request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:self.policy_ timeoutInterval:self.timeout];
    [request setHTTPMethod:self.method];
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _response = (NSHTTPURLResponse *)response;
    [((NSMutableDictionary *)self.res_h)addEntriesFromDictionary :[self.response allHeaderFields]];
    NSObject* cl=[self.res_h objectForKey:@"Content-Length"];
    if(cl&& [cl isKindOfClass:[NSString class]]){
        _clength = [((NSString*)cl)longLongValue];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [((NSMutableData *)self.res_d)appendData : data];
    [self onReqProcDown:self.res_d total:self.clength];
}

- (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    [self onReqProcUp:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpected:totalBytesExpectedToWrite];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self onReqCompleted:self.res_d err:nil];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSDLog(@"%@ %@ err:%@", self.method,self.url,error);
    [self onReqCompleted:self.res_d err:error];
    [self cancel];
}

- (void)onReqCompleted:(NSData*)data err:(NSError*)err{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onReqCompleted:data:err:)]) {
        [self.delegate onReqCompleted:self data:data err:err];
    }
    if (self.completed) {
        self.completed(self,data,err);
    }
}
- (void)onReqStart:(NSMutableURLRequest*) request{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onReqStart:request:)]) {
        [self.delegate onReqStart:self request:request];
    }
    if (self.onstart) {
        self.onstart(self,request);
    }
}
- (void)onReqProcUp:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpected:(NSInteger)totalBytesExpected{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onReqProcUp:bytesWritten:totalBytesWritten:totalBytesExpected:)]) {
        [self.delegate onReqProcUp:self bytesWritten:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpected:totalBytesExpected];
    }
    if (self.onup) {
        self.onup(self,bytesWritten,totalBytesWritten,totalBytesExpected);
    }
}
- (void)onReqProcDown:(NSData*)recv total:(NSInteger)total{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onReqProcDown:recv:total:)]) {
        [self.delegate onReqProcDown:self recv:recv total:total];
    }
    if (self.ondown) {
        self.ondown(self,recv,total);
    }
}
@end

