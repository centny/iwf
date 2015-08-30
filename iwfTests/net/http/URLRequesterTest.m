//
//  URLRequesterTest.m
//  iwf
//
//  Created by Centny on 8/28/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <iwf/iwf.h>
#import "Var.h"

@interface URLRequesterTest : XCTestCase<URLRequesterDelegate,NSBoolable>
@property (readonly) BOOL boolValue;
@property (nonatomic,assign)int excepted;
@property (nonatomic,assign)int ec;
@end

@implementation URLRequesterTest

- (BOOL)boolValue{
    return self.ec==self.excepted;
}
- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)doget1:(NSString*)hc{
    URLRequester *req=[[URLRequester alloc]init];
    req.url=[NSString stringWithFormat:@"%@/g_args?a=1&b=12&_hc_=%@",TS_SRV,hc];
    [req addArgBy:@"c" value:@"这是中文"];
    req.completed=^(URLRequester *req, NSData *data, NSError *err) {
        NSString* dok=[req codingData:NSUTF8StringEncoding];
        NSLog(@"onReqCompleted->%ld,%@",req.statusCode,dok);
        XCTAssert([dok isEqual:@"OK"],"response error");
        XCTAssert(req.statusCode==200,"response code is not 200");
        _ec++;
    };
    req.onstart=^(URLRequester *req, NSMutableURLRequest *request){
        NSLog(@"onReqStart");
    };
    req.onup=^(URLRequester *req, NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpected){
        NSLog(@"onReqProcUp->%ld",bytesWritten);
    };
    req.ondown=^(URLRequester *req, NSData * recv, NSInteger total){
        NSLog(@"onReqProcDown->%ld,%ld",recv.length,total);
    };
    req.delegate=self;
    [req start];
}
- (void)doget2:(NSString*)hc{
    URLRequester *req=[[URLRequester alloc]init];
    req.url=[NSString stringWithFormat:@"%@/g_argsc2?a=1&b=12",TS_SRV];
    [req addArgBy:HC_KEY value:hc];
    req.completed=^(URLRequester *req, NSData *data, NSError *err) {
        NSString* dok=[req codingData:NSUTF8StringEncoding];
        NSLog(@"onReqCompleted->%ld,%@->err:%@",req.statusCode,dok,err);
        XCTAssert([dok isEqual:@"OK"],"response error:%@",dok);
        _ec++;
    };
    req.onstart=^(URLRequester *req, NSMutableURLRequest *request){
        NSLog(@"onReqStart");
    };
    req.onup=^(URLRequester *req, NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpected){
        NSLog(@"onReqProcUp->%ld",bytesWritten);
    };
    req.ondown=^(URLRequester *req, NSData * recv, NSInteger total){
        NSLog(@"onReqProcDown->%ld,%ld",recv.length,total);
    };
    req.delegate=self;
    [req start];
}
- (void)testGet {
    NSURLCache *cache=[NSURLCache sharedURLCache];
    [cache setMemoryCapacity:10*1024*1024];
    NSLog(@"Used:%ld",cache.currentMemoryUsage);
    NSLog(@"%@-->%@",cache,NSHomeDirectory());
//    NSObject *mark=nil;
    self.excepted=2;
    self.ec=0;
    [self doget1:HC_NO];
    [self doget2:HC_NO];
    XCTAssert(RunLoopv(self),@"timeout");
    self.excepted=8;
    self.ec=0;
    [self doget1:HC_C];
    [self doget2:HC_C];
    [self doget1:HC_CN];
    [self doget2:HC_CN];
    [self doget1:HC_N];
    [self doget2:HC_N];
    [self doget1:HC_I];
    [self doget2:HC_I];
    XCTAssert(RunLoopv(self),@"timeout");
    NSLog(@"Used:%ld",[[NSURLCache sharedURLCache]currentMemoryUsage]);
}

- (void)dopost1:(NSString*)hc{
    URLRequester *req=[[URLRequester alloc]init];
    req.url=[NSString stringWithFormat:@"%@/p_args?xx=11&_hc_=%@",TS_SRV,hc];
    [req addArgBy:@"a" value:@"1"];
    [req addArgBy:@"b" value:@"12"];
    [req addArgBy:@"c" value:@"这是中文"];
    req.completed=^(URLRequester *req, NSData *data, NSError *err) {
        NSString* dok=[req codingData:NSUTF8StringEncoding];
        NSLog(@"onReqCompleted->%ld,%@",req.statusCode,dok);
        XCTAssert([dok isEqual:@"OK"],"response error");
        XCTAssert(req.statusCode==200,"response code is not 200");
        _ec++;
    };
    req.onstart=^(URLRequester *req, NSMutableURLRequest *request){
        NSLog(@"onReqStart");
    };
    req.onup=^(URLRequester *req, NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpected){
        NSLog(@"onReqProcUp->%ld",bytesWritten);
    };
    req.ondown=^(URLRequester *req, NSData * recv, NSInteger total){
        NSLog(@"onReqProcDown->%ld,%ld",recv.length,total);
    };
    req.delegate=self;
    req.method=@"POST";
    [req start];
}
- (void)dopost2:(NSString*)hc{
    URLRequester *req=[[URLRequester alloc]init];
    req.url=[NSString stringWithFormat:@"%@/h_args2?_hc_=%@",TS_SRV,hc];
    [req addHeaderField:@"a" value:@"1"];
    [req addHeaderField:@"b" value:@"12"];
    [req addHeaderField:@"c" value:@"这是中文"];
    req.completed=^(URLRequester *req, NSData *data, NSError *err) {
        NSString* dok=[req codingData:NSUTF8StringEncoding];
        NSString* xxk=[req.res_h objectForKey:@"Xxk"];
        NSLog(@"onReqCompleted->%ld,%@->%@",req.statusCode,dok,xxk);
        XCTAssert([dok isEqual:@"OK"],"response error");
        XCTAssert(req.statusCode==200,"response code is not 200");
        _ec++;
    };
    req.onstart=^(URLRequester *req, NSMutableURLRequest *request){
        NSLog(@"onReqStart");
    };
    req.onup=^(URLRequester *req, NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpected){
        NSLog(@"onReqProcUp->%ld",bytesWritten);
    };
    req.ondown=^(URLRequester *req, NSData * recv, NSInteger total){
        NSLog(@"onReqProcDown->%ld,%ld",recv.length,total);
    };
    req.delegate=self;
    req.method=@"POST";
    [req start];
}
- (void)testPost {
//    NSURLCache *cache=[NSURLCache sharedURLCache];
//    [cache setMemoryCapacity:10*1024*1024];
//    NSLog(@"Used:%ld",cache.currentMemoryUsage);
//    NSLog(@"%@-->%@",cache,NSHomeDirectory());
    //    NSObject *mark=nil;
    self.excepted=4;
    self.ec=0;
    [self dopost1:HC_N];
    [self dopost2:HC_N];
    [self dopost1:HC_NO];
    [self dopost2:HC_NO];
    XCTAssert(RunLoopv(self),@"timeout");
//    self.excepted=4;
//    self.ec=0;
//    [self dopost1:HC_C];
//    [self dopost2:HC_C];
//    [self dopost1:HC_CN];
//    [self dopost2:HC_CN];
//    [self dopost1:HC_I];
//    [self dopost2:HC_I];
//    [self dopost1:HC_NO];
//    [self dopost2:HC_NO];
//    RunLoopv(self);
    NSLog(@"Used:%ld",[[NSURLCache sharedURLCache]currentMemoryUsage]);
}
- (void)doupf1:(NSString*)hc{
    URLRequester *req=[[URLRequester alloc]init];
    req.url=[NSString stringWithFormat:@"%@/rec_f?_hc_=%@",TS_SRV,hc];
    [Util writef_:@"t.txt" str:@"testing"];
    [req.multipart buildPath:[Util homef:@"t.txt"] name:@"file"];
    [req.multipart addArgs:[NSDictionary dictionaryBy:@"a=1&b=12&c=这是中文" arySeparator:@"&" kvSeparator:@"="]];
    req.completed=^(URLRequester *req, NSData *data, NSError *err) {
        NSString* dok=[req codingData:NSUTF8StringEncoding];
        NSLog(@"onReqCompleted->%ld,%@",req.statusCode,dok);
        XCTAssert([dok isEqual:@"OK"],"response error");
        XCTAssert(req.statusCode==200,"response code is not 200");
        _ec++;
    };
    req.onstart=^(URLRequester *req, NSMutableURLRequest *request){
        NSLog(@"onReqStart");
    };
    req.onup=^(URLRequester *req, NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpected){
        NSLog(@"onReqProcUp->%ld",bytesWritten);
    };
    req.ondown=^(URLRequester *req, NSData * recv, NSInteger total){
        NSLog(@"onReqProcDown->%ld,%ld",recv.length,total);
    };
    req.delegate=self;
    req.method=@"POST";
    [req start];
}
- (void)doupf2:(NSString*)hc{
    URLRequester *req=[[URLRequester alloc]init];
    req.url=[NSString stringWithFormat:@"%@/rec_f?_hc_=%@",TS_SRV,hc];
    [Util writef_:@"t.txt" str:@"testing"];
    [req.multipart buildData:[NSData dataWithContentsOfFile:[Util homef:@"t.txt"]] name:@"file" filename:@"t.txx" type:@"plain/text"];
    [req.multipart addArgs:[NSDictionary dictionaryBy:@"a=1&b=12&c=这是中文" arySeparator:@"&" kvSeparator:@"="]];
//    PrintStream([req.multipart build]);
    req.completed=^(URLRequester *req, NSData *data, NSError *err) {
        NSString* dok=[req codingData:NSUTF8StringEncoding];
        NSLog(@"onReqCompleted->%ld,%@",req.statusCode,dok);
        XCTAssert([dok isEqual:@"OK"],"response error");
        XCTAssert(req.statusCode==200,"response code is not 200");
        _ec++;
    };
    req.onstart=^(URLRequester *req, NSMutableURLRequest *request){
        NSLog(@"onReqStart");
    };
    req.onup=^(URLRequester *req, NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpected){
        NSLog(@"onReqProcUp->%ld",bytesWritten);
    };
    req.ondown=^(URLRequester *req, NSData * recv, NSInteger total){
        NSLog(@"onReqProcDown->%ld,%ld",recv.length,total);
    };
    req.delegate=self;
    req.method=@"POST";
    [req start];
}
- (void)testUpF{
    self.excepted=2;
    self.ec=0;
    [self doupf1:HC_NO];
    [self doupf2:HC_NO];
    XCTAssert(RunLoopx(self),@"timeout");
}
- (void)onReqCompleted:(URLRequester*)req data:(NSData*)data err:(NSError*)err{
//    NSLog(@"onReqCompleted->%ld,%@",req.statusCode,[req codingData:NSUTF8StringEncoding]);
}
- (void)onReqStart:(URLRequester*)req request:(NSMutableURLRequest*) request{
    NSLog(@"onReqStart");
}
- (void)onReqProcUp:(URLRequester*)req bytesWritten:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpected:(NSInteger)totalBytesExpected{
    NSLog(@"onReqProcUp->%ld",bytesWritten);
}
- (void)onReqProcDown:(URLRequester*)req recv:(NSData*)recv total:(NSInteger)total{
    NSLog(@"onReqProcDown->%ld,%ld",recv.length,total);
}
@end
