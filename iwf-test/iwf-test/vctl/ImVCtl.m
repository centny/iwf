//
//  ImVCtl.m
//  iwf-test
//
//  Created by vty on 11/24/15.
//  Copyright © 2015 Snows. All rights reserved.
//

#import "ImVCtl.h"

@interface ImVCtl() <NSImH>
@property(retain) NSIm* im;
@property(retain) NSThread* thr;
@property(assign) int imc;
@property(assign) int done;
@property(retain) NSString* token;
@property(retain) NSDictionary* lres;
@end

@implementation ImVCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSIm init];
    self.im=[[NSIm alloc]initWith:@"192.168.2.57" port:@"4001"];
//    self.im=[[NSIm alloc]initWith:@"rcp.dev.gdy.io" port:@"14001"];
    self.im.delegate=self;
    self.imc=0;
    [self testIm];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.im stop];
}
-(int)onMsg:(NSIm*)im msg:(ImMsg*) msg{
    self.imc++;
    NSILog(@"receive message from %@->%@->%@->%d", msg.s, [msg.c UTF8String],[NSDate dateWithTimeIntervalSince1970:msg.time],self.imc);
    return 0;
}
-(void)onSckEvn:(NSIm *)im evn:(int)evn arga:(id)arga argb:(id)argb{
    switch (evn) {
        case V_CWF_NETW_SCK_EVN_RUN:
            NSILog(@"start runner->%d", evn);
            break;
        case V_CWF_NETW_SCK_EVN_CLOSED:
            NSILog(@"socket closed->%d", evn);
            self.done--;
            [self.im stop];
            self.im=nil;
            break;
        case V_CWF_NETW_SCK_EVN_CON_S:
            NSILog(@"start connect->%d", evn);
            break;
        case V_CWF_NETW_SCK_EVN_CON_D:
            NSILog(@"%@",@"V_CWF_NETW_SCK_EVN_CON_D");
        {
            int code=[argb intValue];
            if(code==0){
                NSILog(@"connected->%d->OK", evn);
                NSError* err;
                self.lres=[self.im login:[NSDictionary dictionaryWithObjectsAndKeys:self.token,@"token", nil] err:&err];
                if(err){
                    NSELog(@"%@",err);
                    self.done--;
                    return;
                }
                [self tIm_r];
            }else{
                NSILog(@"connected->%d->error-%d", evn,code);
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

- (void)testIm {
    self.done=1;
    [H doGetj:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if(err){
            NSELog(@"login error->%@", err);
            self.done--;
            return;
        }
        if([[json objectForKey:@"code"]intValue]!=0){
            NSELog(@"login error by code->%@", [json objectForKey:@"code"]);
            self.done--;
            return;
        }
        self.token=[[json objectForKey:@"data"] objectForKey:@"token"];
        [self.im start];
    } url:@"http://sso.dev.gdy.io/sso/api/login?usr=%@&pwd=%@&source=PC",@"c1",@"123456"];
//    XCTAssert(RunLoopx(self),@"timeout");
//    close(self.im.im->sck->fd);
//    self.done=1;
//    XCTAssert(RunLoopx(self),@"timeout");
    
}
- (void)tIm_t{
    NSThread *thr=[[NSThread alloc]initWithTarget:self selector:@selector(tIm_r) object:nil];
    [thr start];
}
- (void)tIm_r {
    NSError* err=0;
    [self.im ur:nil err:&err];
    if(err){
        NSELog(@"%@",err);
        self.done--;
        return;
    }
    NSString* r=[self.lres objectForKey:@"uid"];
    NSDLog(@"login success to R:%@", r);
    for (int i=0; i<10000; i++) {
        NSString* ss=[NSString stringWithFormat:@"xxxx->%d",i];
        ImMsgBuilder* mb=[ImMsgBuilder new];
        [[[mb setRArray:[NSArray arrayWithObjects:@"S-Robot->xx", nil]]setT:0]setC:[ss dataUsingEncoding:NSUTF8StringEncoding]];
        int code=[self.im sms:[mb build]];
        if(code!=0){
            NSELog(@"return code->%d",code);
            self.done--;
            return;
        }
    }
    while (self.imc<1000) {
        sleep(1);
    }
//        [self.im logout:[NSDictionary dictionaryWithObjectsAndKeys:self.token,@"token", nil] err:&err];
//        if(err){
//            XCTFail("%@",err);
//            self.done--;
//            return;
//        }
    self.done--;
    NSDLog(@"test im done by R:%@", r);
}
-(IBAction)clkSend:(id)sender{
    NSString* ss=[NSString stringWithFormat:@"xxxx->%d",0];
    ImMsgBuilder* mb=[ImMsgBuilder new];
    [[[mb setRArray:[NSArray arrayWithObjects:@"u41651", nil]]setT:0]setC:[ss dataUsingEncoding:NSUTF8StringEncoding]];
    int code=[self.im sms:[mb build]];
    if(code!=0){
        NSELog(@"return code->%d",code);
        self.done--;
        return;
    }
    NSDLog(@"%@", @"sending...");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
