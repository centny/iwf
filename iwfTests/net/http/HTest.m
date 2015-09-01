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
    NSDictionary* args=[@"a=1&b=12&_hc_=N" dictionaryByURLQuery];
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

@end
