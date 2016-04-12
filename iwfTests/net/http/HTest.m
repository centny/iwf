//
//  HTest.m
//  iwf
//
//  Created by Centny on 8/28/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <iwf/iwf.h>
#import "Var.h"

@interface HTest : XCTestCase<NSBoolable>
@property (readonly) BOOL boolValue;
@property (nonatomic,assign)int excepted;
@property (nonatomic,assign)int ec;
@end

@implementation HTest

- (BOOL)boolValue{
    return self.ec==self.excepted;
}
- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGet {
    self.excepted=2;
    self.ec=0;
    URLReqJsonCompleted completed=^(URLRequester *req, NSData *data,NSDictionary *json, NSError *err) {
        if(err){
            NSELog(@"response err:%@", err);
            XCTAssert(false,"having error");
            self.ec++;
            return;
        }
        NSDLog(@"response json:%@", [data UTF8String]);
        XCTAssert([[json objectForKey:@"I"]isEqual:[NSNumber numberWithInt:1]],"code error");
        NSDLog(@"response data:%@", [json objectForKey:@"S"]);
        self.ec++;
    };
    //
    [H doGetj:completed url:@"%@/res_j?a=1&b=12&_hc_=%@",TS_SRV,HC_N];
    //
//    NSDictionary* args=[@"a=1&b=12&_hc_=N" dictionaryByURLQuery];
    NSMutableDictionary* args=[NSMutableDictionary dictionary];
    [args setObject:@"1" forKey:@"a"];
    [H doGet:[NSString stringWithFormat:@"%@/res_j",TS_SRV] args:args json:completed];
    //
    XCTAssert(RunLoopx(self), @"Timeout");
}

- (void)testPost{
    self.excepted=4;
    self.ec=0;
    URLReqJsonCompleted completed=^(URLRequester *req, NSData *data, NSDictionary* json, NSError *err) {
        if(err){
            NSELog(@"response err:%@", err);
            XCTAssert(false,"having error");
            self.ec++;
            return;
        }
        NSDLog(@"response json:%@", [data UTF8String]);
        XCTAssert([[json objectForKey:@"I"]isEqual:[NSNumber numberWithInt:1]],"code error");
        NSDLog(@"response data:%@", [json objectForKey:@"S"]);
        self.ec++;
    };
    [H doPost:[NSString stringWithFormat:@"%@/res_j",TS_SRV] json:completed];
    [H doPost:[NSString stringWithFormat:@"%@/res_j",TS_SRV] sargs:@"a=1&b=12&_hc_=N" json:completed];
    NSDictionary* args=[@"a=1&b=12&_hc_=N" dictionaryByURLQuery];
    [H doPost:[NSString stringWithFormat:@"%@/res_j",TS_SRV] dargs:args json:completed];
    [H doPost:[NSString stringWithFormat:@"%@/res_j",TS_SRV] dargs:args sreq:^(URLRequester *req, NSMutableURLRequest *request) {
        
    } json:completed];
    XCTAssert(RunLoopx(self), @"Timeout");
}

- (void)testPostJson{
    self.excepted=1;
    self.ec=0;
    URLReqJsonCompleted completed=^(URLRequester *req, NSData *data, NSDictionary* json, NSError *err) {
        if(err){
            NSELog(@"response err:%@", err);
            XCTAssert(false,"having error");
            self.ec++;
            return;
        }
        NSDLog(@"response json:%@", [data UTF8String]);
        XCTAssert([[json objectForKey:@"v1"]isEqual:@"a"],"code error");
        XCTAssert([[json objectForKey:@"v2"]isEqual:[NSNumber numberWithInt:1]],"code error");
        NSDLog(@"response data:%@", [json objectForKey:@"S"]);
        self.ec++;
    };
    NSDictionary *data=[NSDictionary dictionaryWithObjectsAndKeys:@"a",@"v1",[NSNumber numberWithInt:1],@"v2",nil];
    [H doPost:[NSString stringWithFormat:@"%@/data_j",TS_SRV] json:data json:completed];
    XCTAssert(RunLoopx(self), @"Timeout");
}

- (void)testPostJson2{
    self.excepted=1;
    self.ec=0;
    URLReqJsonCompleted completed=^(URLRequester *req, NSData *data, NSDictionary* json, NSError *err) {
        if(err){
            NSELog(@"response err:%@", err);
            XCTAssert(false,"having error");
            self.ec++;
            return;
        }
        NSDLog(@"response json:%@", [data UTF8String]);
        XCTAssert([[json objectForKey:@"v1"]isEqual:@"a"],"code error");
        XCTAssert([[json objectForKey:@"v2"]isEqual:[NSNumber numberWithInt:1]],"code error");
        NSDLog(@"response data:%@", [json objectForKey:@"S"]);
        self.ec++;
    };
    NSDictionary *data=[NSDictionary dictionaryWithObjectsAndKeys:@"a",@"v1",[NSNumber numberWithInt:1],@"v2",nil];
    [H doPost:[NSString stringWithFormat:@"%@/data_j2",TS_SRV] json:data json:completed];
    XCTAssert(RunLoopx(self), @"Timeout");
}

- (void)testPostJson3{
    self.excepted=1;
    self.ec=0;
    URLReqJsonCompleted completed=^(URLRequester *req, NSData *data, NSDictionary* json, NSError *err) {
        if(err){
            NSELog(@"response err:%@", err);
            XCTAssert(false,"having error");
            self.ec++;
            return;
        }
        NSDLog(@"response json:%@", [data UTF8String]);
        XCTAssert([[json objectForKey:@"code"]isEqual:[NSNumber numberWithInt:0]],"code error");
        NSDLog(@"response data:%@", [json objectForKey:@"S"]);
        self.ec++;
    };
//    NSDictionary *data=[NSDictionary dictionaryWithObjectsAndKeys:@"a",@"v1",[NSNumber numberWithInt:1],@"v2",nil];
    NSData* data=[@"{\"ownerType\":\"10\",\"pid\":\"D42\",\"type\":\"10\"}" dataUsingEncoding:NSUTF8StringEncoding];
    [H doPost:@"http://dms.dev.gdy.io/usr/api/createDiscuss?token=56E956C0BC9A3441F412ED6B" data:data json:completed];
    XCTAssert(RunLoopx(self), @"Timeout");
}

- (void)testPostDataF{
    self.excepted=1;
    self.ec=0;
    URLReqJsonCompleted completed=^(URLRequester *req, NSData *data, NSDictionary* json, NSError *err) {
        if(err){
            NSELog(@"response err:%@", err);
            NSELog(@"abc->%@", [data UTF8String]);
            XCTAssert(false,"having error");
            self.ec++;
            return;
        }
        NSDLog(@"response json:%@", [data UTF8String]);
        XCTAssert([[json objectForKey:@"code"]isEqual:[NSNumber numberWithInt:0]],"code error");
        XCTAssert([[json objectForKey:@"data"] length]>0,"code error");
        NSDLog(@"response data:%@", [json objectForKey:@"S"]);
        self.ec++;
    };
    //    NSDictionary *data=[NSDictionary dictionaryWithObjectsAndKeys:@"a",@"v1",[NSNumber numberWithInt:1],@"v2",nil];
    NSData* data=[@"abcdd" dataUsingEncoding:NSUTF8StringEncoding];
    [H doPost:@"http://fs.dev.gdy.io/usr/api/uload?token=570C6D3FBC9A3419370A60A1&pub=1" data:data name:@"file" filename:@"abc.txt" type:@"text/plain" fields:nil json:completed];
    XCTAssert(RunLoopx(self), @"Timeout");
}

- (void)testPostStreamF{
    self.excepted=1;
    self.ec=0;
    URLReqJsonCompleted completed=^(URLRequester *req, NSData *data, NSDictionary* json, NSError *err) {
        if(err){
            NSELog(@"response err:%@", err);
            NSELog(@"abc->%@", [data UTF8String]);
            XCTAssert(false,"having error");
            self.ec++;
            return;
        }
        NSDLog(@"response json:%@", [data UTF8String]);
        XCTAssert([[json objectForKey:@"code"]isEqual:[NSNumber numberWithInt:0]],"code error");
        XCTAssert([[json objectForKey:@"data"] length]>0,"code error");
        NSDLog(@"response data:%@", [json objectForKey:@"S"]);
        self.ec++;
    };
    //    NSDictionary *data=[NSDictionary dictionaryWithObjectsAndKeys:@"a",@"v1",[NSNumber numberWithInt:1],@"v2",nil];
    NSData* data=[@"abxcdd" dataUsingEncoding:NSUTF8StringEncoding];
    NSInputStream* stream=[NSInputStream inputStreamWithData:data];
    [H doPost:@"http://fs.dev.gdy.io/usr/api/uload?token=570C6D3FBC9A3419370A60A1&pub=1" stream:stream name:@"file" filename:@"abc.txt" type:@"text/plain" fields:nil json:completed];
    XCTAssert(RunLoopx(self), @"Timeout");
}
- (void)testJson{
    NSMutableDictionary* a=[NSMutableDictionary dictionary];
    NSMutableDictionary* b=[NSMutableDictionary dictionary];
    [b setObject:@"1" forKey:@"x1"];
    [b setObject:@"2" forKey:@"x2"];
    [a setObject:b forKey:@"data"];
    NSDLog(@"%@", [[a toJson:nil]UTF8String]);
    NSDLog(@"%@", [a valueForKeyPath:@"data.x1"]);
    NSDLog(@"%@", [a valueForKeyPath:@"data.x2"]);
}
- (void)testFail{
    self.excepted=1;
    self.ec=0;
    [H doGet:@"ssfs" completed:^(URLRequester *req, NSData *data, NSError *err) {
        if(err==nil){
            XCTAssert(false,@"not error");
        }
        self.ec++;
    }];
    XCTAssert(RunLoopx(self), @"Timeout");
}
@end
