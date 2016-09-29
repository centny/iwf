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

BOOL HTTPShouldHandleCookies_=YES;
NSOperationQueue *_queue_=nil;
NSMutableDictionary *_pending_=nil;
BOOL pending_on_add(URLRequester *req){
    if (_pending_==nil) {
        _pending_=[NSMutableDictionary dictionary];
    }
    @synchronized(_pending_){
        if([req.method isEqualToString:@"POST"]){
            return true;
        }
        NSString* url=req.fullUrl;
        NSMutableArray *pd=[_pending_ objectForKey:url];
        if (pd==nil) {
            pd=[NSMutableArray array];
        }
        [pd addObject:req];
        [_pending_ setObject:pd forKey:url];
        return pd.count<2;
    }
}
void pending_on_done(URLRequester *req,NSData* data,NSError* err){
    if([req.method isEqualToString:@"POST"]){
        return;
    }
    if (_pending_==nil) {
        NSELog(@"%@",@"the _pending_ is null, do you calling pending_on_done by yourself");
        return;
    }
    @synchronized(_pending_){
        NSString* url=req.fullUrl;
        NSMutableArray *pd=[_pending_ objectForKey:url];
        if (pd==nil) {
            NSELog(@"the _pending_ list for url(%@) is null, do you calling pending_on_done by yourself",url);
            return;
        }
        for (URLRequester *r in pd) {
            if(r==req){
                continue;
            }
            [r onReqCompleted:data err:err];
        }
        [pd removeAllObjects];
        [_pending_ removeObjectForKey:url];
    }
}
//
const NSString* HC_C=@"C"; //cache only.
const NSString* HC_CN=@"CN"; //cache first.
const NSString* HC_NC=@"NC"; //http first.
const NSString* HC_N=@"N"; //normal http cache.
const NSString* HC_I=@"I"; //image cache.
const NSString* HC_NO=@"NO"; //image cache.
const NSString* HC_KEY=@"_hc_";

@implementation URLRequester
+ (void)setQueue:(NSOperationQueue*)queue{
    _queue_=queue;
}
+ (void)setHTTPShouldHandleCookies:(BOOL)should{
    HTTPShouldHandleCookies_=should;
}
- (id)init
{
    self = [super init];
    
    if (self) {
        self.encoding	= NSUTF8StringEncoding;
        self.method		= @"GET";
        self.main       = YES;
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

-(NSString*) fullUrl{
    NSRange rg = [self.url rangeOfString:@"?"];
    
    if (rg.length < 1) {
        return [NSString stringWithFormat:@"%@?%@", self.url, [self.args stringByURLQuery]];
    } else {
        return [NSString stringWithFormat:@"%@&%@", self.url, [self.args stringByURLQuery]];
    }
}

- (void)start
{
    NSString* log;
    if ([@"GET" isEqualToString : self.method]) {
        if (self.args.count) {
            self.url=self.fullUrl;
        }
        log=[NSString stringWithFormat:@"GET %@",self.url];
        _request = [self createRequest];
        if([HC_I isEqualToString:self.policy]||[HC_CN isEqualToString:self.policy]){
            NSCachedURLResponse* res=[[NSURLCache sharedURLCache]cachedResponseForRequest:self.request];
            if (res){
                [self onReqCompleted:res.data err:nil];
                return;
            }
        }
    } else {
        log=[NSString stringWithFormat:@"POST %@->%@", self.url, [self.args stringByURLQuery]];
        if(self.streamBody){
            if (self.args.count) {
                self.url=self.fullUrl;
            }
            _request = [self createRequest];
            self.request.HTTPBodyStream=self.streamBody;
        }else if(self.body){
            if (self.args.count) {
                self.url=self.fullUrl;
            }
            _request = [self createRequest];
            self.request.HTTPBody=self.body;
        }else{
            NSInputStream* is=[self.multipart build];
            if(is){
                if (self.args.count) {
                    self.url=self.fullUrl;
                }
                _request = [self createRequest];
                [self.request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",self.multipart.bound] forHTTPHeaderField:@"Content-Type"];
                self.request.HTTPBodyStream=is;
            }else{
                _request = [self createRequest];
                [self.request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                self.request.HTTPBody=[[self.args stringByURLQuery]dataUsingEncoding:self.encoding];
            }
        }
    }
    
    for (NSString *key in [self.req_h allKeys]) {
        [self.request setValue:[[self.req_h objectForKey:key]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forHTTPHeaderField:key];
    }
    [self onReqStart:self.request];
    if(pending_on_add(self)){
        NSDLog(@"%@", log);
        _connection = [[NSURLConnection alloc]initWithRequest:self.request delegate:self startImmediately:false];
        if(_queue_){
            [_connection setDelegateQueue:_queue_];
        }
        [_connection start];
    }
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
    request.HTTPShouldHandleCookies=HTTPShouldHandleCookies_;
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
    pending_on_done(self, self.res_d, nil);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSDLog(@"%@ %@ err:%@", self.method,self.url,error);
    [self onReqCompleted:self.res_d err:error];
    [self cancel];
    pending_on_done(self, self.res_d, error);
}

- (void)onReqCompleted:(NSData*)data err:(NSError*)err{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onReqCompleted:data:err:)]) {
        [self.delegate onReqCompleted:self data:data err:err];
    }
    if ((self.completed&&err==nil)||![HC_NC isEqualToString:self.policy]) {
        [self doReqCompleted:data err:err];
        return;
    }
    NSCachedURLResponse* res=[[NSURLCache sharedURLCache]cachedResponseForRequest:self.request];
    if (res){
        data=res.data;
    }
    [self doReqCompleted:data err:err];
}
-(void)doReqCompleted:(NSData*)data err:(NSError*)err{
    if(self.main){
        [self performSelectorOnMainThread:@selector(onReqCompletedMain:) withObject:[NSArray arrayWithObjects:data,err, nil] waitUntilDone:NO];
    }else{
        self.completed(self,data,err);
    }
}
-(void)onReqCompletedMain:(NSArray*)args{
    NSError* err=nil;
    if(args.count>1){
        err=[args objectAtIndex:1];
    }
    self.completed(self,[args objectAtIndex:0],err);
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

