//
//  NSImc.m
//  iwf
//
//  Created by vty on 11/25/15.
//  Copyright © 2015 Snows. All rights reserved.
//

#import "NSImc.h"

@implementation NSImc
-(id)initWith:(NSString *)ip port:(NSString*)port{
    if(self=[super initWith:ip port:port]){
        self.delegate=self;
    }
    return self;
}
-(int)onMsg:(NSIm*)im msg:(ImMsg*) msg{
    NSILog(@"receive message from(%@) by content:%@", msg.s,[msg.c UTF8String]);
    return 0;
}
-(void)onSckEvn:(NSIm*)im evn:(int)evn arga:(void*)arga argb:(void*)argb{
//    switch (evn) {
//        case V_CWF_NETW_SCK_EVN_RUN:
//            NSILog(@"start runner->%d", evn);
//            break;
//        case V_CWF_NETW_SCK_EVN_CLOSED:
//            NSILog(@"socket closed->%d", evn);
//            break;
//        case V_CWF_NETW_SCK_EVN_CON_S:
//            NSILog(@"start connect->%d", evn);
//            break;
//        case V_CWF_NETW_SCK_EVN_CON_D:{
//            NSILog(@"%@",@"V_CWF_NETW_SCK_EVN_CON_D");
//            int* code=(int*)argb;
//            if((*code)==0){
//                NSILog(@"connected->%d->OK", evn);
//                NSError* err;
//                self.lres=[self.im login:[NSDictionary dictionaryWithObjectsAndKeys:self.token,@"token", nil] err:&err];
//                if(err){
//                    self.done--;
//                    return;
//                }
//            }else{
//                NSILog(@"connected->%d->error-%d", evn,*code);
//                self.done--;
//            }
//        }
//            break;
//        case V_CWF_NETW_SCK_EVN_LR_S:
//            NSILog(@"start loop read->%d", evn);
//            break;
//        case V_CWF_NETW_SCK_EVN_LR_D:
//            NSILog(@"loop read done->%d", evn);
//            break;
//        default:
//            break;
//    }
}
-(void)run:(NSImcEvnh)evnh{
    
}
@end
