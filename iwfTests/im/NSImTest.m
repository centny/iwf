//
//  NSImTest.m
//  iwf
//
//  Created by vty on 11/18/15.
//  Copyright © 2015 Snows. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <iwf/iwf.h>
@interface NSImTest : XCTestCase<NSImH,NSBoolable>
@property(retain) NSIm* im;
@property(retain) NSThread* thr;
@property(assign) int imc;
@property(assign) int done;
@property(retain) NSString* token;
@property(retain) NSDictionary* lres;
@end

@implementation NSImTest

- (BOOL)boolValue{
    return self.done<1;
}
- (void)setUp {
    [super setUp];
    self.im=[[NSIm alloc]initWith:@"14.23.162.172" port:19990];
    self.im.delegate=self;
    self.imc=0;
    self.thr=[[NSThread alloc]initWithTarget:self selector:@selector(run_im) object:nil];
//    [self.thr start];
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
-(void)onSckEvn:(NSIm *)im evn:(int)evn arga:(void *)arga argb:(void *)argb{
    switch (evn) {
        case V_CWF_NETW_SCK_EVN_RUN:
            NSILog(@"start runner->%d", evn);
            break;
        case V_CWF_NETW_SCK_EVN_CLOSED:
            NSILog(@"socket closed->%d", evn);
            break;
        case V_CWF_NETW_SCK_EVN_CON_S:
            NSILog(@"start connect->%d", evn);
            break;
        case V_CWF_NETW_SCK_EVN_CON_D:
            NSILog(@"%@",@"V_CWF_NETW_SCK_EVN_CON_D");
        {
            int* code=(int*)argb;
            if((*code)==0){
                NSILog(@"connected->%d->OK", evn);
                NSError* err;
                self.lres=[self.im login:[NSDictionary dictionaryWithObjectsAndKeys:self.token,@"token", nil] err:&err];
                if(err){
                    XCTFail("%@",err);
                    self.done--;
                    return;
                }
                [self tIm_r];
            }else{
                NSILog(@"connected->%d->error-%d", evn,*code);
                self.done--;
            }
        }
            break;
        case V_CWF_NETW_SCK_EVN_LR_S:
            NSILog(@"start loop read->%d", evn);
            break;
        case V_CWF_NETW_SCK_EVN_LR_D:
            NSILog(@"loop read done->%d", evn);
            break;
        default:
            break;
    }
}

- (void)tearDown {
    [super tearDown];
    [self.im close];
    sleep(1);
}

- (void)testIm {
    self.done=1;
    [H doGetj:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if(err){
            XCTFail(@"login error->%@", err);
            self.done--;
            return;
        }
        if([[json objectForKey:@"code"]intValue]!=0){
            XCTFail(@"login error by code->%@", [json objectForKey:@"code"]);
            self.done--;
            return;
        }
        self.token=[[json objectForKey:@"data"] objectForKey:@"token"];
        [self.thr start];
    } url:@"http://sso.dev.jxzy.com/sso/api/login?usr=%@&pwd=%@",@"testing",@"123"];
    XCTAssert(RunLoopv(self),@"timeout");
}
- (void)tIm_t{
    NSThread *thr=[[NSThread alloc]initWithTarget:self selector:@selector(tIm_r) object:nil];
    [thr start];
}
- (void)tIm_r {
    NSError* err=0;
    [self.im ur:nil err:&err];
    if(err){
        XCTFail("%@",err);
        self.done--;
        return;
    }
    NSString* r=[self.lres objectForKey:@"r"];
    NSDLog(@"login success to R:%@", r);
    for (int i=0; i<1000; i++) {
        NSString* ss=[NSString stringWithFormat:@"xxxx->%d",i];
        ImMsgBuilder* mb=[ImMsgBuilder new];
        [[[mb setRArray:[NSArray arrayWithObjects:@"S-Robot->x", nil]]setT:0]setC:[ss dataUsingEncoding:NSUTF8StringEncoding]];
        int code=[self.im sms:[mb build]];
        if(code!=0){
            XCTFail("return code->%d",code);
            self.done--;
            return;
        }
    }
    while (self.imc<1001) {
        sleep(1);
    }
    [self.im logout:[NSDictionary dictionaryWithObjectsAndKeys:self.token,@"token", nil] err:&err];
    if(err){
        XCTFail("%@",err);
        self.done--;
        return;
    }
    self.done--;
}

-(void)testChar{
    char a[2];
    a[1]=200;
    unsigned char xx=a[1];
    int x=xx;
    if(x!=200){
        XCTFail(@"error");
    }
}

@end
