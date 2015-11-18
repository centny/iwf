//
//  NSImTest.m
//  iwf
//
//  Created by vty on 11/18/15.
//  Copyright © 2015 Snows. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSIm.h"
#import "OcL.h"
#import "ClassExt.h"
@interface NSImTest : XCTestCase<NSImH>
@property(retain) NSIm* im;
@property(retain) NSThread* thr;
@property(assign) int imc;
@end

@implementation NSImTest

- (void)setUp {
    [super setUp];
    self.im=[[NSIm alloc]initWith:@"127.0.0.1" port:9891];
    self.im.delegate=self;
    self.imc=0;
    self.thr=[[NSThread alloc]initWithTarget:self selector:@selector(run_im) object:nil];
    [self.thr start];
}
- (void)run_im{
    NSILog(@"%@",@"the im thread start");
    [self.im run:0];
    NSILog(@"%@",@"the im thread is done...");
}
-(int)onMsg:(NSIm*)im msg:(ImMsg*) msg{
    NSILog(@"receive message from %@->%@", msg.r, [msg.c UTF8String]);
    self.imc++;
    return 0;
}

- (void)tearDown {
    [super tearDown];
    [self.im close];
    sleep(1);
}

- (void)testIm {
    sleep(1);
    NSError* err=0;
    NSDictionary* lres=[self.im login:[NSDictionary dictionaryWithObjectsAndKeys:@"abc",@"token", nil] err:&err];
    if(err){
        XCTFail("%@",err);
        return;
    }
    [self.im ur:nil err:&err];
    if(err){
        XCTFail("%@",err);
        return;
    }
    NSString* r=[lres objectForKey:@"r"];
    NSDLog(@"login success to R:%@", r);
    for (int i=0; i<1000; i++) {
        NSString* ss=[NSString stringWithFormat:@"xxxx->%d",i];
        ImMsgBuilder* mb=[ImMsgBuilder new];
        [[[mb setRArray:[NSArray arrayWithObjects:@"S-Robot->x", nil]]setT:0]setC:[ss dataUsingEncoding:NSUTF8StringEncoding]];
        int code=[self.im sms:[mb build]];
        if(code!=0){
            XCTFail("return code->%d",code);
            return;
        }
    }
    while (self.imc<1001) {
        sleep(1);
    }
    [self.im logout:nil err:&err];
    if(err){
        XCTFail("%@",err);
        return;
    }
}

@end
